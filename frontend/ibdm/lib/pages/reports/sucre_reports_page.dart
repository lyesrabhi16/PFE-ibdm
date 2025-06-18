import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/page_navigation.dart';
import 'package:ibdm/common/widgets/per_page_input.dart';
import 'package:ibdm/common/widgets/scrollable_shad_sheet_container.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
import 'package:ibdm/pages/reports/reports_page.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/utils/sorter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SucreReportsPage extends StatefulWidget {
  const SucreReportsPage({super.key});

  @override
  State<SucreReportsPage> createState() => _SucreReportsPageState();
}

class _SucreReportsPageState extends State<SucreReportsPage> {
  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  final _showCheckboxColumn = false.obs;

  static final _searchController = TextEditingController();
  IbdmApiClient? api;
  final RxBool loaded = false.obs;
  final RxBool _isDataLoading = false.obs;

  RxList<Report> reports = <Report>[].obs;
  late PaginatedReportList reportsMeta;
  final _selectedReports = <Report>[].obs;

  int page = 1;

  String? intervalTagFilter;
  bool? hasSyntheseFilter;

  int? lastPerPage;
  String? lastSearch;

  static final _expandPerPage = false.obs;
  static final _perPageController = TextEditingController(text: "10");

  static final _filtersPopoverController = ShadPopoverController();
  static final _filtersActive = false.obs;

  static final _perPageFormKey = GlobalKey<FormState>();

  static final _tagFilterController = TextEditingController();
  static final _activationStateFilterController = TextEditingController();

  static final _sortPopoverController = ShadPopoverController();

  final RxMap<String, Sorter> _sortersASC = {
    "Date": Sorter(
      isSelected: false,
      orderingValue: "Date",
    ),
  }.obs;
  final RxMap<String, Sorter> _sortersDESC = {
    "Date": Sorter(
      isSelected: false,
      orderingValue: "-Date",
    ),
  }.obs;

  final _sortASC = true.obs;

