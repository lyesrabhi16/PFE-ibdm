import 'package:data_table_2/data_table_2.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:ibdm/utils/helpers/page_index.dart';
import 'package:ibdm/services/api_django/api_client/models/sent_email.dart';
import 'package:ibdm/services/api_django/api_client/models/paginated_sent_email_list.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/pages/users.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/common/widgets/sent_email_form.dart';
import 'package:ibdm/common/widgets/alert_email_form.dart';

class EmailSentsPage extends StatefulWidget {
  const EmailSentsPage({super.key});

  @override
  State<EmailSentsPage> createState() => _EmailSentsPageState();
}

class _EmailSentsPageState extends State<EmailSentsPage> {
  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  late final strings = getTranslations(getContext).obs;

  final _showCheckboxColumn = false.obs;

  static final _searchController = TextEditingController();
  IbdmApiClient? api;
  final RxBool loaded = false.obs;

  RxList<SentEmail> sents = <SentEmail>[].obs;
  late PaginatedSentEmailList sentsMeta;

  final _selectedSents = <SentEmail>[].obs;
  List<String> _allMonitorValueTags = <String>[];

  int page = 1;
  String? monitorValueTagFilter;
  bool? activationStateFilter;

  static final _expandPerPage = false.obs;
  static final _perPageController = TextEditingController(text: "10");

  static final _filtersPopoverController = ShadPopoverController();
  static final _filtersActive = false.obs;

  static final _perPageFormKey = GlobalKey<FormState>();

  static final _tagFilterController = TextEditingController();
  static final _activationStateFilterController = TextEditingController();

  static final _sortPopoverController = ShadPopoverController();

  final RxMap<String, Sorter> _sortersASC = {
    "Temp D'Envoi": Sorter(
      isSelected: false,
      orderingValue: "temps_envoi",
    ),
    "Receptionist": Sorter(
      isSelected: false,
      orderingValue: "receptionist",
    ),
    "schedule": Sorter(
      isSelected: false,
      orderingValue: "schedule",
    ),
    "alert": Sorter(
      isSelected: false,
      orderingValue: "alert",
    ),
  }.obs;
  final RxMap<String, Sorter> _sortersDESC = {
    "Temp D'Envoi": Sorter(
      isSelected: false,
      orderingValue: "-temps_envoi",
    ),
    "Receptioniste": Sorter(
      isSelected: false,
      orderingValue: "-receptionist",
    ),
    "schedule": Sorter(
      isSelected: false,
      orderingValue: "-schedule",
    ),
    "alert": Sorter(
      isSelected: false,
      orderingValue: "-alert",
    ),
  }.obs;

  final _sortASC = true.obs;

  final _sortActive = false.obs;

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

        _showCheckboxColumn.value = _selectedSents.isNotEmpty;

