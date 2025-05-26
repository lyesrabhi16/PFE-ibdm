from datetime import datetime
import re
from logs.logging import logger as logging
from .utils import get_existing_reports_from_disk
from api_v1.excel_helpers import get_dict_from_excel_report
from rest_framework import viewsets, permissions
from rest_framework.response import Response
from rest_framework.request import Request
from api_v1.custom_pagination import CustomPagination
from drf_spectacular.utils import extend_schema, OpenApiParameter
from api_v1.serializers import ErrorResponseSerializer
from .serializers import ReportSerializer
from api_v1.utils import with_operation_ids
from django.utils.dateparse import parse_datetime
from api_v1.emails.rapports.inventaire_sucre import rapport_inventaire_sucre
from api_v1.emails.rapports.utilite import rapport_utilite
from api_v1.emails.rapports.filtration import rapport_filtration
from api_v1.emails.rapports.co2 import rapport_co2
from rest_framework.decorators import api_view, permission_classes
@extend_schema(
    tags=["Reports"],
    summary="Get reports",
    request=None,
    parameters=[
        OpenApiParameter(
            name="reports_type",
            required=False,
            description="Type of reports to fetch",
            location=OpenApiParameter.QUERY,
            enum=[
                "Filtration",
                "sucre",
                "co2",
                "utilite"
            ],
        ),
        OpenApiParameter(
            name="search",
            required=False,
            description="Search term to filter reports",
            location=OpenApiParameter.QUERY,
            type=str,
        ),
        OpenApiParameter(
            name="ordering",
            required=False,
            description="Field to order results by (prefix with '-' for descending order) Date",
            location=OpenApiParameter.QUERY,
        ),
        OpenApiParameter(
            name="interval",
            required=False,
            description="Filter reports by specific interval value",
            location=OpenApiParameter.QUERY,
            type=str,
        ),
        OpenApiParameter(
            name="has_synthese",
            required=False,
            description="Filter reports by presence of Synthese field (true/false)",
            location=OpenApiParameter.QUERY,
            type=bool,
        ),
    ],
    responses={
        200: ReportSerializer(many=True),
        500: ErrorResponseSerializer,
    },
)
@with_operation_ids(
    on_list="getReports",
)
class ReportsViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]
    pagination_class = CustomPagination
    
    def list(self, request: Request):
        """
        List all reports with optional filtering and ordering
        """
        reports_dirname = request.query_params.get("reports_type", None)
        search_term = request.query_params.get("search", "").lower()
        ordering = request.query_params.get("ordering", "-Date")
        interval_filter = request.query_params.get("interval", None)
        has_synthese = request.query_params.get("has_synthese", None) # This will be a string, so we need to convert it to a boolean
        if has_synthese is not None:
            has_synthese = has_synthese.lower() == 'true'

        
        if reports_dirname is None:
            return Response({"error": "reports_type parameter is required"}, status=400)
        
        try:
            reports_paths = get_existing_reports_from_disk(reports_dirname)
            if reports_paths is None:
                return Response([], status=200)
            
            reports = []
            for report_path in reports_paths:
                report_json = get_dict_from_excel_report(report_path)
                if report_json is None:
                    logging.error(f"Failed to convert report {report_path} to JSON")
                    continue
                reports.append(report_json)
            
            # Apply filter by interval if provided
            if interval_filter:
                reports = [report for report in reports if 
                          "Interval" in report and 
                          str(report["Interval"]).lower() == interval_filter.lower()]
            
            # Apply filter by has_synthese if provided
            if has_synthese is not None:
                if has_synthese:
                    # Keep reports that have a non-empty Synthese field
                    reports = [report for report in reports if 
                              "synthese" in report and 
                              report["synthese"] and 
                              isinstance(report["synthese"], str) and 
                              report["synthese"].strip()]
                else:
                    # Keep reports that don't have a Synthese field or have an empty one
                    reports = [report for report in reports if 
                              "synthese" not in report or 
                              not report["synthese"] or 
                              (isinstance(report["synthese"], str) and not report["synthese"].strip())]
            
            # Apply search filtering if provided
            if search_term:
                filtered_reports = []
                for report in reports:
                    searchable_fields = ['Rapport', 'Date', 'Interval', 'synthese']
                    for field in searchable_fields:
                        if field in report and field == "Date":
                            # Convert datetime to string for comparison
                            report_date_str = report[field]
                            if search_term in report_date_str:
                                filtered_reports.append(report)
                                break
                            search_term_to_date = None
                            if "-" in search_term:
                                search_term_to_date = search_term.split("-")
                            elif "." in search_term:
                                search_term_to_date = search_term.split(".")
                            elif "/" in search_term:
                                search_term_to_date = search_term.split("/")

                            
                            if search_term_to_date is not None:
                                constained = []
                                report_date_list = report_date_str.split("-")
                                for item in search_term_to_date:
                                    if item in report_date_list:
                                        report_date_list.remove(item)
                                        constained.append(item)
                                if len(constained) == len(search_term_to_date):
                                    filtered_reports.append(report)
                                    break

                        elif field in report and isinstance(report[field], str) and search_term in report[field].lower():
                            filtered_reports.append(report)
                            break
                        
                reports = filtered_reports
            
            # Apply ordering if provided
            if ordering:
                reverse_order = False
                order_field = ordering
                
                if ordering.startswith('-'):
                    reverse_order = True
                    order_field = ordering[1:]
                
                # Sort the reports based on the ordering field
                # Use a try-except block in case some reports don't have the field
                try:
                    reports = sorted(reports, key=lambda x: x[order_field], reverse=reverse_order)
                except (TypeError, KeyError) as e:
                    logging.warning(f"Error ordering by {order_field}: {e}")
            
            reports = ReportSerializer(reports, many=True).data

            paginator = self.pagination_class()
            page = paginator.paginate_queryset(reports, request)
            if page is not None:
                return paginator.get_paginated_response(page)
            
            # If no pagination is applied, return all reports
            return Response(reports, status=200)
            
        except Exception as e:
            print(e)
            logging.error(f"Error fetching reports: {e}")
            return Response({"error": "Failed to fetch reports"}, status=500)
        


