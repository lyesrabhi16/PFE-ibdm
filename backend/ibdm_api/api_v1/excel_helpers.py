from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Border, Side
from openpyxl.utils import get_column_letter
from openpyxl import load_workbook
import os
import json

from ibdm_api.settings import BASE_DIR
from logs.logging import logger as logging
from .utils import ensurePathExists

def get_dict_from_excel_report(file_path):
    """
    Function to read JSON data from an Excel report.
    """
    ensurePathExists(file_path)
    # Example implementation
    try:
        if not os.path.isfile(file_path):
            raise FileNotFoundError(f"File {file_path} not found.")
        # Load Excel workbook
        wb = load_workbook(file_path)

        # Choose a specific sheet
        sheet = wb[wb.sheetnames[0]]

        # Find the number of rows and columns in the sheet
        rows = sheet.max_row
        columns = sheet.max_column

        # List to store all rows as dictionaries
        lst = {}
        # extract header info
        for i in range(1, 4):
            lst[sheet.cell(row=i, column=1).value] = sheet.cell(row=i, column=2).value

        # skip 1 empty row
        # extract data col names
        col_names = []
        for i in range(1, columns + 1):
            col_names.append(sheet.cell(row=5, column=i).value)
        lst["col_names"] = col_names
        data = []
        # extract data until next empty row
        last_data_row = 0
        for i in range(6, rows + 1):
            # check if row is empty
            empty = True
            for j in range(1, columns + 1):
                if sheet.cell(row=i, column=j).value is not None:
                    empty = False
                    break
            if empty:
                last_data_row = i - 1
                break

            # extract data
            row_data = {}
            row_danger = False
            row_highlight = False
            for j in range(1, columns + 1):
                row_data[col_names[j - 1]] = sheet.cell(row=i, column=j).value
                # check if row is highlighted
                if sheet.cell(row=i, column=j).fill.start_color.rgb == "00F3F3F3":
                    row_highlight = True
                # check if row is danger
                if sheet.cell(row=i, column=j).font.color and sheet.cell(row=i, column=1).font.color.rgb == "00FF0000":
                    row_danger = True
            row_data["danger"] = row_danger
            row_data["highlight"] = row_highlight
            data.append(row_data)
        
        lst["data"] = data

        # extract possible Synthèse
        if sheet.cell(row=last_data_row + 3, column=1).value is not None:
            lst["synthese"] = sheet.cell(row=last_data_row + 3, column=1).value
            
        
        return lst
    except Exception as e:
        print("Error reading JSON from Excel report:", e)
        return None


def generateExcelReport(
    data,
    filename,
    title,
    force=False,
):
    
    output_file = f"data/rapports/{filename}.xlsx"
    ensurePathExists(output_file)
    # check if report already exists
    if not force:
        exists = os.path.isfile(os.path.join(BASE_DIR, output_file))
        if exists:
            logging.info(f"re-using existing file {output_file}")
            return output_file

    # Create a new workbook and select the active worksheet
    wb = Workbook()
    ws = wb.active
    if not ws:
        raise ValueError("No active worksheet found!") 
    # Set the title of the worksheet
    ws.title = title
    ws.append(["Rapport", data["rapport_name"]])
    ws.append(["Interval", data["interval"]])
    ws.append(["Date", data["date"]])
    ws.append([])  # Add an empty row for spacing
    
    
    # Write the header row
    header_row = [header['title'] for header in data['headers']]
    ws.append(header_row)

    # Apply styling to the header row
    header_font = Font(bold=True, color="FFFFFF")
    header_fill = PatternFill(start_color="009879", end_color="009879", fill_type="solid")
    thin_border = Border(left=Side(style='thin'), right=Side(style='thin'), top=Side(style='thin'), bottom=Side(style='thin'))

    for col in range(1, len(header_row) + 1):
        cell = ws.cell(row=5, column=col)
        cell.font = header_font
        cell.fill = header_fill
        cell.border = thin_border

    # Write the data rows
    for row in data['rows']:
        row_data = []
        for code in data['header_codes']:
            value = row.get(code, '')
            if code in data['suffixes']:
                value = f"{value}{data['suffixes'][code]}"
            row_data.append(value)
        ws.append(row_data)

        # Apply conditional formatting
        row_index = ws.max_row
        if row == data["rows"][-1]:
            for col in range(1, len(row_data) + 1):
                cell = ws.cell(row=row_index, column=col)
                cell.fill = PatternFill(start_color="009879", end_color="009879", fill_type="solid")
                cell.font = Font(bold=True, color="FFFFFF")
        elif row.get('highlight'):
            for col in range(1, len(row_data) + 1):
                cell = ws.cell(row=row_index, column=col)
                cell.fill = PatternFill(start_color="F3F3F3", end_color="F3F3F3", fill_type="solid")
                cell.font = Font(bold=True, color="23db0b")
        if row.get('danger'):
            for col in range(1, len(row_data) + 1):
                cell = ws.cell(row=row_index, column=col)
                cell.font = Font(color="FF0000")

    if data.get("synthese", None) is not None:

        ws.append([])  # Add an empty row for spacing
        ws.append(["Synthèse"])
        ws.append([data['synthese']])

        # Apply styling to the synthese section
        synthese_font = Font(bold=True, color="009879")
        ws.cell(row=ws.max_row - 1, column=1).font = synthese_font

    # Adjust column widths
    for col in ws.columns:
        max_length = 0
        column = col[0].column_letter  # Get the column name
        for cell in col:
            try:
                if len(str(cell.value)) > max_length:
                    max_length = len(cell.value)
            except:
                pass
        adjusted_width = (max_length + 2) * 1.2
        ws.column_dimensions[column].width = adjusted_width

    # Save the workbook
    wb.save(output_file)

    logging.info(f"Excel file '{output_file}' created successfully!")
    
    return output_file