        return Column(
          children: [
            Text(
              strings.value.emailSents,
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
                      onSubmitted: (_) => _loadSents(),
                      onTapOutside: (_) => _loadSents(),
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
                                                ScrollConfiguration.of(context)
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
                                              physics: BouncingScrollPhysics(),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                  minWidth: context.width / 2,
                                                  maxWidth: context.width,
                                                  minHeight: context.height,
                                                  maxHeight: context.height,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
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
                    borderRadius: BorderRadius.circular(20),
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DataTable2(
                  columnSpacing: _getColumnSpacing(),
                  onSelectAll: (selectedAll) => selectedAll == true
                      ? _selectedSents.addAll(sents)
                      : _selectedSents.clear(),
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
            _bottomPageActions(
              currentPage: sentsMeta.currentPage,
              nbrTotalPages: sentsMeta.totalPages,
              nbrShown: sentsMeta.data.length,
              nbrTotal: sentsMeta.totalResults,
              onPrevPress: (p) => {page = p, load()},
              onNextPress: (p) => {page = p, load()},
              onPagePress: (p) => {page = p, load()},
              data: sents,
              label: strings.value.sents,
            )
          ],
        );
      }),
    ));
  }

  void _onDeleteButtonClick({
    void Function()? onDeleteConfirmed,
  }) {
    _showCheckboxColumn.value = !_showCheckboxColumn.value;

    ShadToaster.of(context).show(
      ShadToast.destructive(
        closeIcon: SizedBox(),
        duration: Duration(days: 365),
        title: Text(strings.value.deletEmailSents),
        description: Obx(
          () {
            return _selectedSents.isEmpty
                ? Text(strings.value.selectEmailSentsToDelete)
                : Text(
                    "Are you sure you want to delete ${_selectedSents.length} Sent(s)?");
          },
        ),
        action: Obx(
          () => _selectedSents.isEmpty
              ? ShadButton(
                  onPressed: () {
                    _selectedSents.clear();
                    _showCheckboxColumn.value = false;
                    ShadToaster.of(context).hide();
                  },
                  child: Text(strings.value.cancel),
                )
              : Row(
                  children: [
                    ShadButton(
                      onPressed: () async {
                        await _deleteSents();
                        load();
                        onDeleteConfirmed?.call();
                      },
                      child: Text(strings.value.yes),
                    ),
                    ShadButton(
                      onPressed: () {
                        _selectedSents.clear();
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
                "${strings.value.page} : $currentPage", // if it is at least a small screen show it in this position
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
    bool center = false,
  }) {
    final context = getContext;

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
                  load: load,
                ),
              ),
            ],
          ),
          //right refresh button
          SizedBox(
            width: AppSizes.xl * 4,
            child: IconWithLabelButton(
              icon: Icons.refresh_rounded,
              onTap: () => load(),
              text: strings.value.refresh,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadSents() async {
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

    // Load sents
    try {
      sentsMeta = await api!.getSentEmails();
      sents = sentsMeta.data.obs;
    } catch (e) {
      logger.e("${strings.value.failedToLoadSents} : $e");
    }
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadSents();

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
      )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          label: Text(
        strings.value.tempEnvoi,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.receptionist,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          label: Text(
        strings.value.schedule,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )),
      DataColumn2(
          label: Text(
        strings.value.alers,
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
    ].nonNulls.toList();
  }

  _getRows() {
    return sents.map((e) {
      return DataRow2(
        selected: _selectedSents.contains(e),
        onSelectChanged: (selected) {
          if (selected == true) {
            _selectedSents.add(e);
          } else {
            _selectedSents.remove(e);
          }
        },
        onDoubleTap: () => _showViewSentEmailDialog(
          sent: e,
        ),
        cells: [
          DataCell(Text(
            (sents.indexOf(e) + 1).toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(Text(
            e.tempsEnvoi.toString().split('.')[0] ?? strings.value.unknown,
            style: Theme.of(context).textTheme.bodyMedium,
          )),
          DataCell(Text(
            e.receptionist.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(Text(
            e.schedule.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          )),
          DataCell(
            Text(
              e.alert.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      _showViewSentEmailDialog(sent: e);
                    },
                    icon: Icon(Icons.remove_red_eye_rounded),
                  ),
                ].nonNulls.toList(),
              ),
            ),
          ),
        ].nonNulls.toList(),
      );
    }).toList();
  }

  _showViewSentEmailDialog({
    required SentEmail sent,
    //required AlertEmail alert,
  }) {
    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text(
            sent.schedule != null
                ? "Schedule Sent: ${sent.schedule}"
                : sent.alert != null
                    ? "Alert Sent: ${sent.alert}"
                    : "Sent: ${sent.id}",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          description: Text(
            "view Sent settings of ${sent.tempsEnvoi.toString().split('.')[0].substring(0, 16)}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
                        _selectedSents.add(sent);
                        _onDeleteButtonClick(
                          onDeleteConfirmed: () => Navigator.of(context).pop(),
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
                                _selectedSents.add(sent);
                                _onDeleteButtonClick(
                                  onDeleteConfirmed: () =>
                                      Navigator.of(context).pop(),
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
          child: sent.schedule != null
              ? SentEmailForm(
                  //ScheduleEmailForm
                  sent: sent,
                  editable: false,
                  showIdField: true,
                )
              : sent.alert != null
                  ? SentEmailForm(
                      sent: sent,
                      editable: false,
                      showIdField: true,
                    )
                  : SentEmailForm(
                      sent: sent,
                      editable: false,
                      showIdField: true,
                    ),
        );
      },
    );
  }

  _getColumnSpacing() {
    return isSmallScreen(context) ? AppSizes.sm : AppSizes.md;
  }

  void sort(int columnIndex, bool ascending) {
    print("sort called");
  }

  _deleteSents() async {
    _done(int id) {
      _selectedSents.removeWhere((element) => element.id == id);
      sents.removeWhere((element) => element.id == id);
    }

    final state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
        context: context,
        message: strings.value.deletingSents,
        messageSuccess: strings.value.sentsDeleted,
        messageError: strings.value.deletEmailSent,
        state: state);
    await Future.wait(_selectedSents.map((sent) {
      return api!.destroyEmailSent(id: sent.id).then((value) {
        _done(sent.id);
      }).catchError((e) {
        logger.e("Failed to delete Sent email : $e");
        state.value = FutureState.error;
        Toasts.showErrorToast(
            context: context,
            message: "Failed To delete Sent with id: ${sent.id}");
      });
    }));
    if (state.value != FutureState.error) {
      state.value = FutureState.success;
    }
    load();
    Future.delayed(Duration(seconds: 2), () {
      toastification.dismissById(toast.id);
    });
    ShadToaster.of(Get.context!).hide();
  }

  Column filterContent(
      BuildContext context,
      TextEditingController tagFilterController,
      TextEditingController activationStateFilterController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(strings.value.filters,
            style: Theme.of(context).textTheme.headlineMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        Text(strings.value.filterEmailsSent,
            style: Theme.of(context).textTheme.bodyLarge),
        SizedBox(
          height: AppSizes.sm,
        ),
        Divider(),
        SizedBox(
          height: AppSizes.md,
        ),
        // Text(strings.value.filterbySendingtime,
        //     style: Theme.of(context).textTheme.bodyMedium),
        // SizedBox(
        //   height: AppSizes.sm,
        // ),
        // DropdownMenu<String>(
        //   hintText: strings.value.selectSendingtime,
        //   label: Text(strings.value.time),
        //   controller: tagFilterController,
        //   inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
        //         filled: true,
        //         fillColor: Theme.of(context).colorScheme.surface,
        //       ),
        //   initialSelection: monitorValueTagFilter,
        //   width: AppSizes.xl * 8,
        //   onSelected: (value) {
        //     // filter by monitored value tag
        //     if (monitorValueTagFilter == value) {
        //       tagFilterController.clear();
        //       monitorValueTagFilter = null;
        //       load();
        //       return;
        //     }
        //     monitorValueTagFilter = value;
        //     load();
        //   },
        //   dropdownMenuEntries: [
        //     for (String tag in _allMonitorValueTags)
        //       DropdownMenuEntry(
        //         value: tag,
        //         label: tag,
        //       ),
        //   ],
        // ),
        Text(strings.value.filterbyTypeofEmail,
            style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: AppSizes.sm,
        ),
        DropdownMenu<bool>(
          hintText: strings.value.selectTypeofEmail,
          label: Text(strings.value.scheduleEmail),
          controller: activationStateFilterController,
          width: AppSizes.xl * 8,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
          initialSelection: activationStateFilter,
          onSelected: (value) {
            // filter by monitored value tag
            if (activationStateFilter == value) {
              activationStateFilterController.clear();
              activationStateFilter = null;
              load();
              return;
            }
            activationStateFilter = value;
            load();
          },
          dropdownMenuEntries: [
            DropdownMenuEntry(
              value: true,
              label: strings.value.emailSchedules,
            ),
            DropdownMenuEntry(
              value: false,
              label: strings.value.emailAlerts,
            ),
          ],
        ),
      ],
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
            load();
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
            load();
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
          Text(strings.value.sortSents,
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(
            height: AppSizes.sm,
          ),
          Divider(),
          SizedBox(
            height: AppSizes.md,
          ),
          Text("${strings.value.order}:",
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
              sortASC.value = value == "asc";
              if (doLoad) {
                load();
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

  Widget PerPageInput({
    required RxBool expandPerPage,
    required TextEditingController perPageController,
    required Function load,
    int perPage = 10,
    double? customExpandPerPage,
  }) {
    return Form(
      key: _perPageFormKey,
      child: TextFormField(
        controller: perPageController,
        decoration: InputDecoration(
          labelText: 'Per Page',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a number';
          }
          final n = int.tryParse(value);
          if (n == null || n <= 0) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onFieldSubmitted: (value) {
          if (_perPageFormKey.currentState!.validate()) {
            load();
          }
        },
      ),
    );
  }

  _topPageActionsSmallScreen() {
    return Column(
      children: [
        //right refresh button
        IconWithLabelButton(
          icon: Icons.refresh_rounded,
          onTap: () => load(),
          text: strings.value.refresh,
        ),

        SizedBox(
          height: AppSizes.sm,
        ),
        PerPageInput(
          expandPerPage: _expandPerPage,
          perPageController: _perPageController,
          load: load,
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
