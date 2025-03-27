import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/avatar.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/per_page_input.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/common/widgets/user_form.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/page_index.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_io/io.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  static final UserController userController = Get.find();
  static final List<Role> roles = <Role>[];

  static Rx<int>? perPage = 10.obs;
  static final _perPageController = TextEditingController(
    text: "${perPage?.value}",
  );
  static final Rx<bool> expandPerPage = false.obs;

  static final Rx<bool> filtersActive = false.obs;
  static final Rx<bool> optionsActive = false.obs;
  static final filtersPopoverController = ShadPopoverController();

  static final Rx<bool> roleFilterSelected = false.obs;
  static Role? roleFilter;

  ///
  static final roleFilterController = TextEditingController();
  static final Rx<bool> _sortActive = false.obs;
  static final sortPopoverController = ShadPopoverController();
  static final RxList<PageIndex> searchedPageIndexes = <PageIndex>[].obs;

  static final searchController = TextEditingController();

  // add user form
  static final formKeyAddUser = GlobalKey<FormState>();
  static final addUserEmailController = TextEditingController();
  static final addUserNameController = TextEditingController();
  static final addFirstNameController = TextEditingController();
  static final addLastNameController = TextEditingController();

  static final addUserPasswordController = TextEditingController();
  static final addUserPhoneController = TextEditingController();
  static Role? addUserRole;
  static User? addUserSuperior;
  static File? addUserAvatarFile; // use on non-web
  static Uint8List? addUserAvatarBytes; // use on web
  static String? addUserAvatarBytesFileName; // use on web

  static final Rx<bool> showCheckboxColumn = false.obs;

  static final RxSet<User> selectedUsers = <User>{}.obs;

  static final ShadPopoverController actionsPopoverController =
      ShadPopoverController();

  static final ShadPopoverController optionsPopoverController =
      ShadPopoverController();

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final Rx<bool> _loaded = false.obs;

  final Rx<bool> _loadedAddUserSuperiorOptions = false.obs;

  final RxList<ShadOption<User>> _addUserSuperiorOptions =
      <ShadOption<User>>[].obs;

  final RxMap<int, bool> _hovered = <int, bool>{}.obs;

  final Rx<bool> _sortASC = true.obs;

  final RxMap<String, Sorter> _sortersASC = {
    "id": Sorter(isSelected: false, orderingValue: "id"),
    "email": Sorter(isSelected: false, orderingValue: "email"),
    "name": Sorter(isSelected: false, orderingValue: "username"),
    "role": Sorter(isSelected: false, orderingValue: "role"),
  }.obs;

  final RxMap<String, Sorter> _sortersDESC = {
    "id": Sorter(isSelected: false, orderingValue: "-id"),
    "email": Sorter(isSelected: false, orderingValue: "-email"),
    "name": Sorter(isSelected: false, orderingValue: "-username"),
    "role": Sorter(isSelected: false, orderingValue: "-role"),
  }.obs;

  int? nbrTotalUsers;

  int? nbrUsersShown;

  int? nbrTotalPages;

  int? currentPage;

  List<User> usersData = [];

  Future<void> _loadUsers(
    BuildContext context, {
    int page = 1,
  }) async {
    final strings = getTranslations(context);
    try {
      _loaded.value = false;
      final apiClient = await ApiClientInstance.getApiClient();
      // use stored perPage if it exists
      int? perPageInStorage = await LocalStorage.getPerPage();
      if (perPageInStorage != null &&
          perPageInStorage != UsersPage.perPage?.value) {
        UsersPage.perPage?.value = perPageInStorage;
      }
      logger.d("perPage?.value: ${UsersPage.perPage?.value}");
      // get data from api
      PaginatedUserList res = await apiClient.getUsers(
          perPage: UsersPage.perPage?.value,
          page: page,
          role: UsersPage.roleFilterSelected.value
              ? UsersPage.roleFilter!.roleId
              : null,
          search: UsersPage.searchController.text,
          ordering: _sortASC.value
              ? _sortersASC.entries
                  .where((e) => e.value.isSelected)
                  .firstOrNull
                  ?.value
                  .orderingValue
              : _sortersDESC.entries
                  .where((e) => e.value.isSelected)
                  .firstOrNull
                  ?.value
                  .orderingValue);
      final resContent = res.data;
      // set data
      usersData = resContent;
      nbrTotalPages = res.totalPages;
      nbrUsersShown = usersData.length;
      nbrTotalUsers = res.totalResults;
      currentPage = res.currentPage;
      UsersPage.perPage = res.perPage.obs;
    } catch (err) {
      if (err is dio.DioException) {
        logger.e(
          "Error: Failed to load data of users, known error",
          error: err,
        );
        if (context.mounted) {
          Toasts.showErrorToastNotification(
              context: context, message: strings.failedToLoadUsers);
        }

        return;
      }
      logger.e(
        "Error: Failed to load data of users, unknown error",
        error: err,
      );
      if (context.mounted) {
        Toasts.showErrorToastNotification(
          context: context,
          message: strings.unknownError,
        );
      }
    } finally {
      _loaded.value = true;
    }
  }

  List<int> _getIndexesOfPages(
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

  void setSorter(BuildContext context, String s, bool selected) {
    if (_sortASC.value) {
      for (var sorter in _sortersASC.entries) {
        if (sorter.key.toLowerCase() == s.toLowerCase()) {
          _sortersASC[s] = Sorter(
              isSelected: selected, orderingValue: sorter.value.orderingValue);
          _loadUsers(context);
        } else {
          _sortersASC[sorter.key] = Sorter(
              isSelected: false, orderingValue: sorter.value.orderingValue);
        }
      }
    } else {
      for (var sorter in _sortersDESC.entries) {
        if (sorter.key.toLowerCase() == s.toLowerCase()) {
          _sortersDESC[s] = Sorter(
              isSelected: selected, orderingValue: sorter.value.orderingValue);
          _loadUsers(context);
        } else {
          _sortersDESC[sorter.key] = Sorter(
              isSelected: false, orderingValue: sorter.value.orderingValue);
        }
      }
    }
  }

  void _load(BuildContext context) async {
    _loaded.value = false;
    UsersPage.roles.clear();
    UsersPage.roles.addAll(await UsersPage.userController.getRoles(context));
    logger.e("Roles ${UsersPage.roles}");
    await _loadUsers(context);
    _loaded.value = true;

    logger.e(
      "Loaded users page $usersData",
    );
  }

  @override
  Widget build(BuildContext context) {
    // load required data
    _load(context);

    final colorScheme = Theme.of(context).colorScheme;
    final strings = getTranslations(context).obs;

    return Obx(
      () {
        List<Widget> pageIndexesButtons = [];
        if (_loaded.value && usersData.isNotEmpty) {
          final indexes = _getIndexesOfPages(currentPage!, nbrTotalPages!,
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
                for (var index = 1; index <= nbrTotalPages!; index++) {
                  items.add(
                    PageIndex(
                      index: index,
                      button: ShadButton(
                        backgroundColor: colorScheme.surface,
                        foregroundColor: colorScheme.onSurface,
                        onPressed: () => _loadUsers(context, page: index),
                        child: Text(
                          "$index",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
                // set display to all
                UsersPage.searchedPageIndexes.value = items;
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
                      options: [
                        ...UsersPage.searchedPageIndexes.map((pi) => pi.button)
                      ],
                      searchPlaceholder: Text(strings.value.search),
                      onSearchChanged: (String value) {
                        if (value.isEmpty) {
                          UsersPage.searchedPageIndexes.value = items;
                        } else {
                          UsersPage.searchedPageIndexes.value = items
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
                onPressed: () {
                  _loadUsers(context, page: i);
                },
                child: Text("$i"),
              );
            },
          ).toList();
        }
        return AppCustomContainer(
          child: Center(
            child: _loaded.value
                ? Padding(
                    padding: EdgeInsets.all(AppSizes.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Center(
                          child: Text(strings.value.userManagement,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge),
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
                              alignment: WrapAlignment.spaceEvenly,
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              runSpacing: AppSizes.sm,
                              verticalDirection: VerticalDirection.down,
                              children: [
                                SearchBar(
                                  controller: UsersPage.searchController,
                                  onSubmitted: (_) => _loadUsers(context),
                                  onTapOutside: (_) => _loadUsers(context),
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
                                  alignment: WrapAlignment.spaceEvenly,
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.horizontal,
                                  runSpacing: AppSizes.sm,
                                  verticalDirection: VerticalDirection.down,
                                  children: [
                                    ShadButton(
                                        backgroundColor:
                                            colorScheme.surfaceContainerLow,
                                        hoverBackgroundColor:
                                            colorScheme.surfaceContainerHighest,
                                        foregroundColor: colorScheme.onSurface,
                                        onPressed: () {
                                          _showAddUserDialog(context);
                                        },
                                        child: Text(strings.value.addUser)),
                                    ShadButton.destructive(
                                        onPressed: () =>
                                            _onDeleteButtonClick(context),
                                        enabled:
                                            !UsersPage.showCheckboxColumn.value,
                                        child: Text(strings.value.delete)),
                                    SizedBox(
                                      width: AppSizes.xl * 4,
                                      child: ShadPopover(
                                        closeOnTapOutside: false,
                                        decoration: ShadDecoration(
                                          border: ShadBorder.all(
                                              width: 0,
                                              radius: BorderRadius.circular(
                                                  AppSizes.borderRadius)),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                        ),
                                        popover: (context) => ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 300,
                                          ),
                                          child: _getTopActionBar(
                                            context,
                                            colorScheme,
                                            alignment: WrapAlignment.center,
                                            expandPerPage: true,
                                            customExpandPerPage: context.width,
                                          ),
                                        ),
                                        controller:
                                            UsersPage.optionsPopoverController,
                                        child: IconWithLabelButton(
                                          icon: Icons.settings,
                                          text: strings.value.options,
                                          onTap: () {
                                            UsersPage.optionsActive.value =
                                                !UsersPage.optionsActive.value;
                                            UsersPage.optionsPopoverController
                                                .toggle();
                                          },
                                          active: UsersPage.optionsActive.value,
                                        ),
                                      ).removeWhen(
                                          isAtLeastMediumScreen(context)),
                                    ),
                                  ].nonNulls.toList(),
                                ),
                              ].nonNulls.toList(),
                            ),
                          ),
                        ),

                        SizedBox(height: AppSizes.sm),
                        // top actions
                        Container(
                                    width: context.width,
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceContainer,
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.borderRadius),
                                    ),
                                    child: _getTopActionBar(
                                        context, colorScheme,
                                        expandPerPage:
                                            UsersPage.expandPerPage.value))
                                .removeWhen(isAtMostSmallScreen(context)) ??
                            SizedBox.shrink(),

                        SizedBox(
                          height: AppSizes.sm,
                        ),

                        // data table
                        Expanded(
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: context.width,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.borderRadius),
                            ),
                            child: DataTable2(
                              sortAscending: true,
                              columnSpacing: _getColumnSpacing(context),
                              onSelectAll: (selectedAll) => selectedAll == true
                                  ? UsersPage.selectedUsers.addAll(usersData)
                                  : UsersPage.selectedUsers.clear(),
                              showCheckboxColumn:
                                  UsersPage.showCheckboxColumn.value,
                              sortColumnIndex: 0,
                              dataRowColor: WidgetStateProperty.fromMap({
                                WidgetState.hovered: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                WidgetState.focused:
                                    colorScheme.primaryContainer,
                              }),
                              columns: _getCols(context),
                              rows: _getRows(context),
                            ),
                          ),
                        ),

                        SizedBox(height: AppSizes.sm),
                        // page actions
                        Container(
                          width: context.width,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.borderRadius)),
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.sm),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runAlignment: WrapAlignment.center,
                              verticalDirection: VerticalDirection.down,
                              children: [
                                if (isAtLeastMediumScreen(context) &&
                                    !SideMenuContainer.open)
                                  Text(
                                    "${strings.value.page} : $currentPage", // if it is at least a small screen show it in this position
                                  ),
                                Row(
                                  mainAxisSize:
                                      isAtLeastMediumScreen(context) &&
                                              !SideMenuContainer.open
                                          ? MainAxisSize.min
                                          : MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ShadButton(
                                      backgroundColor: colorScheme.surface,
                                      foregroundColor: colorScheme.onSurface,
                                      enabled: currentPage != null
                                          ? currentPage! > 1
                                          : false,
                                      onPressed: () => _loadUsers(context,
                                          page: currentPage! - 1),
                                      child: Text(strings.value.prevPage),
                                    ),
                                    ...pageIndexesButtons,
                                    ShadButton(
                                      backgroundColor: colorScheme.surface,
                                      foregroundColor: colorScheme.onSurface,
                                      enabled: currentPage != null &&
                                              nbrTotalPages != null
                                          ? currentPage! < nbrTotalPages!
                                          : false,
                                      onPressed: () => _loadUsers(context,
                                          page: currentPage! + 1),
                                      child: Text(strings.value.nextPage),
                                    ),
                                  ],
                                ),
                                if (isAtMostSmallScreen(context) ||
                                    SideMenuContainer.open)
                                  Text(
                                      "${strings.value.page}: $currentPage"), // if it is at most a small screen show it in this position
                                Text(
                                    "${strings.value.users}: $nbrUsersShown/$nbrTotalUsers")
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget _getTopActionBar(
    BuildContext context,
    ColorScheme colorScheme, {
    WrapAlignment alignment = WrapAlignment.spaceBetween,
    bool reverseOrder = false,
    bool expandPerPage = false,
    double? customExpandPerPage,
  }) {
    final strings = getTranslations(context).obs;
    UsersPage.actionsPopoverController.setOpen(true);
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
                  controller: UsersPage.filtersPopoverController,
                  decoration: ShadDecoration(
                    border: ShadBorder.none,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  closeOnTapOutside: false,
                  popover: (context) => Container(
                    constraints: BoxConstraints(
                        minWidth: AppSizes.xl * 4, maxWidth: AppSizes.xl * 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(strings.value.filters,
                            style: Theme.of(context).textTheme.headlineMedium),
                        SizedBox(
                          height: AppSizes.sm,
                        ),
                        Text(strings.value.filterUser,
                            style: Theme.of(context).textTheme.bodyLarge),
                        SizedBox(
                          height: AppSizes.sm,
                        ),
                        Divider(),
                        SizedBox(
                          height: AppSizes.md,
                        ),
                        Text(strings.value.filterByRole,
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(
                          height: AppSizes.sm,
                        ),
                        DropdownMenu<Role>(
                          hintText: strings.value.role,
                          label: Text(strings.value.role),
                          controller: UsersPage.roleFilterController,
                          enableFilter: false,
                          enableSearch: false,
                          requestFocusOnTap: false,
                          inputDecorationTheme:
                              Theme.of(context).inputDecorationTheme.copyWith(
                                    filled: true,
                                    fillColor:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                          initialSelection: UsersPage.roleFilterSelected.value
                              ? UsersPage.roleFilter!
                              : null,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: AppColors.getRoleColorWithRoleValue(
                                      UsersPage.roleFilter?.name ?? "")),
                          onSelected: (value) {
                            UsersPage.roleFilterSelected.value = false;
                            if (value == UsersPage.roleFilter) {
                              UsersPage.roleFilter = null;
                              UsersPage.roleFilterController.clear();
                              _loadUsers(context);
                              return;
                            }
                            logger.e(
                                "${strings.value.role} :${UsersPage.roleFilter?.name} $value");
                            if (value != null) {
                              UsersPage.roleFilter = value;
                              UsersPage.roleFilterSelected.value = true;
                              _loadUsers(context);
                            }
                            logger.e(
                                "${strings.value.role} :${UsersPage.roleFilter?.name} $value");
                          },
                          dropdownMenuEntries: [
                            for (var role in UsersPage.roles)
                              DropdownMenuEntry(
                                  value: role,
                                  label: role.name,
                                  style: ButtonStyle(
                                    foregroundColor: WidgetStatePropertyAll(
                                        AppColors.getRoleColorWithRoleValue(
                                            role.name)),
                                  )),
                          ],
                        )
                      ],
                    ),
                  ),
                  child: IconWithLabelButton(
                    icon: Icons.filter_alt,
                    active: UsersPage.filtersActive.value,
                    text: strings.value.filter,
                    onTap: () {
                      UsersPage.filtersActive.value =
                          !UsersPage.filtersActive.value;
                      UsersPage.filtersPopoverController.toggle();
                    },
                  ),
                ),
              ),
              // sort button
              SizedBox(
                width: AppSizes.xl * 4,
                child: ShadPopover(
                  controller: UsersPage.sortPopoverController,
                  decoration: ShadDecoration(
                    border: ShadBorder.none,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  closeOnTapOutside: false,
                  popover: (context) => SizedBox(
                    width: AppSizes.xl * 4,
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(strings.value.sort,
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          SizedBox(
                            height: AppSizes.sm,
                          ),
                          Text(strings.value.sortUser,
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
                            initialValue: _sortASC.value
                                ? strings.value.asc
                                : strings.value.desc,
                            options: [
                              ShadOption(
                                  value: strings.value.asc,
                                  child: Text(strings.value.asc.toUpperCase())),
                              ShadOption(
                                  value: strings.value.desc,
                                  child:
                                      Text(strings.value.desc.toUpperCase())),
                            ],
                            selectedOptionBuilder: (context, value) => Text(
                              value,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            onChanged: (value) {
                              _sortASC.value = value == strings.value.asc;
                              _loadUsers(context);
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
                            children: [
                              ShadSwitch(
                                uncheckedTrackColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                checkedTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                value: (_sortASC.value
                                    ? _sortersASC["id"]!.isSelected
                                    : _sortersDESC["id"]!.isSelected),
                                label: Text(
                                  strings.value.id,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onChanged: (value) =>
                                    setSorter(context, "id", value),
                              ),
                              ShadSwitch(
                                uncheckedTrackColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                checkedTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                value: (_sortASC.value
                                    ? _sortersASC["email"]!.isSelected
                                    : _sortersDESC["email"]!.isSelected),
                                label: Text(
                                  strings.value.email,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onChanged: (value) =>
                                    setSorter(context, "email", value),
                              ),
                              ShadSwitch(
                                uncheckedTrackColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                checkedTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                value: (_sortASC.value
                                    ? _sortersASC["name"]!.isSelected
                                    : _sortersDESC["name"]!.isSelected),
                                label: Text(
                                  strings.value.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onChanged: (value) =>
                                    setSorter(context, "name", value),
                              ),
                              ShadSwitch(
                                uncheckedTrackColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                checkedTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                value: (_sortASC.value
                                    ? _sortersASC["role"]!.isSelected
                                    : _sortersDESC["role"]!.isSelected),
                                label: Text(
                                  strings.value.role,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onChanged: (value) =>
                                    setSorter(context, "role", value),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: IconWithLabelButton(
                    icon: Icons.sort_rounded,
                    active: UsersPage._sortActive.value,
                    text: strings.value.sort,
                    onTap: () {
                      UsersPage._sortActive.value =
                          !UsersPage._sortActive.value;
                      UsersPage.sortPopoverController.toggle();
                    },
                  ),
                ),
              ),
              // PerPage TextField
              SizedBox(
                  width: expandPerPage
                      ? customExpandPerPage ?? AppSizes.xl * 8
                      : AppSizes.xl * 3,
                  child: PerPageInput(
                    expandPerPage: UsersPage.expandPerPage as RxBool,
                    perPageController: UsersPage._perPageController,
                    perPage: UsersPage.perPage?.value ?? 10,
                    load: () => _loadUsers(context),
                  )),
            ],
          ),
          //right refresh button
          SizedBox(
            width: AppSizes.xl * 4,
            child: IconWithLabelButton(
              icon: Icons.refresh_rounded,
              onTap: () => _loadUsers(context, page: currentPage ?? 1),
              text: strings.value.refresh,
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _getCols(BuildContext context) {
    final strings = getTranslations(context).obs;
    return [
      DataColumn2(
          label: Text(
        strings.value.num,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      )).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          label: Expanded(
              child: Text(
        strings.value.avatar,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      ))).removeWhen(isAtMostSmallScreen(context)),
      DataColumn2(
          label: Expanded(
              child: Text(
        strings.value.id,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      ))).removeWhen(isAtMostMediumScreen(context)),
      DataColumn2(
          label: Expanded(
              child: Text(
        strings.value.email,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      ))),
      DataColumn2(
          label: Expanded(
              child: Text(
        strings.value.name,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      ))).removeWhen(isAtMostMediumScreen(context)),
      DataColumn2(
        label: Expanded(
          child: Text(
            strings.value.role,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
      DataColumn2(
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

  void _onDeleteButtonClick(BuildContext context,
      {Function()? onDeleteConfirmed}) {
    UsersPage.showCheckboxColumn.value = !UsersPage.showCheckboxColumn.value;
    final strings = getTranslations(context).obs;

    ShadToaster.of(context).show(
      ShadToast.destructive(
        closeIcon: SizedBox(),
        duration: Duration(days: 365),
        title: Text(strings.value.deleteUser),
        description: Obx(
          () {
            return UsersPage.selectedUsers.isEmpty
                ? Text(strings.value.selectUserDelete)
                : Text(strings.value
                    .confirmUsersDeletion(UsersPage.selectedUsers.length));
          },
        ),
        action: Obx(
          () => UsersPage.selectedUsers.isEmpty
              ? ShadButton(
                  onPressed: () {
                    UsersPage.selectedUsers.clear();
                    UsersPage.showCheckboxColumn.value = false;
                    ShadToaster.of(context).hide();
                  },
                  child: Text(strings.value.cancel),
                )
              : Row(
                  children: [
                    ShadButton(
                      onPressed: () async {
                        await _deleteUsers(context);
                        _loadUsers(context);
                        onDeleteConfirmed?.call();
                      },
                      child: Text(strings.value.yes),
                    ),
                    ShadButton(
                      onPressed: () {
                        UsersPage.selectedUsers.clear();
                        UsersPage.showCheckboxColumn.value = false;
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

  Future<void> _deleteUsers(BuildContext context) async {
    final api = await ApiClientInstance.getApiClient();
    for (User user in UsersPage.selectedUsers) {
      api.removeUser(
        id: user.userId,
      );
    }

    UsersPage.selectedUsers.clear();
    UsersPage.showCheckboxColumn.value = false;
    ShadToaster.of(context).hide();
  }

  Future<dynamic> _showAddUserDialog(BuildContext context) {
    _loadSuperiorsOptions(context);
    final strings = getTranslations(context).obs;

    return showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: Text(strings.value.addUser),
        description: Text(strings.value.addOneUser),
        actions: [
          ShadButton(
            child: Text(strings.value.addUser),
            onPressed: () => _onAddUserPressed(context),
          )
        ],
        child: Obx(
          () {
            if (!_loadedAddUserSuperiorOptions.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return UserForm(
              addUserEmailController: UsersPage.addUserEmailController,
              addUserNameController: UsersPage.addUserNameController,
              addFirstNameController: UsersPage.addFirstNameController,
              addLastNameController: UsersPage.addLastNameController,
              addUserPasswordController: UsersPage.addUserPasswordController,
              addUserPhoneController: UsersPage.addUserPhoneController,
              formKeyAddUser: UsersPage.formKeyAddUser,
              addUserSuperiorOptions: _addUserSuperiorOptions,
              onAddUser: (email, username, password, phone, role, superior,
                  firstName, lastName, avatarBytes, avatarFile) {
                logger.e("setRole: ${role.name}");
                UsersPage.addUserRole = role;
                UsersPage.addUserSuperior = superior;
                UsersPage.addUserAvatarBytes = avatarBytes;
                UsersPage.addUserAvatarBytesFileName = "avatar.jpg";
                UsersPage.addUserAvatarFile = avatarFile;
              },
            );
          },
        ),
      ),
    );
  }

  WidgetStateProperty<Color>? _getRowColor(BuildContext context, User user) {
    return WidgetStateProperty.resolveWith((s) {
      if (s.any((s) => [
            WidgetState.hovered,
            WidgetState.selected,
            WidgetState.focused
          ].contains(s))) {
        return AppColors.getRoleColorWithRoleValue(user.role);
      } else {
        return Colors.transparent;
      }
    });
  }

  List<DataRow> _getRows(BuildContext context) {
    final strings = getTranslations(context).obs;
    return usersData.map((user) {
      if (_hovered[user.userId] == null) {
        _hovered[user.userId] = false;
      }
      final actionsController = ShadPopoverController();
      return DataRow2(
        color: _getRowColor(context, user),
        onDoubleTap: () => _showViewUserDialog(context, user),
        cells: [
          DataCell(
            Text(
              (usersData.indexOf(user) + 1).toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ).removeWhen(isAtMostSmallScreen(context)),
          DataCell(
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.sm),
                child: Avatar(user: user),
              ),
            ),
          ).removeWhen(isAtMostSmallScreen(context)),
          DataCell(
            Text(
              "${user.userId}",
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ).removeWhen(isAtMostMediumScreen(context)),
          DataCell(
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              getUserName(user, orEmail: false),
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ).removeWhen(isAtMostMediumScreen(context)),
          DataCell(
            MouseRegion(
              onEnter: (p) => _hovered[user.userId] = true,
              onExit: (p) => _hovered[user.userId] = false,
              child: Text(
                user.role.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _hovered[user.userId] == true
                          ? null
                          : AppColors.getRoleColorWithRoleValue(user.role),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          DataCell(
            FittedBox(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      _showViewUserDialog(context, user);
                    },
                    icon: Icon(Icons.remove_red_eye_rounded),
                  ).removeWhen(isAtMostMediumScreen(context)),
                  IconButton(
                    onPressed: () {
                      _showEditUserDialog(context, user);
                    },
                    icon: Icon(Icons.edit),
                  ).removeWhen(isAtMostSmallScreen(context)),
                  IconButton(
                    onPressed: () {
                      UsersPage.selectedUsers.add(user);
                      _onDeleteButtonClick(context);
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
                            icon: Icons.remove_red_eye_rounded,
                            text: strings.value.view,
                            onTap: () => {
                              _showViewUserDialog(context, user),
                              actionsController.toggle(),
                            },
                          ),
                          IconWithLabelButton(
                            icon: Icons.edit,
                            onTap: () {
                              _showEditUserDialog(context, user);
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
        selected: UsersPage.selectedUsers.contains(user),
        onSelectChanged: (value) {
          if (UsersPage.selectedUsers.contains(user)) {
            logger.d("unselected ${user.userId}: $value");
            UsersPage.selectedUsers.remove(user);
          } else {
            logger.d("selected ${user.userId}: $value");
            UsersPage.selectedUsers.add(user);
          }
        },
      );
    }).toList();
  }

  void _loadSuperiorsOptions(BuildContext context) async {
    _loadedAddUserSuperiorOptions.value = false;
    final strings = getTranslations(context).obs;
    final me =
        "${UsersPage.userController.user!.username.isEmpty ? UsersPage.userController.user!.email : UsersPage.userController.user!.username}(${strings.value.me})";
    List<ShadOption<User>> options = [
      ShadOption(
        value: UsersPage.userController.user!,
        child: Text(
          me,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.getRoleColorWithRoleValue(
                    UsersPage.userController.user!.role),
              ),
        ),
      ),
    ];
    // can add any kind of user
    try {
      traverseSubordinatesTree(
          User user, Function(User user) onUserFound) async {
        if (user.subordinates.isNotEmpty) {
          for (var user in user.subordinates) {
            final subUser = await (await ApiClientInstance.getApiClient())
                .getUser(id: user.userId);
            onUserFound(subUser);
            traverseSubordinatesTree(subUser, onUserFound);
          }
        }
      }

      await traverseSubordinatesTree(
        UsersPage.userController.user!,
        (user) => options.add(
          ShadOption(
              value: user,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(user.username.isNotEmpty ? user.username : user.email),
                  SizedBox(width: AppSizes.md),
                  Text(
                    user.role,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.getRoleColorWithRoleValue(user.role),
                        ),
                  )
                ],
              )),
        ),
      );

      _addUserSuperiorOptions.value = options;
      _loadedAddUserSuperiorOptions.value = true;
      return;
    } catch (e) {
      logger.e("failed to get users: $e");
      Toasts.showErrorToastNotification(
          context: context,
          message: strings.value.failedToGetUsersMessage,
          title: strings.value.errorFailedToGetUsers);
      _addUserSuperiorOptions.value = [];
      _loadedAddUserSuperiorOptions.value = true;
      return;
    }
  }

  Future _showEditUserDialog(BuildContext context, User user) async {
    final strings = getTranslations(context).obs;
    _loadSuperiorsOptions(context);
    logger.d("showing edit dialog");
    User newUser = User(
      userId: user.userId,
      email: user.email,
      username: user.username,
      phoneNumber: user.phoneNumber,
      role: user.role,
      avatarUrl: user.avatarUrl,
      superiors: user.superiors,
      firstName: user.firstName,
      lastName: user.lastName,
      subordinates: user.subordinates,
      userPermissions: user.userPermissions,
    );
    Uint8List? editUserAvatarBytes;
    File? editUserAvatarFile;
    String? password;
    logger.d("showing edit dialog 2");
    final loadedUserDetails = false.obs;
    User? userDetails;
    final Rx<bool> loadedRoles = false.obs;
    final RxList<Role> roles = <Role>[].obs;
    ApiClientInstance.getApiClient().then((api) async {
      roles.clear();
      roles.addAll((await api.getRoles()).data);
      loadedRoles.value = true;
      final res = await api.getUser(id: user.userId);
      userDetails = res;
      loadedUserDetails.value = true;
      logger.d("user details fetched");
    }).catchError((e) {
      logger.e("failed to get user details: $e");
      Toasts.showErrorToastNotification(
          context: context, message: strings.value.failedToGetUser);
      loadedUserDetails.value = true;
    });

    return showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title:
            Text("${strings.value.user}: ${getUserName(user, orEmail: true)}"),
        description: Text(strings.value.editUser),
        actions: [
          Obx(() => Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (loadedUserDetails.value)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ShadButton.destructive(
                            child: Text(strings.value.delete),
                            onPressed: () {
                              UsersPage.selectedUsers.add(userDetails!);
                              _onDeleteButtonClick(
                                context,
                                onDeleteConfirmed: () =>
                                    Navigator.of(context).pop(),
                              );
                            },
                          ),
                          ShadButton(
                            icon: Icon(Icons.edit),
                            child: Text(strings.value.save),
                            onPressed: () {
                              onSaveButtonPressed(
                                context: context,
                                user: newUser,
                                password:
                                    password != null && password.isNotEmpty
                                        ? password
                                        : null,
                                userAvatarBytes: editUserAvatarBytes,
                                userAvatarFile: editUserAvatarFile,
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
              ))
        ],
        child: Obx(
          () {
            if (!loadedUserDetails.value ||
                !loadedRoles.value ||
                !_loadedAddUserSuperiorOptions.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final role = roles.firstWhereOrNull((r) => r.name == user.role);
            return UserForm(
              editable: true,
              showPlaceHolders: false,
              role: role,
              user: user,
              onAddUser: (email, username, password, phone, role, superior,
                      firstName, lastName, avatarBytes, avatarFile) =>
                  {
                editUserAvatarBytes = avatarBytes,
                editUserAvatarFile = avatarFile,
                password = password,
                logger.e("superior: $superior"),
                UsersPage.addUserSuperior = superior,
                newUser = User(
                  userId: newUser.userId,
                  email: email,
                  username: username,
                  phoneNumber: phone,
                  role: role.name,
                  superiors: newUser.superiors,
                  firstName: firstName,
                  lastName: lastName,
                  avatarUrl: null,
                  subordinates: newUser.subordinates,
                  userPermissions: newUser.userPermissions,
                )
              },
              addUserEmailController:
                  TextEditingController(text: userDetails!.email),
              addUserNameController:
                  TextEditingController(text: userDetails!.username),
              addFirstNameController:
                  TextEditingController(text: userDetails!.firstName),
              addLastNameController:
                  TextEditingController(text: userDetails!.lastName),
              addUserPasswordController: TextEditingController(),
              addUserPhoneController:
                  TextEditingController(text: userDetails!.phoneNumber),
              formKeyAddUser: UsersPage.formKeyAddUser,
              addUserSuperiorOptions: _addUserSuperiorOptions,
            );
          },
        ),
      ),
    );
  }

  Future _showViewUserDialog(BuildContext context, User user) async {
    logger.e("showing view dialog");
    final loadedUserDetails = false.obs;
    User? userDetails;
    final Rx<bool> loadedRoles = false.obs;
    final RxList<Role> roles = <Role>[].obs;
    final strings = getTranslations(context).obs;

    ApiClientInstance.getApiClient().then((api) async {
      roles.clear();
      roles.addAll((await api.getRoles()).data);
      loadedRoles.value = false;
      final res = await api.getUser(id: user.userId);
      userDetails = res;
      loadedUserDetails.value = true;
      logger.d("user details fetched");
    }).catchError((e) {
      logger.e("failed to get user details: $e");
      Toasts.showErrorToastNotification(
        context: context,
        message: strings.value.errorFailedToGetUsers,
      );
      loadedUserDetails.value = true;
    });

    return showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title:
            Text("${strings.value.user}: ${getUserName(user, orEmail: true)}"),
        description: Text(strings.value.viewUserDetails),
        removeBorderRadiusWhenTiny: true,
        actions: [
          ShadButton(
            icon: Icon(Icons.close),
            child: Text(strings.value.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ).removeWhen(isAtLeastMediumScreen(context)),
          Obx(() {
            return loadedUserDetails.value
                ? ShadButton.destructive(
                    child: Text(strings.value.delete),
                    onPressed: () {
                      UsersPage.selectedUsers.add(userDetails!);
                      _onDeleteButtonClick(
                        context,
                        onDeleteConfirmed: () => Navigator.of(context).pop(),
                      );
                    },
                  )
                : SizedBox.shrink();
          }).removeWhen(isAtLeastMediumScreen(context)),
          Obx(() {
            return loadedUserDetails.value
                ? ShadButton(
                    icon: Icon(Icons.edit),
                    child: Text(strings.value.edit),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showEditUserDialog(context, user);
                    },
                  )
                : SizedBox.shrink();
          }).removeWhen(isAtLeastMediumScreen(context)),
          Obx(() => Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (loadedUserDetails.value)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ShadButton.destructive(
                            child: Text(strings.value.delete),
                            onPressed: () {
                              UsersPage.selectedUsers.add(userDetails!);
                              _onDeleteButtonClick(
                                context,
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
                              _showEditUserDialog(context, user);
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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 700,
          ),
          child: Obx(
            () {
              if (!loadedUserDetails.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final role = roles.firstWhereOrNull((r) => r.name == user.role);
              return UserForm(
                editable: false,
                showPlaceHolders: false,
                role: role,
                user: user,
                addUserEmailController:
                    TextEditingController(text: userDetails!.email),
                addUserNameController:
                    TextEditingController(text: userDetails!.username),
                addFirstNameController:
                    TextEditingController(text: userDetails!.firstName),
                addLastNameController:
                    TextEditingController(text: userDetails!.lastName),
                addUserPasswordController:
                    TextEditingController(text: strings.value.hashedValue),
                addUserPhoneController:
                    TextEditingController(text: userDetails!.phoneNumber),
                formKeyAddUser: GlobalKey<FormState>(),
                addUserSuperiorOptions: <ShadOption<User>>[].obs,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onAddUserPressed(BuildContext context) async {
    final strings = getTranslations(context).obs;
    if (!UsersPage.formKeyAddUser.currentState!.validate()) {
      Toasts.showErrorToastNotification(
          context: context, message: strings.value.pleaseFixErrorsInTheForm);
      return;
    }
    Rx<FutureState> loadingToastState = FutureState.loading.obs;
    // show loading toast
    final toast = Toasts.showStatefulToast(
      context: context,
      message: strings.value.addingUser,
      messageError: strings.value.failedToAddUser,
      messageSuccess: strings.value.userAddedSuccessfully,
      state: loadingToastState,
    );
    // add user request
    try {
      final api = await ApiClientInstance.getApiClient();
      logger.e("addUserRole: ${UsersPage.addUserRole!.name}");
      late final User res;
      if (kIsWeb) {
        res = await api.addUsersOnWeb(
          avatar: UsersPage.addUserAvatarBytes,
          avatarFileName: UsersPage.addUserAvatarBytesFileName,
          email: UsersPage.addUserEmailController.text,
          password: UsersPage.addUserPasswordController.text,
          role: UsersPage.addUserRole!.name,
          phoneNumber: UsersPage.addUserPhoneController.text,
          username: UsersPage.addUserNameController.text,
          firstName: UsersPage.addFirstNameController.text,
          lastName: UsersPage.addLastNameController.text,
        );
      } else {
        res = await api.addUser(
          avatar: UsersPage.addUserAvatarFile,
          email: UsersPage.addUserEmailController.text,
          password: UsersPage.addUserPasswordController.text,
          role: UsersPage.addUserRole!.name,
          phoneNumber: UsersPage.addUserPhoneController.text,
          username: UsersPage.addUserNameController.text,
        );
      }

      if (UsersPage.addUserSuperior != null) {
        await api.addSubordinateAndSuperior(
          body: SubordinateAndSuperiorRequest(
              superior: UsersPage.addUserSuperior!.userId,
              subordinate: res.userId),
        );
      } else {
        logger.e("superior is null");
      }

      // show success toast
      loadingToastState.value = FutureState.success;
      // close toast after a short duration
      Future.delayed(
          Duration(seconds: 1), () => Toastification().dismissById(toast.id));
      // reload users list
      _loadUsers(context);
    } catch (e) {
      logger.e("failed to add user: $e");
      // show error toast
      loadingToastState.value = FutureState.error;
      // close toast after a duration
      Future.delayed(
          Duration(seconds: 3), () => Toastification().dismissById(toast.id));
    }
  }

  Future<void> onSaveButtonPressed({
    required BuildContext context,
    required User user,
    Uint8List? userAvatarBytes,
    File? userAvatarFile,
    String? password,
  }) async {
    final strings = getTranslations(context).obs;
    if (!UsersPage.formKeyAddUser.currentState!.validate()) {
      Toasts.showErrorToastNotification(
          context: context, message: strings.value.pleaseFixErrorsInTheForm);
      return;
    }
    Rx<FutureState> loadingToastState = FutureState.loading.obs;
    // show loading toast
    final toast = Toasts.showStatefulToast(
      context: context,
      message: strings.value.savingUser,
      messageError: strings.value.failedToSaveUser,
      messageSuccess: strings.value.userSavedSuccessfully,
      state: loadingToastState,
    );
    // add user request
    try {
      final api = await ApiClientInstance.getApiClient();
      //logger.e("addUserRole: ${_addUserRole!.name}");
      logger.e(
          "${strings.value.avatar} : ${userAvatarBytes != null} ${UsersPage.addUserAvatarBytesFileName} ${userAvatarFile != null}");
      late final User res;
      if (kIsWeb) {
        res = await api.partialUpdateUserOnWeb(
          id: user.userId,
          avatar: userAvatarBytes,
          avatarFileName: UsersPage.addUserAvatarBytesFileName ?? "avatar.jpg",
          email: user.email,
          password: password,
          role: user.role,
          phoneNumber: user.phoneNumber,
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
        );
      } else {
        res = await api.partialUpdateUser(
          id: user.userId,
          avatar: userAvatarFile,
          email: user.email,
          password: password,
          role: user.role,
          phoneNumber: user.phoneNumber,
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
        );
      }
      logger.e("superior: ${UsersPage.addUserSuperior?.userId}");
      if (UsersPage.addUserSuperior != null) {
        if (user.superiors.isEmpty) {
          await api.addSubordinateAndSuperior(
              body: SubordinateAndSuperiorRequest(
                  superior: UsersPage.addUserSuperior!.userId,
                  subordinate: res.userId));
        } else {
          final res = await api.getSubordinateAndSuperiorId(
              superior: user.superiors.first.userId, subordinate: user.userId);
          await api.partialUpdateSubordinateAndSuperior(
            id: res.id,
            body: PatchedSubordinateAndSuperiorRequest(
                superior: UsersPage.addUserSuperior!.userId,
                subordinate: user.userId),
          );
        }
      } else {
        logger.e("superior is null");
        if (user.superiors.isNotEmpty) {
          final res = await api.getSubordinateAndSuperiorId(
              superior: user.superiors.first.userId, subordinate: user.userId);
          await api.removeSubordinateAndSuperior(
            id: res.id,
          );
        }
      }

      // show success toast
      loadingToastState.value = FutureState.success;
      // close toast after a short duration
      Future.delayed(
          Duration(seconds: 1), () => Toastification().dismissById(toast.id));
      // reload users list
      _loadUsers(context);
    } catch (e) {
      logger.e("failed to add user: $e");
      // show error toast
      loadingToastState.value = FutureState.error;
      // close toast after a duration
      Future.delayed(
          Duration(seconds: 3), () => Toastification().dismissById(toast.id));
    }
  }

  _getColumnSpacing(BuildContext context) {
    return isSmallScreen(context) ? AppSizes.sm : AppSizes.md;
  }
}

class Sorter {
  final bool isSelected;
  final String orderingValue;

  Sorter({required this.isSelected, required this.orderingValue});
}

extension DataColumnremoveWhen on DataColumn2 {
  DataColumn2? removeWhen(bool condition) {
    return condition ? null : this;
  }
}

extension DataCellremoveWhen on DataCell {
  DataCell? removeWhen(bool condition) {
    return condition ? null : this;
  }
}
