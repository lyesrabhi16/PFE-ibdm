import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/page_navigation.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/data_representation.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:widget_arrows/widget_arrows.dart';

class DataList extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? label;
  final Function(DataRepresentation dataRepresentation)? onTap;
  Future<Map> Function(DateTime start, DateTime end, int page) getData;
  final String? title;
  DataList(
      {super.key,
      required this.getData,
      this.title,
      this.startDate,
      this.endDate,
      this.label,
      this.onTap});

  Function? _getContext;
  BuildContext get context => _getContext!.call()!;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  final RxBool loaded = false.obs;
  List<DataRepresentation>? data;

  int currentPage = 1;
  int nbrTotalPages = 1;
  int nbrShown = 0;
  int nbrTotal = 0;

  bool loading = false;

  final Rx<DateTime?> _startDate = Rx(null);
  final Rx<DateTime?> _endDate = Rx(null);

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    final startToday = DateTime.now().copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    final endToday = DateTime.now().copyWith(
      hour: 23,
      minute: 59,
      second: 59,
      millisecond: 999,
      microsecond: 999,
    );
    _startDate.value = (startDate ?? startToday);
    _endDate.value = (endDate ?? endToday);
    loadPage(int p) {
      load(
        page: p,
      );
    }

    return Obx(() {
      if (!loaded.value) {
        if (!loading) {
          load(
            startDate: _startDate.value,
            endDate: _endDate.value,
          );
        }

        return CircularProgressIndicatorWithText(text: strings.value.loading);
      }

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
            child: isAtMostSmallScreen(context)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: _rangePicker(),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: _rangePicker(),
                  ),
          ),
          const SizedBox(
            height: AppSizes.sm,
          ),
          PageNavigation(
              currentPage: currentPage,
              nbrTotalPages: nbrTotalPages,
              nbrShown: nbrShown,
              nbrTotal: nbrTotal,
              label: label ?? "DATA",
              onPagePress: loadPage,
              onPrevPress: loadPage,
              onNextPress: loadPage),
          Container(
            margin: const EdgeInsets.only(
              top: AppSizes.md,
            ),
            child: data != null
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      final splitString =
                          data![index].value.toString().split(" ");
                      return SettingCard(
                        title: splitString.first,
                        subtitle: splitString.last,
                        icon: data?[index].icon ?? LucideIcons.clock,
                        onTap: () => onTap?.call(data![index]),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            color: colorScheme.primary),
                      );
                    },
                  )
                : Text(strings.value.dataNotFound),
          )
        ],
      );
    });
  }

  List<Widget> _rangePicker() {
    final strings = getTranslations(context).obs;
    return [
      ArrowElement(
        id: "startDate",
        targetId: "endDate",
        sourceAnchor: isAtMostSmallScreen(context)
            ? Alignment.bottomCenter
            : Alignment.centerRight,
        targetAnchor: isAtMostSmallScreen(context)
            ? Alignment.topCenter
            : Alignment.centerLeft,
        child: ShadDatePicker(
            width: 160,
            height: 40,
            allowDeselection: false,
            icon: Icon(LucideIcons.calendar, size: 16),
            formatDate: (d) => "${d.day}/${d.month}/${d.year}",
            mainAxisAlignment: MainAxisAlignment.center,
            selected: _startDate.value,
            onChanged: (d) => _startDate.value = d!.copyWith(
                  hour: _startDate.value!.hour,
                  minute: _startDate.value!.minute,
                  second: _startDate.value!.second,
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
                  hour: _endDate.value!.hour,
                  minute: _endDate.value!.minute,
                  second: _endDate.value!.second,
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
        onPressed: () {
          load(startDate: _startDate.value, endDate: _endDate.value);
        },
        child: Text(strings.value.find.capitalize!),
      ),
    ];
  }

  void load({DateTime? startDate, DateTime? endDate, int page = 1}) async {
    loading = true;
    loaded.value = false;
    try {
      final res = await getData(
          startDate ?? _startDate.value!, endDate ?? _endDate.value!, page);
      data = res["data"];
      nbrTotalPages = res["total_pages"];
      nbrTotal = res["total_results"];
      currentPage = res["current_page"];
      nbrShown = ((currentPage - 1) * res["per_page"] + data!.length).toInt();
    } catch (e) {
      data = null;
      Toasts.showErrorToastNotification(
        context: Get.context!,
        message: getTranslations(Get.context!).failedToLoadData,
      );
    } finally {
      loaded.value = true;
      loading = false;
    }
  }
}