  final _sortActive = false.obs;

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    return AppCustomContainer(
        backButton: true,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: max(context.height - AppSizes.heightOffset * 2, 600),
              maxHeight: max(context.height - AppSizes.heightOffset * 2, 600),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Obx(() {
                if (!loaded.value) {
                  load();
                  return CircularProgressIndicatorWithText(
                    text: strings.value.loading,
                  );
                }

                _showCheckboxColumn.value = _selectedReports.isNotEmpty;

                return Column(
                  children: [
                    Text(
                      strings.value.sucreReports,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    SizedBox(height: AppSizes.xl),
                    Container(
                      constraints: BoxConstraints(
                        minWidth: context.width,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadius),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.sm),
                        child: Wrap(
                          alignment: isAtMostSmallScreen(context)
                              ? WrapAlignment.center
                              : WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.horizontal,
                          runSpacing: AppSizes.sm,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            SearchBar(
                              controller: _searchController,
                              onSubmitted: (_) =>
                                  _searchController.text != lastSearch
                                      ? _loadReports()
                                      : null,
                              onTapOutside: (_) =>
                                  _searchController.text != lastSearch
                                      ? _loadReports()
                                      : null,
                              constraints: BoxConstraints(
                                maxWidth: AppSizes.lg * 8,
                                minHeight: AppSizes.lg * 1.5,
                                maxHeight: AppSizes.lg * 1.5,
                              ),
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer),
                              elevation: WidgetStatePropertyAll(0),
                              leading: Icon(Icons.search),
                              hintText: strings.value.search,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                ShadButton(
                                    backgroundColor:
                                        colorScheme.surfaceContainerLow,
                                    hoverBackgroundColor:
                                        colorScheme.surfaceContainerHighest,
                                    foregroundColor: colorScheme.onSurface,
                                    onPressed: () {
                                      _showGenerateReportDialog();
                                    },
                                    child: Text(strings.value.generateReport)),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: AppSizes.xl * 4,
                                    child: IconWithLabelButton(
                                      icon: Icons.settings,
                                      text: strings.value.options,
                                      onTap: () {
                                        showShadSheet(
                                            context: context,
                                            side: ShadSheetSide.right,
                                            isDismissible: true,
                                            builder: (context) {
                                              return ScrollableShadSheetContainer(
                                                child:
                                                    _topPageActionsSmallScreen(),
                                              );
                                            });
                                      },
                                    ),
                                  ),
                                ).removeWhen(isAtLeastMediumScreen(context)),
                              ].nonNulls.toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                          width: context.width,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadius),
                          ),
                          child: _topPageActions(
                            alignment: WrapAlignment.spaceBetween,
                            expandPerPage: _expandPerPage.value,
                            filtersPopoverController: _filtersPopoverController,
                            filtersActive: _filtersActive,
                            perPageFormKey: _perPageFormKey,
                            tagFilterController: _tagFilterController,
                            activationStateFilterController:
                                _activationStateFilterController,
                            sortPopoverController: _sortPopoverController,
                            sortASC: _sortASC,
                            sortActive: _sortActive,
                          ),
                        ).removeWhen(isAtMostSmallScreen(context)) ??
                        SizedBox.shrink(),
                    SizedBox(
                      height: AppSizes.sm,
                    ),
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: context.width,
                        ),
                        decoration: BoxDecoration(
                          //color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius:
                              BorderRadius.circular(AppSizes.borderRadius),
                        ),
                        child: _isDataLoading.value
                            ? CircularProgressIndicatorWithText(
                                text: strings.value.loadingReports,
                              )
                            : ListView(
                                children: getListViewItems(),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.sm,
                    ),
                    _bottomPageActions(
                      currentPage: reportsMeta.currentPage,
                      nbrTotalPages: reportsMeta.totalPages,
                      nbrShown: reportsMeta.data.length,
                      nbrTotal: reportsMeta.totalResults,
                      onPrevPress: (p) => {page = p, _loadReports()},
                      onNextPress: (p) => {page = p, _loadReports()},
                      onPagePress: (p) => {page = p, _loadReports()},
                      data: reports,
                      label: strings.value.reports,
                    )
                  ],
                );
              }),
            ),
          ),
        ));
  }

  _showGenerateReportDialog() {
    Report? report;
    final strings = getTranslations(context).obs;
    final pickedDateTime = false.obs;
    final Rx<DateTime> _selectedDate = DateTime.now().obs;

    final Rx<bool> _dataLoaded = false.obs;
    final Rx<bool> _failed = false.obs;
    int retries = 3;
    _getReport() async {
      _dataLoaded.value = false;

      try {
        report = await (await ApiClientInstance.getApiClient()).generateReport(
          date: _selectedDate.value.toIso8601String(),
          reportType: ReportType.inventaireSucre,
        );
        _failed.value = false;
        _dataLoaded.value = true;
      } catch (e) {
        if (retries > 0) {
          retries--;
          _getReport();
        } else {
          retries = 3;

          _failed.value = true;
          _dataLoaded.value = true;
          Toasts.showErrorToast(
            context: getContext,
            message: strings.value.failedToLoadData,
          );
        }
      }
    }

    return showShadDialog(
      context: getContext,
      builder: (context) => ShadDialog(
        title: Text(
          strings.value.generateReport,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        description: Text(strings.value.generateReportDescription),
        constraints: BoxConstraints(
          minWidth: min(context.width, 600),
          maxWidth: min(context.width, 600),
          minHeight: 600,
        ),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                ShadDatePicker(
                  onChanged: (value) => {
                    _selectedDate.value = value!,
                  },
                  closeOnSelection: false,
                  closeOnTapOutside: true,
                  selectableDayPredicate: (day) =>
                      day.isSameDayOrLower(DateTime.now()),
                  allowDeselection: false,
                  formatDate: (date) => DateFormat("dd-MM-yyyy").format(date),
                  selected: _selectedDate.value,
                  initialMonth: _selectedDate.value,
                ),
                ShadButton(
                  icon: Icon(LucideIcons.plus),
                  onPressed: () {
                    pickedDateTime.value = true;
                    _getReport();
                  },
                  child: Text(strings.value.generate),
                ),
              ],
            ),
            Obx(() {
              if (!pickedDateTime.value) {
                return SizedBox.shrink();
              }
              if (!_dataLoaded.value) {
                return SizedBox(
                    height: 600,
                    child: CircularProgressIndicatorWithText(
                      text: strings.value.loading,
                    ));
              }
              if (_failed.value) {
                return Text(strings.value.failedToGenerateReport);
              }
              return reportData(context, report!);
            })
          ],
        ),
      ).marginOnly(
        top: AppSizes.md,
      ),
    );
  }

  Widget _bottomPageActions({
    required int currentPage,
    required int nbrTotalPages,
    required int nbrShown,
    required int nbrTotal,
    required Function(int page) onPrevPress,
    required Function(int page) onNextPress,
    required Function(int page) onPagePress,
    required List<Object> data,
    required String label,
  }) {
    return PageNavigation(
      currentPage: currentPage,
      nbrTotalPages: nbrTotalPages,
      nbrShown: nbrShown,
      nbrTotal: nbrTotal,
      onPrevPress: onPrevPress,
      onNextPress: onNextPress,
      onPagePress: onPagePress,
      label: label,
    );
  }

  Future<void> _loadReports() async {
    final strings = getTranslations(context);
    _isDataLoading.value = true;
    _getOrdering() {
      return _sortASC.value
          ? _sortersASC.entries
              .where((e) => e.value.isSelected)
              .firstOrNull
              ?.value
              .orderingValue
          : _sortersDESC.entries
              .where((e) => e.value.isSelected)
              .firstOrNull
              ?.value
              .orderingValue;
    }

    // Load reports
    try {
      lastSearch = _searchController.text;
      lastPerPage = int.tryParse(_perPageController.text);
      reportsMeta = await api!.getReports(
        page: page,
        perPage: int.tryParse(_perPageController.text),
        reportsType: ReportsType.sucre,
        ordering: _getOrdering(),
        hasSynthese: hasSyntheseFilter,
        interval: intervalTagFilter,
        search:
            _searchController.text.isNotEmpty ? _searchController.text : null,
      );
      reports = reportsMeta.data.obs;
    } catch (e) {
      logger.e("Failed to load reports : $e");
      Toasts.showErrorToastNotification(
          context: context, message: strings.failedToLoadReports);
    }
    _isDataLoading.value = false;
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadReports();

    loaded.value = true;
  }

  _topPageActions({
    WrapAlignment alignment = WrapAlignment.spaceBetween,
    bool reverseOrder = false,
    bool expandPerPage = false,
    double? customExpandPerPage,
    required ShadPopoverController filtersPopoverController,
    required RxBool filtersActive,
    required GlobalKey<FormState> perPageFormKey,
    required TextEditingController tagFilterController,
    required TextEditingController activationStateFilterController,
    required ShadPopoverController sortPopoverController,
    required RxBool sortASC,
    required RxBool sortActive,
  }) {
    final context = getContext;
    final strings = getTranslations(context).obs;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Wrap(
        alignment: alignment,
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        verticalDirection: VerticalDirection.down,
        textDirection: reverseOrder ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // left row
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              // filter button
              SizedBox(
                width: AppSizes.xl * 4,
                child: ShadPopover(
                  controller: filtersPopoverController,
                  decoration: ShadDecoration(
                    border: ShadBorder.none,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  closeOnTapOutside: false,
                  popover: (context) => Container(
                    constraints: BoxConstraints(
                      minWidth: AppSizes.xl * 6,
                      maxWidth: AppSizes.xl * 8,
                      maxHeight: context.height * 0.4,
                    ),
                    child: SingleChildScrollView(
                      child: filterContent(context, tagFilterController,
                          activationStateFilterController),
                    ),
                  ),
                  child: IconWithLabelButton(
                    icon: Icons.filter_alt,
                    active: filtersActive.value,
                    text: strings.value.filter,
                    onTap: () {
                      filtersActive.value = !filtersActive.value;
                      filtersPopoverController.toggle();
                    },
                  ),
                ),
              ),
              // sort button
              SizedBox(
                width: AppSizes.xl * 4,
                child: ShadPopover(
                  controller: sortPopoverController,
                  decoration: ShadDecoration(
                    border: ShadBorder.none,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  closeOnTapOutside: false,
                  popover: (context) => ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: AppSizes.xl * 6,
                      maxWidth: AppSizes.xl * 8,
                      maxHeight: context.height * 0.4,
                    ),
                    child: SingleChildScrollView(
                      child: sortContent(
                        context: context,
                        sortASC: sortASC,
                      ),
                    ),
                  ),
                  child: IconWithLabelButton(
                    icon: Icons.sort_rounded,
                    active: sortActive.value,
                    text: strings.value.sort,
                    onTap: () {
                      sortActive.value = !sortActive.value;
                      _sortPopoverController.toggle();
                    },
                  ),
                ),
              ),
              // PerPage TextField
              SizedBox(
                width: _expandPerPage.value
                    ? customExpandPerPage ?? AppSizes.xl * 8
                    : AppSizes.xl * 3,
                child: PerPageInput(
                  expandPerPage: _expandPerPage,
                  perPageController: _perPageController,
                  perPage: int.tryParse(_perPageController.text)!,
                  load: () => _perPageController.text != lastPerPage.toString()
                      ? _loadReports()
                      : null,
                ),
              ),
            ],
          ),
          //right refresh button
          SizedBox(
            width: AppSizes.xl * 5,
            child: IconWithLabelButton(
              icon: Icons.refresh_rounded,
              onTap: _loadReports,
              text: strings.value.refresh,
            ),
          ),
        ],
      ),
    );
  }

  Obx sortContent({
    required BuildContext context,
    required RxBool sortASC,
  }) {
    void setSorter(String s, bool selected) {
      if (_sortASC.value) {
        for (var sorter in _sortersASC.entries) {
          if (sorter.key.toLowerCase() == s.toLowerCase()) {
            _sortersASC[s] = Sorter(
                isSelected: selected,
                orderingValue: sorter.value.orderingValue);
            _loadReports();
          } else {
            _sortersASC[sorter.key] = Sorter(
                isSelected: false, orderingValue: sorter.value.orderingValue);
          }
        }
      } else {
        for (var sorter in _sortersDESC.entries) {
          if (sorter.key.toLowerCase() == s.toLowerCase()) {
            _sortersDESC[s] = Sorter(
                isSelected: selected,
                orderingValue: sorter.value.orderingValue);
            _loadReports();
          } else {
            _sortersDESC[sorter.key] = Sorter(
                isSelected: false, orderingValue: sorter.value.orderingValue);
          }
        }
      }
    }

    _switchSorters({
      required RxBool sortASC,
      required RxMap<String, Sorter> sortersASC,
      required RxMap<String, Sorter> sortersDESC,
    }) {
      if (sortASC.value) {
        for (var s in _sortersASC.entries) {
          if (s.value.isSelected) {
            sortersDESC[s.key] = Sorter(
                isSelected: true,
                orderingValue: sortersDESC[s.key]!.orderingValue);
            sortersASC[s.key] =
                Sorter(isSelected: false, orderingValue: s.value.orderingValue);
          }
        }
      } else {
        for (var s in _sortersDESC.entries) {
          if (s.value.isSelected) {
            sortersASC[s.key] = Sorter(
                isSelected: true,
                orderingValue: sortersASC[s.key]!.orderingValue);
            sortersDESC[s.key] =
                Sorter(isSelected: false, orderingValue: s.value.orderingValue);
          }
        }
      }
    }

    bool _checkIfLoadIsNeeded({
      required RxMap<String, Sorter> sortersASC,
      required RxMap<String, Sorter> sortersDESC,
    }) {
      final sortASCActive =
          _sortersASC.entries.where((e) => e.value.isSelected).firstOrNull?.key;
      final sortDescActive = _sortersDESC.entries
          .where((e) => e.value.isSelected)
          .firstOrNull
          ?.key;
      if (sortASCActive == null && sortDescActive == null) {
        return false;
      }
      return true;
    }

    final strings = getTranslations(context).obs;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(strings.value.sort,
              style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(
            height: AppSizes.sm,
          ),
          Text(strings.value.sortReports,
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(
            height: AppSizes.sm,
          ),
          Divider(),
          SizedBox(
            height: AppSizes.md,
          ),
          Text("${strings.value.order} :",
              style: Theme.of(context).textTheme.bodyMedium),
          ShadSelect(
            initialValue:
                sortASC.value ? strings.value.asc : strings.value.desc,
            options: [
              ShadOption(
                  value: strings.value.asc,
                  child: Text(strings.value.asc.toUpperCase())),
              ShadOption(
                  value: strings.value.desc,
                  child: Text(strings.value.desc.toUpperCase())),
            ],
            selectedOptionBuilder: (context, value) => Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onChanged: (value) {
              bool doLoad = _checkIfLoadIsNeeded(
                sortersASC: _sortersASC,
                sortersDESC: _sortersDESC,
              );
              _switchSorters(
                sortASC: sortASC,
                sortersASC: _sortersASC,
                sortersDESC: _sortersDESC,
              );
              sortASC.value = value == strings.value.asc;
              if (doLoad) {
                _loadReports();
              }
            },
          ),
          SizedBox(
            height: AppSizes.sm,
          ),
          Text("${strings.value.sortBy} :",
              style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(
            height: AppSizes.sm,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _sortersASC.keys
                .map(
                  (sorter) => ShadSwitch(
                    uncheckedTrackColor:
                        Theme.of(context).colorScheme.surfaceDim,
                    checkedTrackColor: Theme.of(context).colorScheme.primary,
                    value: (sortASC.value
                        ? _sortersASC[sorter]!.isSelected
                        : _sortersDESC[sorter]!.isSelected),
                    label: Text(
                      sorter.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onChanged: (value) => setSorter(sorter, value),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Column filterContent(
      BuildContext context,
      TextEditingController intervalFilterController,
      TextEditingController hasSyntheseFilterController) {
    final strings = getTranslations(context).obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(strings.value.filters,
            style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        Text(strings.value.filterReports,
            style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(
          height: AppSizes.sm,
        ),
        Divider(),
        SizedBox(
          height: AppSizes.md,
        ),
        Text(strings.value.filterByMonitoredValueTag,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        DropdownMenu<String>(
          hintText: strings.value.filterByInterval,
          label: Text(strings.value.interval),
          controller: intervalFilterController,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
          initialSelection: intervalTagFilter,
          width: AppSizes.xl * 8,
          enableFilter: false,
          enableSearch: false,
          requestFocusOnTap: false,
          onSelected: (value) {
            // filter by monitored value tag
            if (intervalTagFilter == value) {
              intervalFilterController.clear();
              intervalTagFilter = null;
              _loadReports();
              return;
            }
            intervalTagFilter = value;
            _loadReports();
          },
          dropdownMenuEntries: IntervalEnum.values
              .where((e) => e != IntervalEnum.$unknown)
              .map(
                (e) => DropdownMenuEntry(
                  value: e.json!,
                  label: strings.value.getIntervalName(e.json ?? ""),
                ),
              )
              .toList(),
        ),
        Text(strings.value.filterByActivationState,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        DropdownMenu<bool>(
          hintText: strings.value.hasSynthese,
          label: Text(strings.value.hasSynthese),
          controller: hasSyntheseFilterController,
          width: AppSizes.xl * 8,
          enableFilter: false,
          enableSearch: false,
          requestFocusOnTap: false,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
          initialSelection: hasSyntheseFilter,
          onSelected: (value) {
            // filter by monitored value tag
            if (hasSyntheseFilter == value) {
              hasSyntheseFilterController.clear();
              hasSyntheseFilter = null;
              _loadReports();
              return;
            }
            hasSyntheseFilter = value;
            _loadReports();
          },
          dropdownMenuEntries: [
            DropdownMenuEntry(
              value: true,
              label: strings.value.withSynthese,
            ),
            DropdownMenuEntry(
              value: false,
              label: strings.value.withoutSynthese,
            ),
          ],
        ),
      ],
    );
  }

  _topPageActionsSmallScreen() {
    final strings = getTranslations(context).obs;
    return Column(
      children: [
        //right refresh button
        IconWithLabelButton(
          icon: Icons.refresh_rounded,
          onTap: _loadReports,
          text: strings.value.refresh,
        ),

        SizedBox(
          height: AppSizes.sm,
        ),
        PerPageInput(
          expandPerPage: _expandPerPage,
          perPageController: _perPageController,
          load: () => _perPageController.text != lastPerPage.toString()
              ? _loadReports()
              : null,
        ),
        SizedBox(
          height: AppSizes.lg,
        ),
        DividerWithText(text: strings.value.filter),
        filterContent(
            context, _tagFilterController, _activationStateFilterController),
        SizedBox(
          height: AppSizes.xl,
        ),
        DividerWithText(text: strings.value.sort),
        sortContent(
          context: context,
          sortASC: _sortASC,
        ),
      ],
    );
  }

  getListViewItems() {
    return reports.map((report) {
      return SettingCard(
        icon: LucideIcons.fileText,
        onTap: () => showViewReportDialog(context, report),
        title:
            "${report.rapport} - ${DateFormat('dd-MM-yyyy').format(report.date)}",
      );
    }).toList();
  }
}
