import 'dart:ui';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/common/widgets/email_schedule_form.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/per_page_input.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/pages/settings/emails/actions.dart';
import 'package:ibdm/pages/users.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart' as API_CLIENT;
import 'package:ibdm/services/api_django/api_client/models/email_schedule.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/page_index.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';

class EmailSchedulesPage extends StatefulWidget {
  const EmailSchedulesPage({super.key});

  @override
  State<EmailSchedulesPage> createState() => _EmailSchedulesPageState();
}

class _EmailSchedulesPageState extends State<EmailSchedulesPage> {
  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  final _showCheckboxColumn = false.obs;

  static final _searchController = TextEditingController();
  API_CLIENT.IbdmApiClient? api;
  final RxBool loaded = false.obs;
  final RxBool _isDataLoading = false.obs;

  RxList<API_CLIENT.EmailSchedule> schedules = <API_CLIENT.EmailSchedule>[].obs;
  late API_CLIENT.PaginatedEmailScheduleList schedulesMeta;
  final _selectedSchedules = <API_CLIENT.EmailSchedule>[].obs;
  final GlobalKey<ShadFormState> _formKey = GlobalKey<ShadFormState>();

  int page = 1;
  API_CLIENT.RapportEnum? rapportFilter;
  API_CLIENT.IntervalEnum? intervalFilter;

  static final _expandPerPage = false.obs;
  static final _perPageController = TextEditingController(text: "10");
  int? lastPerPage;
  String? lastSearch;

  static final _filtersPopoverController = ShadPopoverController();
  static final _filtersActive = false.obs;

  static final _perPageFormKey = GlobalKey<FormState>();

  static final _tagFilterController = TextEditingController();
  static final _activationStateFilterController = TextEditingController();

  static final _sortPopoverController = ShadPopoverController();