@extend_schema(
    tags=["Reports"],
    summary="Generate a report",
    operation_id="generateReport",
    request=None,
    parameters=[
        OpenApiParameter(
            name="date",
            required=True,
            description="Date for the report",
            location=OpenApiParameter.QUERY,
            type=str,
        ),
        OpenApiParameter(
            name="report_type",
            required=True,
            description="Type of report to generate",
            location=OpenApiParameter.QUERY,
            enum=[
                "inventaire-sucre",
                "utilite",
                "filtration",
                "co2_ifruit"
            ],
        ),
    ],
    responses={
        200: ReportSerializer(),
        400: ErrorResponseSerializer,
    },
)
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def generateReport(request: Request):
    """
    Generate a report based on the provided date
    """
    # Extract the date from the request
    date = request.query_params.get("date", None)
    report_type = request.query_params.get("report_type", None)
    if report_type is None:
        return Response({"error": "report_type parameter is required"}, status=400)
    if date is None:
        return Response({"error": "Date parameter is required"}, status=400)
    
    # Validate and parse the date format with django's date parser
    parsed_date = None
    try:
        parsed_date = parse_datetime(date)
        if parsed_date is None:
            raise ValueError("Invalid date format")    
    except ValueError as e:
        logging.error(f"Invalid date: {e}")
        return Response({"error": "Invalid date or date format"}, status=400)
    data = None
    match (report_type):
        case "inventaire-sucre":
            data = rapport_inventaire_sucre(render_to_HTML_string=False, date=parsed_date, force_recreate_excel_file=True)
        case "utilite":
            data = rapport_utilite(render_to_HTML_string=False, date=parsed_date, force_recreate_excel_file=True)
        case "filtration":
            data = rapport_filtration(render_to_HTML_string=False, date=parsed_date, force_recreate_excel_file=True)
        case "co2_ifruit":
            data = rapport_co2(render_to_HTML_string=False, date=parsed_date, force_recreate_excel_file=True)
        case _:
            raise ValueError(f"emailScheduler# rapport {report_type} not found")
    context : dict = data[0]
    report = {
        "Rapport": context["rapport_name"],
        "Date": context["date"],
        "Interval": context["interval"],
        "synthese": context["synthese"] if "synthese" in context else None,
        "col_names": context["header_codes"],
        "data": context["rows"],
    }
    return Response(ReportSerializer(report).data, status=200)