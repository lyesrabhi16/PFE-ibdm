import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/page_index.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';

class EmailAlertsPage extends StatefulWidget {
  const EmailAlertsPage({super.key});

  @override
  State<EmailAlertsPage> createState() => _EmailAlertsPageState();
}

class _EmailAlertsPageState extends State<EmailAlertsPage> {
  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  late final strings = getTranslations(getContext).obs;

  final _showCheckboxColumn = false.obs;

  static final _searchController = TextEditingController();
  IbdmApiClient? api;
  final RxBool loaded = false.obs;

  RxList<AlertEmail> alerts = <AlertEmail>[].obs;
  late PaginatedAlertEmailList alertsMeta;
  final _selectedAlerts = <AlertEmail>[].obs;

  int page = 1;
  int perPage = 10;

  final actionsController = ShadPopoverController();

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    return AppCustomContainer(
        child: Padding(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Obx(() {
        if (!loaded.value) {
          load();
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        _showCheckboxColumn.value = _selectedAlerts.isNotEmpty;

        return Column(
          children: [
            Text(
              'Alert Emails',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSizes.sm),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  runSpacing: AppSizes.sm,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    SearchBar(
                      controller: _searchController,
                      onSubmitted: (_) => _loadAlerts(),
                      onTapOutside: (_) => _loadAlerts(),
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
                      children: [
                        ShadButton(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            hoverBackgroundColor:
                                colorScheme.surfaceContainerHighest,
                            foregroundColor: colorScheme.onSurface,
                            onPressed: () {
                              _showAddAlertEmailDialog();
                            },
                            child: Text(strings.value.addAlertEmail)),
                        ShadButton.destructive(
                            onPressed: _onDeleteButtonClick,
                            child: Text(strings.value.delete)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: context.width,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DataTable2(
                  columnSpacing: _getColumnSpacing(),
                  onSelectAll: (selectedAll) => selectedAll == true
                      ? _selectedAlerts.addAll(alerts)
                      : _selectedAlerts.clear(),
                  showCheckboxColumn: _showCheckboxColumn.value,
                  sortColumnIndex: 0,
                  dataRowColor: WidgetStateProperty.fromMap({
                    WidgetState.hovered:
                        Theme.of(context).colorScheme.primaryContainer,
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
            _bottomPageAction(
              currentPage: alertsMeta.currentPage,
              nbrTotalPages: alertsMeta.totalPages,
              nbrShown: alertsMeta.data.length,
              nbrTotal: alertsMeta.totalResults,
              onPrevPress: (p) => {page = p, load()},
              onNextPress: (p) => {page = p, load()},
              onPagePress: (p) => {page = p, load()},
              data: alerts,
              label: "Alerts",
            )
          ],
        );
      }),
    ));
  }

  _showAddAlertEmailDialog() {
    String? _addAlertCustomMessage;
    String? _addAlertDangerAlertInterval;
    String? _addAlertDangerPoint;
    bool? _addAlertEnabled;
    String? _addAlertMonitoredValue;
    List<Role>? _addAlertRoles;
    List<User>? _addAlertUsers;
    String? _addAlertWarningAlertInterval;
    String? _addAlertWarningPoint;

    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text("Add Alert Email",
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text("Add a new alert email",
              style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            ShadButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ShadButton(
              onPressed: () => Actions.addAlert(
                context,
                monitoredValue: _addAlertMonitoredValue!,
                customMessage: _addAlertCustomMessage,
                dangerAlertInterval: _addAlertDangerAlertInterval,
                dangerPoint: _addAlertDangerPoint,
                enabled: _addAlertEnabled,
                roles: _addAlertRoles,
                users: _addAlertUsers,
                warningAlertInterval: _addAlertWarningAlertInterval,
                warningPoint: _addAlertWarningPoint,
                onSuccess: () {
                  load();
                  Navigator.of(context).pop();
                },
              ),
              child: Text("Add"),
            )
          ],
          child: AlertEmailForm(
            onValuesChanged: (
                {customMessage,
                dangerAlertInterval,
                dangerPoint,
                enabled,
                monitoredValue,
                roles,
                users,
                warningAlertInterval,
                warningPoint}) {
              _addAlertCustomMessage = customMessage;
              _addAlertDangerAlertInterval = dangerAlertInterval;
              _addAlertDangerPoint = dangerPoint;
              _addAlertEnabled = enabled;
              _addAlertMonitoredValue = monitoredValue;
              _addAlertRoles = roles;
              _addAlertUsers = users;
              _addAlertWarningAlertInterval = warningAlertInterval;
              _addAlertWarningPoint = warningPoint;
            },
          ),
        );
      },
    );
  }

  _showViewAlertEmailDialog({
    required AlertEmail alert,
  }) {
    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text("Alert: ${alert.monitoredValue.json} ",
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text(
              "view alert settings of ${alert.monitoredValue.json}",
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
                        _selectedAlerts.add(alert);
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
                        _showEditAlertEmailDialog(alert: alert);
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
                                _selectedAlerts.add(alert);
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
                                _showEditAlertEmailDialog(alert: alert);
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
          child: AlertEmailForm(
            alert: alert,
            editable: false,
            showIdField: true,
          ),
        );
      },
    );
  }

  _showEditAlertEmailDialog({
    required AlertEmail alert,
  }) {
    String? _saveAlertCustomMessage;
    String? _saveAlertDangerAlertInterval;
    String? _saveAlertDangerPoint;
    bool? _saveAlertEnabled;
    String? _saveAlertMonitoredValue;
    List<Role>? _saveAlertRoles;
    List<User>? _saveAlertUsers;
    String? _saveAlertWarningAlertInterval;
    String? _saveAlertWarningPoint;
    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text("Edit Alert: ${alert.monitoredValue.json} ",
              style: Theme.of(context).textTheme.headlineMedium),
          description: Text(
              "edit alert settings of ${alert.monitoredValue.json}",
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
                        _selectedAlerts.add(alert);
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
                        Actions.saveAlert(
                          context,
                          alertId: alert.id,
                          customMessage: _saveAlertCustomMessage,
                          dangerAlertInterval: _saveAlertDangerAlertInterval,
                          dangerPoint: _saveAlertDangerPoint,
                          enabled: _saveAlertEnabled,
                          monitoredValue: _saveAlertMonitoredValue,
                          roles: _saveAlertRoles,
                          users: _saveAlertUsers,
                          warningAlertInterval: _saveAlertWarningAlertInterval,
                          warningPoint: _saveAlertWarningPoint,
                          onSuccess: () {
                            load();
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
                                _selectedAlerts.add(alert);
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
                                Actions.saveAlert(
                                  context,
                                  alertId: alert.id,
                                  customMessage: _saveAlertCustomMessage,
                                  dangerAlertInterval:
                                      _saveAlertDangerAlertInterval,
                                  dangerPoint: _saveAlertDangerPoint,
                                  enabled: _saveAlertEnabled,
                                  monitoredValue: _saveAlertMonitoredValue,
                                  roles: _saveAlertRoles,
                                  users: _saveAlertUsers,
                                  warningAlertInterval:
                                      _saveAlertWarningAlertInterval,
                                  warningPoint: _saveAlertWarningPoint,
                                  onSuccess: () {
                                    load();
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
          child: AlertEmailForm(
            alert: alert,
            editable: true,
            showIdField: false,
            onValuesChanged: ({
              customMessage,
              dangerAlertInterval,
              dangerPoint,
              enabled,
              monitoredValue,
              roles,
              users,
              warningAlertInterval,
              warningPoint,
            }) {
              if (customMessage != null) {
                _saveAlertCustomMessage =
                    customMessage.isNotEmpty ? customMessage : null;
              }
              if (dangerAlertInterval != null) {
                _saveAlertDangerAlertInterval =
                    dangerAlertInterval.isNotEmpty ? dangerAlertInterval : null;
              }
              if (dangerPoint != null) {
                _saveAlertDangerPoint =
                    dangerPoint.isNotEmpty ? dangerPoint : null;
              }
              _saveAlertEnabled = enabled;
              if (monitoredValue != null) {
                _saveAlertMonitoredValue =
                    monitoredValue.isNotEmpty ? monitoredValue : null;
              }
              _saveAlertRoles = roles;
              _saveAlertUsers = users;

              if (warningAlertInterval != null) {
                _saveAlertWarningAlertInterval = warningAlertInterval.isNotEmpty
                    ? warningAlertInterval
                    : null;
              }
              if (warningPoint != null) {
                _saveAlertWarningPoint =
                    warningPoint.isNotEmpty ? warningPoint : null;
              }
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

    ShadToaster.of(context).show(
      ShadToast.destructive(
        closeIcon: SizedBox(),
        duration: Duration(days: 365),
        title: Text("Delete Users"),
        description: Obx(
          () {
            return _selectedAlerts.isEmpty
                ? Text("Select Alerts to delete")
                : Text(
                    "Are you sure you want to delete ${_selectedAlerts.length} Alert(s)?");
          },
        ),
        action: Obx(
          () => _selectedAlerts.isEmpty
              ? ShadButton(
                  onPressed: () {
                    _selectedAlerts.clear();
                    _showCheckboxColumn.value = false;
                    ShadToaster.of(context).hide();
                  },
                  child: Text("Cancel"),
                )
              : Row(
                  children: [
                    ShadButton(
                      onPressed: () async {
                        await _deleteAlerts();
                        load();
                        onDeleteConfirmed?.call();
                      },
                      child: Text("Yes"),
                    ),
                    ShadButton(
                      onPressed: () {
                        _selectedAlerts.clear();
                        _showCheckboxColumn.value = false;
                        ShadToaster.of(context).hide();
                      },
                      child: Text("No"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _bottomPageAction({
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
      //print("currentPage: $currentPage");
      //print("totalPages: $totalPages");
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
      //print(fIndexes);
      return fIndexes;
    }

    List<Widget> pageIndexesButtons() {
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

    return Container(
      width: context.width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(10)),
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
                "Page: $currentPage", // if it is at least a small screen show it in this position
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
                  "Page: $currentPage"), // if it is at most a small screen show it in this position
            Text("$label: $nbrShown/$nbrTotal")
          ],
        ),
      ),
    );
  }

  Future<void> _loadAlerts() async {
    // Load alerts
    try {
      alertsMeta = await api!.getAlertEmails(
        page: page,
        perPage: perPage,
      );
      alerts = alertsMeta.data.obs;
    } catch (e) {
      logger.e("Failed to load alerts : $e");
    }
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadAlerts();

    loaded.value = true;
  }

  _getCols() {
    return [
      DataColumn2(
          label: Text(
        strings.value.no,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.monitored,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.danger,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.warning,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.active,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
        label: Expanded(
          child: Text(
            "Actions",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    ];
  }

  _getRows() {
    return alerts
        .map((e) => DataRow2(
                selected: _selectedAlerts.contains(e),
                onSelectChanged: (selected) {
                  if (selected == true) {
                    _selectedAlerts.add(e);
                  } else {
                    _selectedAlerts.remove(e);
                  }
                },
                onDoubleTap: () => _showViewAlertEmailDialog(
                      alert: e,
                    ),
                cells: [
                  DataCell(Text(
                    (alerts.indexOf(e) + 1).toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  DataCell(Text(
                    e.monitoredValue.json ?? "unknown",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  DataCell(Text(
                    e.dangerPoint.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  DataCell(Text(
                    e.warningPoint.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
                  DataCell(
                    Checkbox(
                      value: e.enabled,
                      onChanged: (v) {
                        Actions.changeAlertEnabledState(
                          context,
                          alertId: e.id,
                          enabled: v ?? false,
                          onSuccess: () {
                            load();
                          },
                        );
                      },
                    ),
                  ),
                  DataCell(
                    FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            onPressed: () {
                              _showViewAlertEmailDialog(alert: e);
                            },
                            icon: Icon(Icons.remove_red_eye_rounded),
                          ).removeWhen(isAtMostMediumScreen(context)),
                          IconButton(
                            onPressed: () {
                              _showEditAlertEmailDialog(alert: e);
                            },
                            icon: Icon(Icons.edit),
                          ).removeWhen(isAtMostSmallScreen(context)),
                          IconButton(
                            onPressed: () {
                              _selectedAlerts.add(e);
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
                                  radius: BorderRadius.circular(10),
                                )),
                            popover: (context) => SizedBox(
                              width: AppSizes.lg * 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconWithLabelButton(
                                    icon: Icons.remove_red_eye_rounded,
                                    text: "view",
                                    onTap: () => {
                                      _showViewAlertEmailDialog(alert: e),
                                      actionsController.toggle(),
                                    },
                                  ),
                                  IconWithLabelButton(
                                    icon: Icons.edit,
                                    onTap: () {
                                      _showEditAlertEmailDialog(alert: e);
                                      actionsController.toggle();
                                    },
                                    text: "edit",
                                  ).removeWhen(isAtLeastMediumScreen(context)),
                                  IconWithLabelButton(
                                    icon: Icons.delete,
                                    text: "delete",
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
                ]))
        .toList();
  }

  _getColumnSpacing() {
    return isSmallScreen(context) ? AppSizes.sm : AppSizes.md;
  }

  void sort(int columnIndex, bool ascending) {
    print("sort called");
  }

  _deleteAlerts() async {
    _done(int id) {
      _selectedAlerts.removeWhere((element) => element.id == id);
      alerts.removeWhere((element) => element.id == id);
    }

    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: "deleting alerts...",
        messageSuccess: "Alerts Deleted.",
        messageError: "Failed To delete alert/alerts",
        state: state);
    await Future.wait(_selectedAlerts.map((alert) {
      return api!.destroyAlertEmail(id: alert.id).then((value) {
        _done(alert.id);
      }).catchError((e) {
        logger.e("Failed to delete alert email : $e");
        state.value = FutureState.error;
        Toasts.showErrorToast(
            context: context,
            message: "Failed To delete alert with id: ${alert.id}");
      });
    }));
    if (state.value != FutureState.error) {
      state.value = FutureState.success;
    }
    Future.delayed(Duration(seconds: 2), () {
      toastification.dismissById(toast.id);
    });
    ShadToaster.of(Get.context!).hide();
  }
}

class Actions {
  Actions._();
  static Future<void> addAlert(
    BuildContext context, {
    required String monitoredValue,
    String? customMessage,
    String? dangerAlertInterval,
    String? dangerPoint,
    bool? enabled,
    List<Role>? roles,
    List<User>? users,
    String? warningAlertInterval,
    String? warningPoint,
    Function? onSuccess,
    Function? onFail,
  }) async {
    // add alert
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: "Adding Alert...",
        messageSuccess: "Alert Added",
        messageError: "Failed to add alert",
        state: state);
    try {
      final api = await ApiClientInstance.getApiClient();
      final res = await api.addAlertEmail(
        monitoredValue: AlertEnum.fromJson(monitoredValue),
        dangerPoint: dangerPoint != null ? int.parse(dangerPoint) : null,
        warningPoint: warningPoint != null ? int.parse(warningPoint) : null,
        dangerReminderInterval:
            dangerAlertInterval != null ? int.parse(dangerAlertInterval) : null,
        warningReminderInterval: warningAlertInterval != null
            ? int.parse(warningAlertInterval)
            : null,
        customAlertMessage: customMessage,
        enabled: enabled,
        sendToUsers: users?.map((e) => e.email).toList(),
        sendToRoles: roles?.map((e) => e.roleId).toList(),
      );
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to add alert : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(context: context, message: "Failed to add alert");
      onFail?.call();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismissById(toast.id);
      });
    }
    return;
  }

  static Future<void> saveAlert(
    BuildContext context, {
    required int alertId,
    String? monitoredValue,
    String? customMessage,
    String? dangerAlertInterval,
    String? dangerPoint,
    bool? enabled,
    List<Role>? roles,
    List<User>? users,
    String? warningAlertInterval,
    String? warningPoint,
    Function? onSuccess,
    Function? onFail,
  }) async {
    // add alert
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: "Saving Alert...",
        messageSuccess: "Alert Saved",
        messageError: "Failed to save alert",
        state: state);
    try {
      final api = await ApiClientInstance.getApiClient();

      final res = await api.partialUpdateAlertEmail(
        id: alertId,
        monitoredValue:
            monitoredValue != null ? AlertEnum.fromJson(monitoredValue) : null,
        dangerPoint: dangerPoint != null ? int.parse(dangerPoint) : null,
        warningPoint: warningPoint != null ? int.parse(warningPoint) : null,
        dangerReminderInterval:
            dangerAlertInterval != null ? int.parse(dangerAlertInterval) : null,
        warningReminderInterval: warningAlertInterval != null
            ? int.parse(warningAlertInterval)
            : null,
        customAlertMessage: customMessage,
        enabled: enabled,
        sendToUsers: users?.map((e) => e.email).toList(),
        sendToRoles: roles?.map((e) => e.roleId).toList(),
      );
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to save alert : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(context: context, message: "Failed to save alert");
      onFail?.call();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismissById(toast.id);
      });
    }
    return;
  }

  static Future<void> changeAlertEnabledState(
    BuildContext context, {
    required int alertId,
    required bool enabled,
    Function? onSuccess,
    Function? onFail,
  }) async {
    // enable or disable alert
    final actionStr = enabled ? 'Activating' : 'Deactivating';
    final actionDoneStr = enabled ? 'Activated' : 'Deactivated';
    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
      context: context,
      message: "$actionStr Alert...",
      messageSuccess: "Alert $actionDoneStr",
      messageError: "Failed to $actionDoneStr alert",
      state: state,
    );
    try {
      final api = await ApiClientInstance.getApiClient();

      await api.partialUpdateAlertEmail(
        id: alertId,
        enabled: enabled,
      );
      state.value = FutureState.success;
      onSuccess?.call();
    } on Exception catch (e) {
      logger.e("Failed to $actionStr alert : $e");
      state.value = FutureState.error;
      Toasts.showErrorToast(
          context: context, message: "Failed to $actionStr alert");
      onFail?.call();
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        toastification.dismissById(toast.id);
      });
    }
    return;
  }
}

class AlertEmailForm extends StatelessWidget {
  AlertEmailForm({
    super.key,
    this.showIdField = false,
    this.onValuesChanged,
    this.editable = true,
    this.alert,
  });

  final bool editable;
  final AlertEmail? alert;

  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  final Function({
    String? monitoredValue,
    String? dangerPoint,
    String? warningPoint,
    String? dangerAlertInterval,
    String? warningAlertInterval,
    List<Role>? roles,
    List<User>? users,
    String? customMessage,
    bool? enabled,
  })? onValuesChanged;

  _valuesChanged() {
    if (!editable) return;
    print("monitoredValueController.text ${monitoredValueController.text}");
    print(
        "dangerAlertIntervalController.text ${dangerAlertIntervalController.text}");
    print("dangerPointController.text ${dangerPointController.text}");
    print(
        "warningAlertIntervalController.text ${warningAlertIntervalController.text}");
    print("warningPointController.text ${warningPointController.text}");
    print("customMessageController.text ${customMessageController.text}");
    print("sendToRoles ${sendToRoles.map((e) => e.name).join(', ')}");
    print("sendToUsers ${sendToUsers.map((e) => e.email).join(', ')}");
    print("enabled $enabled");
    onValuesChanged?.call(
      monitoredValue: monitoredValueController.text,
      dangerPoint: dangerPointController.text,
      warningPoint: warningPointController.text,
      dangerAlertInterval: dangerAlertIntervalController.text,
      warningAlertInterval: warningAlertIntervalController.text,
      roles: sendToRoles.toList(),
      users: sendToUsers.toList(),
      customMessage: customMessageController.text,
      enabled: enabled,
    );
  }

  final idController = TextEditingController(text: "Auto Generated");
  final monitoredValueController = TextEditingController();
  final dangerPointController = TextEditingController(text: "1000");
  final warningPointController = TextEditingController(text: "2500");
  final dangerAlertIntervalController = TextEditingController(text: "1");
  final warningAlertIntervalController = TextEditingController(text: "7");
  final customMessageController = TextEditingController(text: "");
  final sendToRoles = <Role>[];
  final sendToUsers = <User>[];

  bool enabled = true;

  late final strings = getTranslations(getContext).obs;
  final bool showIdField;
  final userController = Get.find<UserController>();
  IbdmApiClient? api;
  List<User> _users = [];
  List<String> _possibleMonitorValues = [];
  RxBool loaded = false.obs;

  _loadUsers() async {
    try {
      final res = await api!.getUsers(
        enablePagination: false,
      );
      _users = res.data;
    } catch (e) {
      logger.e("Failed to load users : $e");
      Toasts.showErrorToast(
          context: getContext, message: "Failed to load users");
      Navigator.of(getContext).pop();
    }
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadUsers();
    await _loadPossibleMonitorValues();

    if (alert != null) {
      idController.text = alert!.id.toString();
      customMessageController.text = alert!.customAlertMessage ?? "";
      dangerAlertIntervalController.text =
          alert!.dangerReminderInterval.toString();
      dangerPointController.text = alert!.dangerPoint.toString();
      warningAlertIntervalController.text =
          alert!.warningReminderInterval.toString();
      warningPointController.text = alert!.warningPoint.toString();
      enabled = alert!.enabled;
      monitoredValueController.text = alert!.monitoredValue.toString();
      sendToRoles.addAll(
        userController.roles
            .where((role) => alert!.sendToRoles.contains(role.roleId)),
      );
      sendToUsers.addAll(
        _users.where((user) => alert!.sendToUsers.contains(user.email)),
      );
    }

    loaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    return Obx(() {
      if (!loaded.value) {
        load();
        return SizedBox(
          height: AppSizes.lg * 10,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return ShadForm(
          onChanged: _valuesChanged,
          child: Column(
            children: [
              SizedBox(height: AppSizes.lg),
              if (showIdField)
                ShadInputFormField(
                  enabled: editable,
                  controller: idController,
                  label: Text("id"),
                ),
              SizedBox(height: AppSizes.sm),
              Container(
                constraints: BoxConstraints(
                  minWidth: context.width,
                ),
                child: ShadSelectFormField<String>(
                  enabled: editable,
                  label: Text("Monitored Value"),
                  options: _possibleMonitorValues.map(
                    (value) => ShadOption(
                      value: value,
                      child: Text(value),
                    ),
                  ),
                  selectedOptionBuilder: (context, value) => Container(
                      constraints: BoxConstraints(
                        minWidth: context.width,
                      ),
                      child: Text(value)),
                  initialValue: alert?.monitoredValue.json,
                  onChanged: (v) {
                    monitoredValueController.text = v!;
                    _valuesChanged();
                  },
                  placeholder: Container(
                      constraints: BoxConstraints(
                        minWidth: context.width,
                      ),
                      child: Text("Select a Value to Monitor")),
                ),
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: dangerPointController,
                label: Text("Danger Point"),
                keyboardType: TextInputType.number,
                initialValue: "1000",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: warningPointController,
                label: Text("Warning Point"),
                keyboardType: TextInputType.number,
                initialValue: "2500",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: dangerAlertIntervalController,
                label: Text("Danger Alert Interval (in days)"),
                keyboardType: TextInputType.number,
                initialValue: "1",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: warningAlertIntervalController,
                label: Text("Warning Alert Interval (in days)"),
                keyboardType: TextInputType.number,
                initialValue: "7",
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.sm),
              // tab panes to send based on users or roles
              ShadTabs(
                  value: alert != null
                      ? alert!.sendToRoles.isNotEmpty
                          ? "roles"
                          : "users"
                      : "roles",
                  tabs: [
                    ShadTab(
                      value: "roles",
                      content: ShadCard(
                        child: Column(
                          children: [
                            Text("Send This Alert To Roles"),
                            SizedBox(height: AppSizes.sm),
                            ShadSelect<Role>.multiple(
                              enabled: editable,
                              closeOnSelect: false,
                              onChanged: (v) {
                                sendToRoles.clear();
                                sendToRoles.addAll(v);
                                _valuesChanged();
                              },
                              anchor: ShadAnchorAuto(
                                preferBelow: false,
                              ),
                              options: userController.roles.map(
                                (r) => ShadOption(
                                  value: r,
                                  child: Text(r.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                AppColors.getRoleColorWithRole(
                                                    r),
                                          )),
                                ),
                              ),
                              selectedOptionsBuilder: (context, values) =>
                                  Container(
                                constraints: BoxConstraints(
                                  minWidth: context.width,
                                ),
                                child: Column(
                                  children: values
                                      .map((role) => Text(
                                            role.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: AppColors
                                                      .getRoleColorWithRole(
                                                          role),
                                                ),
                                          ))
                                      .toList(),
                                ),
                              ),
                              initialValues: sendToRoles,
                              placeholder: Container(
                                  constraints: BoxConstraints(
                                    minWidth: context.width,
                                  ),
                                  child: Text("Select Roles")),
                            ),
                          ],
                        ),
                      ),
                      child: Text("Roles"),
                    ),
                    ShadTab(
                        value: "users",
                        content: ShadCard(
                          child: Column(
                            children: [
                              Text("Send This Alert To Users"),
                              SizedBox(height: AppSizes.sm),
                              ShadSelect<User>.multiple(
                                enabled: editable,
                                onChanged: (v) {
                                  sendToUsers.clear();
                                  sendToUsers.addAll(v);
                                  _valuesChanged();
                                },
                                closeOnSelect: false,
                                anchor: ShadAnchorAuto(
                                  preferBelow: false,
                                ),
                                options: _users.map(
                                  (user) => ShadOption(
                                    value: user,
                                    child: Text(getUserName(user),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors
                                                  .getRoleColorWithRoleValue(
                                                      user.role),
                                            )),
                                  ),
                                ),
                                selectedOptionsBuilder: (context, values) =>
                                    Container(
                                  constraints: BoxConstraints(
                                    minWidth: context.width,
                                  ),
                                  child: Column(
                                    children: values
                                        .map((user) => Text(
                                              getUserName(user),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: AppColors
                                                        .getRoleColorWithRoleValue(
                                                            user.role),
                                                  ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                initialValues: sendToUsers,
                                placeholder: Container(
                                    constraints: BoxConstraints(
                                      minWidth: context.width,
                                    ),
                                    child: Text("Select Users")),
                              ),
                            ],
                          ),
                        ),
                        child: Text("Users")),
                  ]),
              SizedBox(height: AppSizes.sm),
              ShadInputFormField(
                enabled: editable,
                controller: customMessageController,
                minLines: 4,
                maxLines: 30,
                label: Text("Custom Message"),
                onChanged: (v) => {
                  _valuesChanged(),
                },
              ),
              SizedBox(height: AppSizes.md),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShadCheckboxFormField(
                    enabled: editable,
                    initialValue: alert?.enabled ?? true,
                    inputLabel: Text("Enabled"),
                    onChanged: (v) {
                      enabled = v;
                      _valuesChanged();
                    },
                  ),
                ],
              ),
              SizedBox(height: AppSizes.lg),
            ],
          ));
    });
  }

  _loadPossibleMonitorValues() async {
    // load possible monitor values
    try {
      final res = await api!.getPossibleMonitorValuesAlertEmails();
      _possibleMonitorValues = res.possibleValues;
    } catch (e) {
      logger.e("Failed to load users : $e");
      Toasts.showErrorToast(
          context: getContext,
          message: "Failed to load possible values for monitoring");
      Navigator.of(getContext).pop();
    }
  }
}
