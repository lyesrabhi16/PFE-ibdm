import 'dart:convert';
import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/per_page_input.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/utils/helpers/theme_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:ibdm/utils/helpers/page_index.dart';
import 'package:ibdm/services/api_django/api_client/models/sent_email.dart';
import 'package:ibdm/services/api_django/api_client/models/paginated_sent_email_list.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/pages/users.dart';
import 'package:ibdm/common/widgets/sent_email_form.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class EmailSentsPage extends StatefulWidget {
  const EmailSentsPage({super.key});
  static WebSocketChannel? channel;
  static Stream? stream;
  @override
  State<EmailSentsPage> createState() => _EmailSentsPageState();
}

class _EmailSentsPageState extends State<EmailSentsPage> {
  Function? _getContext;

  BuildContext get getContext => _getContext!.call()!;

  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  final _showCheckboxColumn = false.obs;
  static final _searchController = TextEditingController();
  IbdmApiClient? api;
  final RxBool loaded = false.obs;
  final RxBool _loadingSentEmails = false.obs;

  RxList<SentEmail> sents = <SentEmail>[].obs;
  late PaginatedSentEmailList sentsMeta;

  int page = 1;
  String? monitorValueTagFilter;
  String? emailTypeFilter;

  static final _expandPerPage = false.obs;
  static final _perPageController = TextEditingController(text: "10");

  static final _filtersPopoverController = ShadPopoverController();
  static final _filtersActive = false.obs;

  static final _perPageFormKey = GlobalKey<FormState>();

