import 'package:flutter/material.dart';
import 'package:ibdm/common/widgets/data_list.dart';
import 'package:ibdm/utils/helpers/data_representation.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MultipleDataLists extends StatelessWidget {
  final List<DataListTab> tabs;

  const MultipleDataLists({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    logger.d("build MultipleDataLists");
    return ShadTabs(
      tabs: tabs
          .map((tab) => ShadTab(
                value: tab.name,
                icon: Icon(Icons.list),
                content: DataList(
                  onTap: tab.onTap,
                  getData: (start, end, page) => tab.getData!(start, end, page),
                ),
                child: Text(tab.name),
              ))
          .toList(),
      value: tabs.first.name,
    );
  }
}

class DataListTab {
  final String name;
  final Function(DataRepresentation dataRepresentation)? onTap;
  final Future<Map> Function(DateTime startDate, DateTime endDate, int page)?
      getData;

  DataListTab({
    required this.name,
    this.getData,
    this.onTap,
  });
}
