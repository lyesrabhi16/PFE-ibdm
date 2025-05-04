import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/data_representation.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:widget_arrows/widget_arrows.dart';

class DataList extends StatelessWidget {
  final List<DataRepresentation>? data;
  final DateTime? startDate;
  final DateTime? endDate;
  Future<List<DataRepresentation>> Function(DateTime start, DateTime end)
      getData;
  final String? title;
  DataList(
      {super.key,
      this.data,
      required this.getData,
      this.title,
      this.startDate,
      this.endDate});
  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context);
    final _startDate = (startDate ?? DateTime.now()).obs;
    final _endDate = (endDate ?? DateTime.now()).obs;
    return Column(
      children: [
        if (title != null)
          Text(
            title!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ArrowContainer(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              ArrowElement(
                id: "startDate",
                targetId: "endDate",
                sourceAnchor: Alignment.centerRight,
                targetAnchor: Alignment.centerLeft,
                child: ShadDatePicker(
                    width: 160,
                    height: 40,
                    allowDeselection: false,
                    icon: Icon(LucideIcons.calendar, size: 16),
                    formatDate: (d) => "${d.day}/${d.month}/${d.year}",
                    mainAxisAlignment: MainAxisAlignment.center,
                    selected: _startDate.value,
                    onChanged: (d) => _startDate.value = d!.copyWith(
                          hour: _startDate.value.hour,
                          minute: _startDate.value.minute,
                          second: _startDate.value.second,
                        )).marginSymmetric(
                  horizontal: AppSizes.sm,
                ),
              ).marginAll(AppSizes.md),
              ArrowElement(
                id: "endDate",
                child: ShadDatePicker(
                    width: 160,
                    height: 40,
                    allowDeselection: false,
                    icon: Icon(LucideIcons.calendar, size: 16),
                    formatDate: (d) => "${d.day}/${d.month}/${d.year}",
                    mainAxisAlignment: MainAxisAlignment.center,
                    selected: _endDate.value,
                    onChanged: (d) => _endDate.value = d!.copyWith(
                          hour: _endDate.value.hour,
                          minute: _endDate.value.minute,
                          second: _endDate.value.second,
                        )).marginSymmetric(
                  horizontal: AppSizes.sm,
                ),
              ).marginAll(AppSizes.md),
              ShadButton(
                width: 140,
                icon: Icon(
                  LucideIcons.search,
                  size: 16,
                ),
                child: Text(strings.find.capitalize!),
              ),
            ],
          ),
        ),
        if (data != null && data!.isEmpty)
          Center(
            child: Text(strings.dataNotFound),
          ),
        if (data != null && data!.isNotEmpty)
          for (var d in (data ?? []))
            SettingCard(icon: d.icon ?? LucideIcons.clock, title: d.value)
      ],
    );
  }
}