  static final _tagFilterController = TextEditingController();
  static final _emailTypeFilterController = TextEditingController();

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
  }.obs;
  final RxMap<String, Sorter> _sortersDESC = {
    "Temp D'Envoi": Sorter(
      isSelected: false,
      orderingValue: "-temps_envoi",
    ),
    "Receptionist": Sorter(
      isSelected: false,
      orderingValue: "-receptionist",
    ),
  }.obs;

  final _sortASC = true.obs;

  final _sortActive = false.obs;

  String? prevSearch;
  int? prevPerPage;

  final Set<int> seen = {};

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(getContext).obs;
    return AppCustomContainer(
        backButton: true,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: max(context.height, 600),
              maxHeight: max(context.height, 600),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Obx(() {
                if (!loaded.value) {
                  load();
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                _showCheckboxColumn.value = false;

                return Column(
                  children: [
                    Text(
                      strings.value.emailSents,
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
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.horizontal,
                          runSpacing: AppSizes.sm,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            SearchBar(
                              controller: _searchController,
                              onSubmitted: (_) =>
                                  _searchController.text != prevSearch
                                      ? _loadSents()
                                      : null,
                              onTapOutside: (_) =>
                                  _searchController.text != prevSearch
                                      ? _loadSents()
                                      : null,
                              constraints: BoxConstraints(
                                maxWidth: 200,
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
                              children: [
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
                                                        PointerDeviceKind
                                                            .stylus,
                                                        PointerDeviceKind
                                                            .invertedStylus,
                                                        PointerDeviceKind
                                                            .trackpad,
                                                        PointerDeviceKind
                                                            .unknown,
                                                      },
                                                      scrollbars: true,
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          minWidth:
                                                              context.width / 2,
                                                          maxWidth:
                                                              context.width,
                                                          minHeight:
                                                              context.height,
                                                          maxHeight:
                                                              context.height,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  AppSizes.sm),
                                                          child: Scaffold(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
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
                            emailTypeFilterController:
                                _emailTypeFilterController,
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
                        child: _loadingSentEmails.value
                            ? Center(child: CircularProgressIndicator())
                            : DataTable2(
                                columnSpacing: _getColumnSpacing(),
                                showCheckboxColumn: _showCheckboxColumn.value,
                                sortColumnIndex: 0,
                                dataRowColor: WidgetStateProperty.fromMap({
                                  WidgetState.hovered: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  WidgetState.focused:
                                      colorScheme.primaryContainer,
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
                      onPrevPress: (p) => {page = p, _loadSents()},
                      onNextPress: (p) => {page = p, _loadSents()},
                      onPagePress: (p) => {page = p, _loadSents()},
                      data: sents,
                      label: strings.value.sents,
                    )
                  ],
                );
              }),
            ),
          ),
        ));
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
    required TextEditingController emailTypeFilterController,
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
                        emailTypeFilterController),
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
                  load: () => _perPageController.text != prevPerPage.toString()
                      ? _loadSents()
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
              onTap: () => _loadSents(),
              text: strings.value.refresh,
            ),
          ),
        ],
      ),
    );
  }

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

  Future<void> _loadSents() async {
    final strings = getTranslations(context).obs;
    _loadingSentEmails.value = true;

    // Load sents
    try {
      logger.e("ordering: ${_getOrdering()}");
      prevSearch = _searchController.text;
      prevPerPage = int.tryParse(_perPageController.text);
      sentsMeta = await api!.getSentEmails(
        page: page,
        ordering: _getOrdering(),
        search: _searchController.text,
        perPage: prevPerPage ?? 10,
        emailType: emailTypeFilter,
      );
      sents = sentsMeta.data.obs;
    } catch (e) {
      logger.e("${strings.value.failedToLoadSents} : $e");
    }

    _loadingSentEmails.value = false;
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    await _loadSents();
    connectToEmailBroadcast();

    loaded.value = true;
  }

  _getCols() {
    final strings = getTranslations(context).obs;

    return [
      DataColumn2(
          fixedWidth: 60,
          label: Text(
            strings.value.num,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          size: isAtMostSmallScreen(context) ? ColumnSize.M : ColumnSize.S,
          label: Text(
            strings.value.tempEnvoi,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )),
      DataColumn2(
          size: isAtMostSmallScreen(context) ? ColumnSize.L : ColumnSize.M,
          label: Text(
            strings.value.receptionist,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )),
      DataColumn2(
          size: ColumnSize.M,
          label: Text(
            strings.value.description,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
        fixedWidth: 60,
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
    return sents.map((e) {
      final _color = e.schedule != null
          ? colorScheme.secondary
          : e.alert != null
              ? (e.alert!.alertType.json == AlertTypeEnum.danger.json)
                  ? errorColor
                  : Colors.orange
              : null;

      return DataRow2(
        color: WidgetStateProperty.fromMap({
          WidgetState.hovered: isDarkModeOn()
              ? AppColors.grey.withAlpha(30)
              : AppColors.lightGrey,
          WidgetState.selected: isDarkModeOn()
              ? AppColors.grey.withAlpha(30)
              : AppColors.lightGrey,
          WidgetState.focused: isDarkModeOn()
              ? AppColors.grey.withAlpha(30)
              : AppColors.lightGrey
        }),
        onDoubleTap: () => _showViewSentEmailDialog(
          sent: e,
        ),
        cells: [
          DataCell(Text(
            (sents.indexOf(e) + 1).toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _color,
                ),
          )).removeWhen(isAtMostSmallScreen(context)),
          DataCell(FittedBox(
            child: Text(
              e.tempsEnvoi.toString().split('.')[0],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _color,
                  ),
              softWrap: false,
            ),
          )),
          DataCell(FittedBox(
            child: Text(
              e.receptionist.toString(),
              softWrap: false,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _color,
                  ),
            ),
          )),
          DataCell(FittedBox(
            child: Text(
              e.schedule != null
                  ? "${strings.value.schedule.toUpperCase()}(${e.schedule!.rapport.json})"
                  : "${strings.value.alert.toUpperCase()}(${e.alert?.alert.monitoredValue.json})",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _color,
                  ),
            ),
          )).removeWhen(isAtMostSmallScreen(context)),
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
  }) {
    final strings = getTranslations(context).obs;

    return showShadDialog(
      context: context,
      builder: (context) {
        return ShadDialog(
          title: Text(
            sent.schedule != null
                ? "${strings.value.scheduleSent}: ${sent.schedule!.rapport.json}"
                : sent.alert != null
                    ? "${strings.value.alertSent}: ${sent.alert!.alertType.json?.capitalize}  ${sent.alert!.alert.monitoredValue.json}"
                    : "${strings.value.sent}: ${sent.id}",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          description: Text(
            "${strings.value.sentAt} ${sent.tempsEnvoi.toString().split('.')[0].substring(0, 16)}",
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
            Obx(() => Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (loaded.value)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [],
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
          child: SentEmailForm(
            //ScheduleEmailForm
            sent: sent,
            alert: sent.alert?.alert,
            schedule: sent.schedule,
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

  Column filterContent(
      BuildContext context,
      TextEditingController tagFilterController,
      TextEditingController emailTypeFilterController) {
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
        DropdownMenu<String>(
          hintText: strings.value.selectTypeofEmail,
          label: Text(strings.value.scheduleEmail),
          controller: emailTypeFilterController,
          width: AppSizes.xl * 8,
          enableFilter: false,
          enableSearch: false,
          requestFocusOnTap: false,
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
          initialSelection: emailTypeFilter,
          onSelected: (value) {
            // filter by monitored value tag
            if (emailTypeFilter == value) {
              emailTypeFilterController.clear();
              emailTypeFilter = null;
              _loadSents();
              return;
            }
            emailTypeFilter = value;
            _loadSents();
          },
          dropdownMenuEntries: [
            DropdownMenuEntry(
              value: "schedule",
              label: strings.value.emailSchedules,
            ),
            DropdownMenuEntry(
              value: "alert",
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
            _loadSents();
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
            _loadSents();
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
          DropdownMenu<String>(
            initialSelection:
                sortASC.value ? strings.value.asc : strings.value.desc,
            dropdownMenuEntries: [
              DropdownMenuEntry(
                  value: strings.value.asc,
                  label: strings.value.asc.toUpperCase()),
              DropdownMenuEntry(
                  value: strings.value.desc,
                  label: strings.value.desc.toUpperCase()),
            ],
            enableFilter: false,
            enableSearch: false,
            requestFocusOnTap: false,
            onSelected: (value) {
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
                _loadSents();
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

  _topPageActionsSmallScreen() {
    final strings = getTranslations(context).obs;

    return Column(
      children: [
        //right refresh button
        IconWithLabelButton(
          icon: Icons.refresh_rounded,
          onTap: () => _loadSents(),
          text: strings.value.refresh,
        ),

        SizedBox(
          height: AppSizes.sm,
        ),
        PerPageInput(
          expandPerPage: _expandPerPage,
          perPageController: _perPageController,
          load: () => _perPageController.text != prevPerPage.toString()
              ? _loadSents()
              : null,
        ),
        SizedBox(
          height: AppSizes.lg,
        ),
        DividerWithText(text: strings.value.filter),
        filterContent(
            context, _tagFilterController, _emailTypeFilterController),
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

  Future<void> connectToEmailBroadcast() async {
    final strings = getTranslations(context).obs;
    try {
      if (EmailSentsPage.channel != null) {
        EmailSentsPage.channel!.sink.close();
        EmailSentsPage.channel = null;
      }

      EmailSentsPage.channel ??= WebSocketChannel.connect(
        Uri.parse(ApiConfig.sent_emails_broadcast_websocket_url),
      );
      await EmailSentsPage.channel!.ready;
      EmailSentsPage.stream ??=
          EmailSentsPage.channel!.stream.asBroadcastStream();
      EmailSentsPage.stream?.listen((event) async {
        if (!loaded.value || _loadingSentEmails.value) {
          logger.e("broadcast paused because of loading");
          return;
        }

        final data = JsonCodec().decode(event);
        SentEmail sentEmail = SentEmail.fromJson(data["data"]);
        if (seen.contains(sentEmail.id)) {
          logger.e("email seen already, aborting...");
          return;
        }
        seen.add(sentEmail.id);

        // compare the lists
        final sentsMetaFromApi = await api!.getSentEmails(
          page: page,
          ordering: _getOrdering(),
          search: _searchController.text,
          perPage: prevPerPage ?? 10,
          emailType: emailTypeFilter,
        );
        if (sents.isEmpty) {
          sents.insert(0, sentEmail);
          Toasts.showInfoToastNotification(
            context: context,
            title: strings.value.newEmailSent,
            autoDismiss: false,
            message:
                "${strings.value.to}: ${sentEmail.receptionist} ${sentEmail.alert != null ? strings.value.alert.toUpperCase() : strings.value.schedule.toUpperCase()} ${sentEmail.alert?.alertType.json ?? sentEmail.schedule?.rapport.json}",
          );
          return;
        }

        final firstMatches =
            sentsMetaFromApi.data.first.id == sentsMeta.data.first.id;
        final lastMatches =
            sentsMetaFromApi.data.last.id == sentsMeta.data.last.id;

        if (firstMatches && lastMatches) {
          logger.e(
              "${sentsMetaFromApi.data.first.id} ${sentsMeta.data.first.id} first and last items match, list didn't change, aborting...");
          return;
        }
        Toasts.showInfoToastNotification(
          context: context,
          title: strings.value.newEmailSent,
          autoDismiss: false,
          message:
              "${strings.value.to}: ${sentEmail.receptionist} ${sentEmail.alert != null ? strings.value.alert.toUpperCase() : strings.value.schedule.toUpperCase()} ${sentEmail.alert?.alertType.json ?? sentEmail.schedule?.rapport.json}",
        );
        sentsMeta = sentsMetaFromApi;
        sents.clear();
        sents.addAll(sentsMeta.data);
      });
    } catch (e) {
      logger.e("Error: $e");
      return;
    }
  }
}