  final RxMap<String, Sorter> _sortersASC = {
    "Rapport": Sorter(
      isSelected: false,
      orderingValue: "rapport",
    ),
    "Interval": Sorter(
      isSelected: false,
      orderingValue: "interval_manual",
    ),
    "Temps d'Envoi": Sorter(
      isSelected: false,
      orderingValue: "temps_envoi",
    ),
  }.obs;
  final RxMap<String, Sorter> _sortersDESC = {
    "Rapport": Sorter(
      isSelected: false,
      orderingValue: "-rapport",
    ),
    "Interval": Sorter(
      isSelected: false,
      orderingValue: "-interval_manual",
    ),
    "Temps d'Envoi": Sorter(
      isSelected: false,
      orderingValue: "-temps_envoi",
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
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Obx(() {
            if (!loaded.value) {
              load();
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            _showCheckboxColumn.value = _selectedSchedules.isNotEmpty;

            return Column(
              children: [
                Obx(() {
                  return Text(
                    strings.value.emailSchedules,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  );
                }),
                SizedBox(height: AppSizes.xl),
                Container(
                  constraints: BoxConstraints(
                    minWidth: context.width,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
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
                                  ? _loadSchedules()
                                  : null,
                          onTapOutside: (_) =>
                              _searchController.text != lastSearch
                                  ? _loadSchedules()
                                  : null,
                          constraints: BoxConstraints(
                            maxWidth: AppSizes.lg * 8,
                            minHeight: AppSizes.lg * 1.5,
                            maxHeight: AppSizes.lg * 1.5,
                          ),
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.surfaceContainer),
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
                                  _showAddScheduleEmailDialog();
                                },
                                child: Text(strings.value.addScheduleEmail)),
                            ShadButton.destructive(
                                onPressed: _onDeleteButtonClick,
                                child: Text(strings.value.delete)),
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
                                          return ShadSheet(
                                              scrollable: false,
                                              child: ScrollConfiguration(
                                                behavior:
                                                    ScrollConfiguration.of(
                                                            context)
                                                        .copyWith(
                                                  dragDevices: {
                                                    PointerDeviceKind.touch,
                                                    PointerDeviceKind.mouse,
                                                    PointerDeviceKind.stylus,
                                                    PointerDeviceKind
                                                        .invertedStylus,
                                                    PointerDeviceKind.trackpad,
                                                    PointerDeviceKind.unknown,
                                                  },
                                                  scrollbars: true,
                                                ),
                                                child: SingleChildScrollView(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                      minWidth:
                                                          context.width / 2,
                                                      maxWidth: context.width,
                                                      minHeight: context.height,
                                                      maxHeight: context.height,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              AppSizes.sm),
                                                      child: Scaffold(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        body:
                                                            _topPageActionsSmallScreen(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ));
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
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadius),
                    ),
                    child: _isDataLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : DataTable2(
                            columnSpacing: _getColumnSpacing(),
                            onSelectAll: (selectedAll) => selectedAll == true
                                ? _selectedSchedules.addAll(schedules)
                                : _selectedSchedules.clear(),
                            showCheckboxColumn: _showCheckboxColumn.value,
                            sortColumnIndex: 0,
                            dataRowColor: WidgetStateProperty.fromMap({
                              WidgetState.hovered: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              WidgetState.focused: colorScheme.primaryContainer,
                            }),
                            columns: _getCols(),
                            rows: _getRows(),
                          ),
                  ),
                ),
                SizedBox(
                  height: AppSizes.sm,
                ),
                _bottomPageActions(
                  currentPage: schedulesMeta.currentPage,
                  nbrTotalPages: schedulesMeta.totalPages,
                  nbrShown: schedulesMeta.data.length,
                  nbrTotal: schedulesMeta.totalResults,
                  onPrevPress: (p) => {page = p, _loadSchedules()},
                  onNextPress: (p) => {page = p, _loadSchedules()},
                  onPagePress: (p) => {page = p, _loadSchedules()},
                  data: schedules,
                  label: strings.value.schedules,
                )
              ],
            );
          }),
        ));
  }

  _showAddScheduleEmailDialog() {
    final strings = getTranslations(context).obs;
    API_CLIENT.RapportEnum? _rapport;
    API_CLIENT.IntervalEnum? _interval;
    String? _tempsEnvoi;
    int? _intervalManual;
    DateTime? _nextRunTime;
    List<String>? _scheduledUsers;
    List<int>? _scheduledRoles;

    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text(strings.value.addScheduleEmail,
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text(strings.value.addANewScheduleEmail,
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            ShadButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(strings.value.cancel),
            ),
            ShadButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    !_formKey.currentState!.validate()) {
                  logger.e("Form is not valid");
                  Toasts.showErrorToastNotification(
                      context: Get.overlayContext!,
                      message: strings.value.pleaseFixErrorsInTheForm);
                  return;
                }
                EmailActions.addSchedule(
                  context,
                  rapport: _rapport!,
                  interval: _interval!,
                  tempsEnvoi: _tempsEnvoi!,
                  intervalManual: _intervalManual,
                  nextRunTime: _nextRunTime,
                  scheduledRoles: _scheduledRoles,
                  scheduledUsers: _scheduledUsers,
                  onSuccess: () {
                    _loadSchedules();
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Text(strings.value.add),
            )
          ],
          child: EmailScheduleForm(
            onValuesChanged: (
                {formKey,
                interval,
                intervalManual,
                nextRunTime,
                rapport,
                roles,
                tempsEnvoi,
                users}) {
              _rapport = rapport ?? _rapport;
              _interval = interval ?? _interval;
              _intervalManual = intervalManual ?? _intervalManual;
              _nextRunTime = nextRunTime ?? _nextRunTime;
              _tempsEnvoi = tempsEnvoi ?? _tempsEnvoi;
              _scheduledRoles =
                  roles?.map((r) => r.roleId).toList() ?? _scheduledRoles;
              _scheduledUsers =
                  users?.map((u) => u.email).toList() ?? _scheduledUsers;
            },
          ),
        );
      },
    );
  }

  _showViewScheduleEmailDialog({
    required API_CLIENT.EmailSchedule schedule,
  }) {
    final strings = getTranslations(context).obs;

    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text(
              "${strings.value.schedule}: ${schedule.rapport.json} ${schedule.tempsEnvoi} ${schedule.interval == API_CLIENT.IntervalEnum.manual ? '${schedule.intervalManual} ${strings.value.days}' : schedule.interval.json}",
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text(strings.value.viewScheduleEmail,
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            ShadButton(
              icon: Icon(Icons.close),
              child: Text(strings.value.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() {
              return loaded.value
                  ? ShadButton.destructive(
                      child: Text(strings.value.delete),
                      onPressed: () {
                        _selectedSchedules.add(schedule);
                        _onDeleteButtonClick(
                          onDeleteConfirmed: () => Navigator.of(context).pop(),
                        );
                      },
                    )
                  : SizedBox.shrink();
            }).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() {
              return loaded.value
                  ? ShadButton(
                      icon: Icon(Icons.edit),
                      child: Text(strings.value.edit),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showEditAlertEmailDialog(schedule: schedule);
                      },
                    )
                  : SizedBox.shrink();
            }).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() => Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (loaded.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShadButton.destructive(
                              child: Text(strings.value.delete),
                              onPressed: () {
                                _selectedSchedules.add(schedule);
                                _onDeleteButtonClick(
                                  onDeleteConfirmed: () =>
                                      Navigator.of(context).pop(),
                                );
                              },
                            ),
                            ShadButton(
                              icon: Icon(Icons.edit),
                              child: Text(strings.value.edit),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _showEditAlertEmailDialog(schedule: schedule);
                              },
                            ),
                          ],
                        ),
                      ShadButton(
                        icon: Icon(Icons.close),
                        child: Text(strings.value.cancel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                )).removeWhen(isAtMostSmallScreen(context))
          ].nonNulls.toList(),
          child: EmailScheduleForm(
            schedule: schedule,
            editable: false,
            showIdField: true,
            showNextRunTime: true,
          ),
        );
      },
    );
  }

  _showEditAlertEmailDialog({
    required API_CLIENT.EmailSchedule schedule,
  }) {
    API_CLIENT.RapportEnum? _rapport;
    API_CLIENT.IntervalEnum? _interval;
    String? _tempsEnvoi;
    int? _intervalManual;
    DateTime? _nextRunTime;
    List<String>? _scheduledUsers;
    List<int>? _scheduledRoles;
    final strings = getTranslations(context).obs;
    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text(
              "${strings.value.editSchedule}: ${schedule.rapport.json} ",
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text(strings.value.editScheduleSettings,
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            ShadButton(
              icon: Icon(Icons.close),
              child: Text(strings.value.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() {
              return loaded.value
                  ? ShadButton.destructive(
                      child: Text(strings.value.delete),
                      onPressed: () {
                        _selectedSchedules.add(schedule);
                        _onDeleteButtonClick(
                          onDeleteConfirmed: () => Navigator.of(context).pop(),
                        );
                      },
                    )
                  : SizedBox.shrink();
            }).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() {
              return loaded.value
                  ? ShadButton(
                      icon: Icon(Icons.edit),
                      child: Text(strings.value.save),
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            !_formKey.currentState!.validate()) {
                          logger.e("Form is not valid");
                          Toasts.showErrorToastNotification(
                              context: Get.overlayContext!,
                              message: strings.value.pleaseFixErrorsInTheForm);
                          return;
                        }
                        EmailActions.saveSchedule(
                          context,
                          id: schedule.id,
                          interval: _interval!,
                          intervalManual: _intervalManual,
                          nextRunTime: _nextRunTime,
                          rapport: _rapport!,
                          tempsEnvoi: _tempsEnvoi!,
                          scheduledRoles: _scheduledRoles,
                          scheduledUsers: _scheduledUsers,
                          onSuccess: () {
                            _loadSchedules();
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    )
                  : SizedBox.shrink();
            }).removeWhen(isAtLeastMediumScreen(context)),
            Obx(() => Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (loaded.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ShadButton.destructive(
                              child: Text(strings.value.delete),
                              onPressed: () {
                                _selectedSchedules.add(schedule);
                                _onDeleteButtonClick(
                                  onDeleteConfirmed: () =>
                                      Navigator.of(context).pop(),
                                );
                              },
                            ),
                            ShadButton(
                              icon: Icon(Icons.edit),
                              child: Text(strings.value.save),
                              onPressed: () {
                                if (_formKey.currentState != null &&
                                    !_formKey.currentState!.validate()) {
                                  logger.e("Form is not valid");
                                  Toasts.showErrorToastNotification(
                                      context: Get.overlayContext!,
                                      message: strings
                                          .value.pleaseFixErrorsInTheForm);
                                  return;
                                }
                                EmailActions.saveSchedule(
                                  context,
                                  id: schedule.id,
                                  interval: _interval!,
                                  intervalManual: _intervalManual,
                                  nextRunTime: _nextRunTime,
                                  rapport: _rapport!,
                                  tempsEnvoi: _tempsEnvoi!,
                                  scheduledRoles: _scheduledRoles,
                                  scheduledUsers: _scheduledUsers,
                                  onSuccess: () {
                                    _loadSchedules();
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ShadButton(
                        icon: Icon(Icons.close),
                        child: Text(strings.value.cancel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                )).removeWhen(isAtMostSmallScreen(context))
          ].nonNulls.toList(),
          child: EmailScheduleForm(
            editable: true,
            schedule: schedule,
            showIdField: false,
            showNextRunTime: true,
            onValuesChanged: (
                {formKey,
                interval,
                intervalManual,
                nextRunTime,
                rapport,
                roles,
                tempsEnvoi,
                users}) {
              _rapport = rapport ?? _rapport;
              _interval = interval ?? _interval;
              _intervalManual = intervalManual ?? _intervalManual;
              _nextRunTime = nextRunTime ?? _nextRunTime;
              _tempsEnvoi = tempsEnvoi ?? _tempsEnvoi;
              _scheduledRoles =
                  roles?.map((r) => r.roleId).toList() ?? _scheduledRoles;
              _scheduledUsers =
                  users?.map((u) => u.email).toList() ?? _scheduledUsers;
            },
          ),
        );
      },
    );
  }

  void _onDeleteButtonClick({
    void Function()? onDeleteConfirmed,
  }) {
    _showCheckboxColumn.value = !_showCheckboxColumn.value;
    final strings = getTranslations(context).obs;

    ShadToaster.of(context).show(
      ShadToast.destructive(
        closeIcon: SizedBox(),
        duration: Duration(days: 365),
        title: Text(strings.value.deleteSchedules),
        description: Obx(
          () {
            return _selectedSchedules.isEmpty
                ? Text(strings.value.selectSchedulesToDelete)
                : Text(strings.value
                    .confirmSchedulesDeletion(_selectedSchedules.length));
          },
        ),
        action: Obx(
          () => _selectedSchedules.isEmpty
              ? ShadButton(
                  onPressed: () {
                    _selectedSchedules.clear();
                    _showCheckboxColumn.value = false;
                    ShadToaster.of(context).hide();
                  },
                  child: Text(strings.value.cancel),
                )
              : Row(
                  children: [
                    ShadButton(
                      onPressed: () async {
                        await _deleteSchedules();
                        _loadSchedules();
                        onDeleteConfirmed?.call();
                      },
                      child: Text(strings.value.yes),
                    ),
                    ShadButton(
                      onPressed: () {
                        _selectedSchedules.clear();
                        _showCheckboxColumn.value = false;
                        ShadToaster.of(context).hide();
                      },
                      child: Text(strings.value.no),
                    ),
                  ],
                ),
        ),
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
    List<int> getIndexesOfPages(
      int currentPage,
      int totalPages, {
      int nbrAdditionalIndexesShown = 2,
    }) {
      //printMessage("currentPage: $currentPage");
      //printMessage("totalPages: $totalPages");
      List<int> indexes = [];

      indexes.add(1);
      var i = 2;
      var j = 0;
      while (i < currentPage && j < nbrAdditionalIndexesShown) {
        if (i >= (currentPage - nbrAdditionalIndexesShown)) {
          indexes.add(i);
          j++;
        }
        i++;
      }

      if (!indexes.contains(currentPage)) {
        indexes.add(currentPage);
      }

      i = totalPages - 1;
      j = 0;
      while (i > currentPage && j < nbrAdditionalIndexesShown) {
        indexes.add(i);
        i--;
        j++;
      }
      if (!indexes.contains(totalPages)) {
        indexes.add(totalPages);
      }
      indexes.sort();
      i = 1;
      final List<int> fIndexes = [indexes[0]];
      while (i < indexes.length) {
        if (indexes[i] > indexes[i - 1] + 1) {
          fIndexes.add(-1);
        }
        fIndexes.add(indexes[i]);

        i++;
      }
      //printMessage(fIndexes);
      return fIndexes;
    }

    List<Widget> pageIndexesButtons() {
      final strings = getTranslations(context).obs;
      List<Widget> pageIndexesButtons = [];
      if (data.isNotEmpty) {
        final indexes = getIndexesOfPages(currentPage, nbrTotalPages,
            nbrAdditionalIndexesShown: (context) {
              if (isAtMostSmallScreen(context)) {
                return 0;
              }
              if (isAtMostMediumScreen(context)) {
                return 1;
              }
              return 2;
            }(context));
        pageIndexesButtons = indexes.map(
          (i) {
            if (i < 0) {
              final items = <PageIndex>[];
              for (var index = 1; index <= nbrTotalPages; index++) {
                items.add(
                  PageIndex(
                    index: index,
                    button: ShadButton(
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      onPressed: () => onPagePress(index),
                      child: Text(
                        "$index",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              // set display to all
              final searchedPageIndexes = items.obs;
              return Obx(() {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 30,
                    maxWidth: 60,
                    maxHeight: 60,
                  ),
                  child: ShadSelect.withSearch(
                    decoration: ShadDecoration(
                      color: colorScheme.surface,
                      border: ShadBorder.none,
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_drop_up,
                      size: AppSizes.md,
                    ),
                    initialValue: "...",
                    selectedOptionBuilder: (context, v) => FittedBox(
                      child: Text(
                        v,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    anchor: ShadAnchorAuto(preferBelow: false),
                    options: [...searchedPageIndexes.map((pi) => pi.button)],
                    searchPlaceholder: Text(strings.value.search),
                    onSearchChanged: (String value) {
                      if (value.isEmpty) {
                        searchedPageIndexes.value = items;
                      } else {
                        searchedPageIndexes.value = items
                            .where((pi) => pi.index == int.tryParse(value))
                            .toList();
                      }
                    },
                  ),
                );
              });
            }
            return ShadButton(
              backgroundColor:
                  i == currentPage ? colorScheme.primaryContainer : null,
              onPressed: () => onPagePress(i),
              child: Text("$i"),
            );
          },
        ).toList();
      }
      return pageIndexesButtons;
    }

    final strings = getTranslations(context).obs;
    return Container(
      width: context.width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.sm),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            if (isAtLeastMediumScreen(context) && !SideMenuContainer.open)
              Text(
                "${strings.value.page}: $currentPage", // if it is at least a small screen show it in this position
              ),
            Row(
              mainAxisSize:
                  isAtLeastMediumScreen(context) && !SideMenuContainer.open
                      ? MainAxisSize.min
                      : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadButton(
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                  enabled: currentPage > 1,
                  onPressed: () => onPrevPress(currentPage - 1),
                  child: Text(strings.value.prevPage),
                ),
                ...pageIndexesButtons(),
                ShadButton(
                  backgroundColor: colorScheme.surface,
                  foregroundColor: colorScheme.onSurface,
                  enabled: currentPage < nbrTotalPages,
                  onPressed: () => onNextPress(currentPage + 1),
                  child: Text(strings.value.nextPage),
                ),
              ],
            ),
            if (isAtMostSmallScreen(context) || SideMenuContainer.open)
              Text(
                  "${strings.value.page}: $currentPage"), // if it is at most a small screen show it in this position
            Text("$label: $nbrShown/$nbrTotal")
          ],
        ),
      ),
    );
  }

  Future<void> _loadSchedules() async {
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

    // Load alerts
    try {
      logger.e("PerPageController: ${_perPageController.text}");
      lastPerPage = _perPageController.text.isNotEmpty
          ? int.tryParse(_perPageController.text)
          : null;
      lastSearch = _searchController.text;
      schedulesMeta = await api!.getEmailSchedules(
        page: page,
        perPage: lastPerPage,
        interval: intervalFilter != null
            ? API_CLIENT.Interval.fromJson(intervalFilter!.json!)
            : null,
        rapport: rapportFilter != null
            ? API_CLIENT.Rapport.fromJson(rapportFilter!.json!)
            : null,
        ordering: _getOrdering(),
        search: lastSearch,
      );
      schedules = schedulesMeta.data.obs;
    } catch (e) {
      logger.e("Failed to load alerts : $e");
    }
    _isDataLoading.value = false;
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadSchedules();

    loaded.value = true;
  }

  _getCols() {
    final strings = getTranslations(context).obs;
    return [
      DataColumn2(
          fixedWidth: 60,
          label: Text(
            strings.value.no,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          size: ColumnSize.L,
          label: Text(
            strings.value.rapport,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )),
      DataColumn2(
          size: ColumnSize.S,
          label: Text(
            strings.value.interval,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          size: ColumnSize.S,
          label: Text(
            strings.value.tempsEnvoi,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          size: ColumnSize.S,
          label: Text(
            strings.value.nextRunTime,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
        size: ColumnSize.S,
        label: Expanded(
          child: Text(
            strings.value.actions,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    ].nonNulls.toList();
  }

  _getRows() {
    final strings = getTranslations(context).obs;
    return schedules.map((e) {
      final actionsController = ShadPopoverController();
      return DataRow2(
        selected: _selectedSchedules.contains(e),
        onSelectChanged: (selected) {
          if (selected == true) {
            _selectedSchedules.add(e);
          } else {
            _selectedSchedules.remove(e);
          }
        },
        onDoubleTap: () => _showViewScheduleEmailDialog(
          schedule: e,
        ),
        cells: [
          DataCell(Text(
            (schedules.indexOf(e) + 1).toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(FittedBox(
            child: Text(
              e.rapport.json ?? strings.value.unknown,
              softWrap: false,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )),
          DataCell(Text(
            e.interval == API_CLIENT.IntervalEnum.manual
                ? "${e.intervalManual} ${strings.value.days}"
                : e.interval.json?.toUpperCase() ?? strings.value.unknown,
            style: Theme.of(context).textTheme.bodyMedium,
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(FittedBox(
              child: Text(
            e.tempsEnvoi
                .toString()
                .substring(0, e.tempsEnvoi.toString().lastIndexOf(":"))
                .toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ))).removeWhen(isAtMostSmallScreen(context)),
          DataCell(FittedBox(
            child: Text(
              e.nextRunTime?.toString().split(".")[0].substring(
                      0, e.nextRunTime?.toString().lastIndexOf(":")) ??
                  strings.value.unscheduled,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(
            FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      _sendEmailNow(schedule: e);
                    },
                    icon: Icon(Icons.email),
                  ).removeWhen(isAtMostSmallScreen(context)),
                  IconButton(
                    onPressed: () {
                      _showViewScheduleEmailDialog(schedule: e);
                    },
                    icon: Icon(Icons.remove_red_eye_rounded),
                  ).removeWhen(isAtMostMediumScreen(context)),
                  IconButton(
                    onPressed: () {
                      _showEditAlertEmailDialog(schedule: e);
                    },
                    icon: Icon(Icons.edit),
                  ).removeWhen(isAtMostSmallScreen(context)),
                  IconButton(
                    onPressed: () {
                      _selectedSchedules.add(e);
                      _onDeleteButtonClick();
                    },
                    icon: Icon(Icons.delete),
                  ).removeWhen(isAtMostMediumScreen(context)),
                  ShadPopover(
                    padding: EdgeInsets.zero,
                    decoration: ShadDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        border: ShadBorder.all(
                          width: 0,
                          radius: BorderRadius.circular(AppSizes.borderRadius),
                        )),
                    popover: (context) => SizedBox(
                      width: AppSizes.lg * 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconWithLabelButton(
                            icon: Icons.email,
                            text: strings.value.send,
                            onTap: () => {
                              _sendEmailNow(schedule: e),
                              actionsController.toggle(),
                            },
                          ),
                          IconWithLabelButton(
                            icon: Icons.remove_red_eye_rounded,
                            text: strings.value.view,
                            onTap: () => {
                              _showViewScheduleEmailDialog(schedule: e),
                              actionsController.toggle(),
                            },
                          ),
                          IconWithLabelButton(
                            icon: Icons.edit,
                            onTap: () {
                              _showEditAlertEmailDialog(schedule: e);
                              actionsController.toggle();
                            },
                            text: strings.value.edit,
                          ).removeWhen(isAtLeastMediumScreen(context)),
                          IconWithLabelButton(
                            icon: Icons.delete,
                            text: strings.value.delete,
                            activeColor: errorColor,
                          ),
                        ].nonNulls.toList(),
                      ),
                    ),
                    controller: actionsController,
                    child: IconButton(
                      onPressed: () {
                        actionsController.toggle();
                      },
                      icon: Icon(
                        LucideIcons.ellipsisVertical,
                        applyTextScaling: true,
                      ),
                    ),
                  ).removeWhen(isAtLeastLargeScreen(context)),
                ].nonNulls.toList(),
              ),
            ),
          ),
        ].nonNulls.toList(),
      );
    }).toList();
  }

  _sendEmailNow({
    required EmailSchedule schedule,
  }) async {
    final state = FutureState.loading.obs;
    final strings = getTranslations(context).obs;
    final toast = Toasts.showStatefulToast(
      context: context,
      message: strings.value.sendingEmail,
      messageSuccess: strings.value.emailSent,
      messageError: strings.value.failedToSendEmail,
      state: state,
    );
    await api!.sendScheduledEmailNow(emailScheduleId: schedule.id);
    if (state.value != FutureState.error) {
      state.value = FutureState.success;
    }
    Future.delayed(Duration(seconds: 2), () {
      toastification.dismissById(toast.id);
    });
    ShadToaster.of(context).hide();
  }

  _getColumnSpacing() {
    return isSmallScreen(context) ? AppSizes.sm : AppSizes.md;
  }

  _deleteSchedules() async {
    _done(int id) {
      _selectedSchedules.removeWhere((element) => element.id == id);
      schedules.removeWhere((element) => element.id == id);
    }

    final strings = getTranslations(context).obs;
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: strings.value.deletingSchedules,
        messageSuccess: strings.value.schedulesDeleted,
        messageError: strings.value.failedToDeleteSchedules,
        state: state);
    await Future.wait(_selectedSchedules.map((schedule) {
      return api!.destroyEmailSchedule(id: schedule.id).then((value) {
        _done(schedule.id);
      }).catchError((e) {
        logger.e("Failed to delete schedule email : $e");
        state.value = FutureState.error;
        Toasts.showErrorToast(
            context: context,
            message: strings.value.failedToDeleteScheduleWithId(schedule.id));
      });
    }));
    if (state.value != FutureState.error) {
      state.value = FutureState.success;
    }
    Future.delayed(Duration(seconds: 2), () {
      toastification.dismissById(toast.id);
    });
    ShadToaster.of(context).hide();
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
                        minWidth: AppSizes.xl * 6, maxWidth: AppSizes.xl * 8),
                    child: filterContent(context, tagFilterController,
                        activationStateFilterController),
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
                  popover: (context) => SizedBox(
                    width: AppSizes.xl * 6,
                    child: sortContent(
                      context: context,
                      sortASC: sortASC,
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
                      ? _loadSchedules()
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
              onTap: _loadSchedules,
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
            _loadSchedules();
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
            _loadSchedules();
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
          Text(strings.value.sortSchedules,
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(
            height: AppSizes.sm,
          ),
          Divider(),
          SizedBox(
            height: AppSizes.md,
          ),
          Text(strings.value.order + ":",
              style: Theme.of(context).textTheme.bodyMedium),
          ShadSelect<String>(
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
                _loadSchedules();
              }
            },
          ),
          SizedBox(
            height: AppSizes.sm,
          ),
          Text("${strings.value.sortBy}:",
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
      TextEditingController tagFilterController,
      TextEditingController activationStateFilterController) {
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
        Text(strings.value.filterSchedules,
            style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(
          height: AppSizes.sm,
        ),
        Divider(),
        SizedBox(
          height: AppSizes.md,
        ),
        Text(strings.value.filterByRapport,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        DropdownMenu<API_CLIENT.RapportEnum>(
          hintText: strings.value.selectAReport,
          label: Text(strings.value.rapport),
          controller: tagFilterController,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
          initialSelection: rapportFilter,
          width: AppSizes.xl * 8,
          enableFilter: false,
          enableSearch: false,
          requestFocusOnTap: false,
          onSelected: (value) {
            // filter by monitored value tag
            if (rapportFilter == value) {
              tagFilterController.clear();
              rapportFilter = null;
              _loadSchedules();
              return;
            }
            rapportFilter = value;
            _loadSchedules();
          },
          dropdownMenuEntries: [
            for (API_CLIENT.RapportEnum rapport in API_CLIENT.RapportEnum.values
                .where((r) => r != API_CLIENT.RapportEnum.$unknown)
                .toList())
              DropdownMenuEntry(
                value: rapport,
                label: rapport.json ?? strings.value.unknown,
              ),
          ],
        ),
        Text(strings.value.filterByInterval,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        DropdownMenu<API_CLIENT.IntervalEnum>(
          hintText: strings.value.selectInterval,
          label: Text(strings.value.interval),
          controller: activationStateFilterController,
          width: AppSizes.xl * 8,
          enableFilter: false,
          enableSearch: false,
          requestFocusOnTap: false,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
          initialSelection: intervalFilter,
          onSelected: (value) {
            // filter by monitored value tag
            if (intervalFilter == value) {
              activationStateFilterController.clear();
              intervalFilter = null;
              _loadSchedules();
              return;
            }
            intervalFilter = value;
            _loadSchedules();
          },
          dropdownMenuEntries: [
            for (API_CLIENT.IntervalEnum interval in API_CLIENT
                .IntervalEnum.values
                .where((i) => i != API_CLIENT.IntervalEnum.$unknown))
              DropdownMenuEntry(
                value: interval,
                label: interval.json ?? strings.value.unknown,
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
          onTap: _loadSchedules,
          text: strings.value.refresh,
        ),

        SizedBox(
          height: AppSizes.sm,
        ),
        PerPageInput(
          expandPerPage: _expandPerPage,
          perPageController: _perPageController,
          load: () => _perPageController.text != lastPerPage.toString()
              ? _loadSchedules()
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
}
