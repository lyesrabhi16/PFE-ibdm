import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/avatar.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/common/widgets/user_form.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/page_index.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:ibdm/utils/helpers/validators/app_validators.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_io/io.dart';
import 'package:ibdm/generated/l10n.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  static final UserController userController = Get.find();
  static final List<Role> roles = <Role>[];

  final Rx<bool> _loaded = false.obs;
  final Rx<bool> _loadedAddUserSuperiorOptions = false.obs;
  final RxList<ShadOption<User>> _addUserSuperiorOptions =
      <ShadOption<User>>[].obs;

  final RxMap<int, bool> _hovered = <int, bool>{}.obs;

  static Rx<int>? perPage = 10.obs;
  static final _perPageController = TextEditingController(
    text: "${perPage?.value}",
  );
  static final Rx<bool> _expandPerPage = false.obs;
  static final _perPageFormKey = GlobalKey<FormState>();

  static final Rx<bool> _filtersActive = false.obs;
  static final _filtersPopoverController = ShadPopoverController();

  static final Rx<bool> _roleFilterSelected = false.obs;
  static Role? _roleFilter;
  static final _roleFilterController = TextEditingController();
  static final Rx<bool> _sortActive = false.obs;
  static final _sortPopoverController = ShadPopoverController();
  final Rx<bool> _sortASC = true.obs;
  final RxMap<String, Sorter> _sortersASC = {
    "id": Sorter(isSelected: false, ordering_value: "id"),
    "email": Sorter(isSelected: false, ordering_value: "email"),
    "name": Sorter(isSelected: false, ordering_value: "username"),
    "role": Sorter(isSelected: false, ordering_value: "role"),
  }.obs;
  final RxMap<String, Sorter> _sortersDESC = {
    "id": Sorter(isSelected: false, ordering_value: "-id"),
    "email": Sorter(isSelected: false, ordering_value: "-email"),
    "name": Sorter(isSelected: false, ordering_value: "-username"),
    "role": Sorter(isSelected: false, ordering_value: "-role"),
  }.obs;

  int? nbrTotalUsers;
  int? nbrUsersShown;
  int? nbrTotalPages;
  int? currentPage;
  List<User> usersData = [];

  static final RxList<PageIndex> searchedPageIndexes = <PageIndex>[].obs;

  static final _searchController = TextEditingController();

  // add user form
  static final _formKeyAddUser = GlobalKey<FormState>();
  static final _addUserEmailController = TextEditingController();
  static final _addUserNameController = TextEditingController();
  static final _addFirstNameController = TextEditingController();
  static final _addLastNameController = TextEditingController();

  static final _addUserPasswordController = TextEditingController();
  static final _addUserPhoneController = TextEditingController();
  static Role? _addUserRole;
  static User? _addUserSuperior;
  static File? _addUserAvatarFile; // use on non-web
  static Uint8List? _addUserAvatarBytes; // use on web
  static String? _addUserAvatarBytesFileName; // use on web

  static final Rx<bool> _showCheckboxColumn = false.obs;

  static final RxSet<User> _selectedUsers = <User>{}.obs;

  static final ShadPopoverController _actionsPopoverController =
      ShadPopoverController();

  Future<void> _loadUsers(
    BuildContext context, {
    int page = 1,
  }) async {
    try {
      _loaded.value = false;
      final apiClient = await ApiClientInstance.getApiClient();
      // use stored perPage if it exists
      int? perPageInStorage = await LocalStorage.getPerPage();
      if (perPageInStorage != null && perPageInStorage != perPage?.value) {
        perPage?.value = perPageInStorage;
      }
      print("perPage?.value: ${perPage?.value}");
      // get data from api
      PaginatedUserList res = await apiClient.getUsers(
          perPage: perPage?.value,
          page: page,
          role: _roleFilterSelected.value ? _roleFilter!.roleId : null,
          search: _searchController.text,
          ordering: _sortASC.value
              ? _sortersASC.entries
                  .where((e) => e.value.isSelected)
                  .firstOrNull
                  ?.value
                  .ordering_value
              : _sortersDESC.entries
                  .where((e) => e.value.isSelected)
                  .firstOrNull
                  ?.value
                  .ordering_value);
      final resContent = res.data;
      // set data
      usersData = resContent;
      nbrTotalPages = res.totalPages;
      nbrUsersShown = usersData.length;
      nbrTotalUsers = res.totalResults;
      currentPage = res.currentPage;
      perPage = res.perPage.obs;
    } catch (err) {
      if (err is dio.DioException) {
        logger.e(
          "Error: Failed to load data of users, known error",
          error: err,
        );
        Toasts.showErrorToastNotification(
            context: context,
            message: "Details: ${err.message}",
            title: "Error: Failed to load data of users");
        return;
      }
      logger.e(
        "Error: Failed to load data of users, unknown error",
        error: err,
      );
      Toasts.showErrorToastNotification(
          context: context,
          message: "Details: Unknown Error Occured",
          title: "Error: Failed to load data of users");
    } finally {
      _loaded.value = true;
    }
  }

  _loadSuperiors(BuildContext context, User user) {
    logger.d("loading superiors for user: ${user.username}");
    /* if (user.superiors == null || user.superiors!.isEmpty) {
    return [];
  }
  return user.superiors!.map(
    (s) {
      return ShadOption<User>(
        value: s.superior!,
        child: Text(s.superior!.name ?? s.superior!.email),
      );
    },
  ).toList(); */
    return [];
  }

  List<int> _getIndexesOfPages(
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

  void setSorter(BuildContext context, String s, bool selected) {
    if (_sortASC.value) {
      for (var sorter in _sortersASC.entries) {
        if (sorter.key.toLowerCase() == s.toLowerCase()) {
          _sortersASC[s] = Sorter(
              isSelected: selected,
              ordering_value: sorter.value.ordering_value);
          _loadUsers(context);
        } else {
          _sortersASC[sorter.key] = Sorter(
              isSelected: false, ordering_value: sorter.value.ordering_value);
        }
      }
    } else {
      for (var sorter in _sortersDESC.entries) {
        if (sorter.key.toLowerCase() == s.toLowerCase()) {
          _sortersDESC[s] = Sorter(
              isSelected: selected,
              ordering_value: sorter.value.ordering_value);
          _loadUsers(context);
        } else {
          _sortersDESC[sorter.key] = Sorter(
              isSelected: false, ordering_value: sorter.value.ordering_value);
        }
      }
    }
  }

  void _load(BuildContext context) async {
    _loaded.value = false;
    roles.clear();
    roles.addAll(await userController.getRoles(context));
    logger.e("Roles $roles");
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
    String getRoleLabel(BuildContext context, Role r) {
      final strings = getTranslations(context); // Récupérer la traduction
      print("Langue active : ${Localizations.localeOf(context)}");
      print("Traduction pour ${r.json}: ${strings.role_ADMIN_SYSTEM}");

      switch (r) {
        case Role.adminSystem:
          return strings.role_ADMIN_SYSTEM;
        case Role.admin:
          return strings.role_ADMIN;
        case Role.supervisor:
          return strings.role_SUPERVISOR;
        case Role.operateur:
          return strings.role_OPERATEUR;
        default:
          return r.json!;
      }
    }

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
                searchedPageIndexes.value = items;
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SearchBar(
                                  onChanged: (value) async {
                                    final api =
                                        await ApiClientInstance.getApiClient();
                                  },
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
                                Row(
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
                                        enabled: !_showCheckboxColumn.value,
                                        child: Text(strings.value.delete)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: AppSizes.sm),
                        // top actions
                        Container(
                                width: context.width,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: _getTopActionBar(context, colorScheme,
                                    expandPerPage: _expandPerPage.value))
                            .optionalWhen(isAtMostSmallScreen(context)),

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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: usersData.isEmpty
                                ? Center(
                                    child: Text(
                                    "No Users Found",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ))
                                : DataTable2(
                                    sortAscending: true,
                                    columnSpacing: _getColumnSpacing(context),
                                    onSelectAll: (selectedAll) =>
                                        selectedAll == true
                                            ? _selectedUsers.addAll(usersData)
                                            : _selectedUsers.clear(),
                                    showCheckboxColumn:
                                        _showCheckboxColumn.value,
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
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.md,
                              vertical: AppSizes.sm,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // left row
                                Row(
                                  children: [
                                    // filter button
                                    SizedBox(
                                      width: AppSizes.xl * 4,
                                      child: ShadPopover(
                                        controller: _filtersPopoverController,
                                        decoration: ShadDecoration(
                                          border: ShadBorder.none,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                        ),
                                        closeOnTapOutside: false,
                                        popover: (context) => SizedBox(
                                          width: AppSizes.xl * 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(strings.value.filter,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium),
                                              SizedBox(
                                                height: AppSizes.sm,
                                              ),
                                              Text(strings.value.filterUser,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                              SizedBox(
                                                height: AppSizes.sm,
                                              ),
                                              Divider(),
                                              SizedBox(
                                                height: AppSizes.md,
                                              ),
                                              Text(strings.value.filterByRole,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                              SizedBox(
                                                height: AppSizes.sm,
                                              ),
                                              DropdownMenu(
                                                hintText: strings.value.role,
                                                label: Text(strings.value.role),
                                                inputDecorationTheme:
                                                    Theme.of(context)
                                                        .inputDecorationTheme
                                                        .copyWith(
                                                          filled: true,
                                                          fillColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                        ),
                                                initialSelection:
                                                    _roleFilter.value,
                                                onSelected: (value) {
                                                  _roleFilter.value =
                                                      value ?? "";
                                                },
                                                dropdownMenuEntries: Role.values
                                                .where((r) =>
                                                    r !=
                                                    Role
                                                        .$unknown) // Exclure la valeur inconnue
                                                .map(
                                                    (role) => DropdownMenuEntry(
                                                          value: role.json!,
                                                          label: getRoleLabel(
                                                              context,
                                                              role), // Afficher la traduction
                                                        ))
                                                .toList(),
                                              )
                                            ],
                                          ),
                                        ),
                                        child: IconWithLabelButton(
                                          icon: Icons.filter_alt,
                                          active: _filtersActive.value,
                                          text: strings.value.filter,
                                          onTap: () {
                                            _filtersActive.value =
                                                !_filtersActive.value;
                                            _filtersPopoverController.toggle();
                                          },
                                        ),
                                      ),
                                    ),
                                    // sort button
                                    SizedBox(
                                      width: AppSizes.xl * 4,
                                      child: ShadPopover(
                                        controller: _sortPopoverController,
                                        decoration: ShadDecoration(
                                          border: ShadBorder.none,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                        ),
                                        closeOnTapOutside: false,
                                        popover: (context) => SizedBox(
                                          width: AppSizes.xl * 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(strings.value.sort,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineMedium),
                                              SizedBox(
                                                height: AppSizes.sm,
                                              ),
                                              Text(strings.value.sortUser,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                              SizedBox(
                                                height: AppSizes.sm,
                                              ),
                                              Divider(),
                                              SizedBox(
                                                height: AppSizes.md,
                                              ),
                                              Text(strings.value.sortBy,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                              SizedBox(
                                                height: AppSizes.sm,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ShadSwitch(
                                                    uncheckedTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surfaceDim,
                                                    checkedTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    value:
                                                        _sorters["id"] ?? false,
                                                    label: Text(
                                                      "ID",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    onChanged: (value) =>
                                                        _sorters['id'] = value,
                                                  ),
                                                  ShadSwitch(
                                                    uncheckedTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surfaceDim,
                                                    checkedTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    value: _sorters["Email"] ??
                                                        false,
                                                    label: Text(
                                                      "Email",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    onChanged: (value) =>
                                                        _sorters['Email'] =
                                                            value,
                                                  ),
                                                  ShadSwitch(
                                                    uncheckedTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surfaceDim,
                                                    checkedTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    value: _sorters["Name"] ??
                                                        false,
                                                    label: Text(
                                                      "Name",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    onChanged: (value) =>
                                                        _sorters['Name'] =
                                                            value,
                                                  ),
                                                  ShadSwitch(
                                                    uncheckedTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .surfaceDim,
                                                    checkedTrackColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                    value: _sorters["Role"] ??
                                                        false,
                                                    label: Text(
                                                      "Role",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    onChanged: (value) =>
                                                        _sorters['Role'] =
                                                            value,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: IconWithLabelButton(
                                          icon: Icons.sort_rounded,
                                          active: _sortActive.value,
                                          text: strings.value.sort,
                                          onTap: () {
                                            _sortActive.value =
                                                !_sortActive.value;
                                            _sortPopoverController.toggle();
                                          },
                                        ),
                                      ),
                                    ),
                                    // PerPage TextField
                                    SizedBox(
                                      width: _expandPerPage.value
                                          ? AppSizes.xl * 8
                                          : AppSizes.xl * 3,
                                      child: Form(
                                        key: _perPageFormKey,
                                        onChanged: () {},
                                        child: TextFormField(
                                          validator: (value) =>
                                              AppValidators.perPageValidator(
                                            value,
                                            _expandPerPage,
                                          ),
                                          controller: _perPageController,
                                          onTapOutside: (_) =>
                                              _executeChangePerPageIfPossible(
                                                  context),
                                          onEditingComplete: () =>
                                              _executeChangePerPageIfPossible(
                                                  context),
                                          onChanged: (value) =>
                                              _changePerPage(context, value),
                                          decoration: InputDecoration(
                                            filled: true,
                                            labelText: strings.value.perPage,
                                            hintText: "10",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //right refresh button
                                SizedBox(
                                  width: AppSizes.xl * 4,
                                  child: IconWithLabelButton(
                                    icon: Icons.refresh_rounded,
                                    onTap: () => _loadUsers(context),
                                    text: "refresh",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

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
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DataTable2(
                              sortAscending: true,
                              onSelectAll: (selectedAll) => selectedAll == true
                                  ? _selectedUsers.addAll(usersData)
                                  : _selectedUsers.clear(),
                              showCheckboxColumn: _showCheckboxColumn.value,
                              sortColumnIndex: 0,
                              dataRowColor: WidgetStateProperty.fromMap({
                                WidgetState.hovered: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                WidgetState.focused:
                                    colorScheme.primaryContainer,
                              }),
                              columns: [
                                DataColumn2(
                                    label: Expanded(
                                        child: Text(
                                  strings.value.no,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ))),
                                DataColumn2(
                                    label: Expanded(
                                        child: Text(
                                  strings.value.avatar,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ))),
                                DataColumn2(
                                    label: Expanded(
                                        child: Text(
                                  strings.value.id,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ))),
                                DataColumn2(
                                    label: Expanded(
                                        child: Text(
                                  strings.value.email,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ))),
                                DataColumn2(
                                    label: Expanded(
                                        child: Text(
                                  strings.value.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ))),
                                DataColumn2(
                                  label: Expanded(
                                    child: Text(
                                      strings.value.role,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: _getRows(context),
                            ),
                          ),
                        ),

                        SizedBox(height: AppSizes.sm),
                        // page actions
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${strings.value.page} : $currentPage"),
                                Row(
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
                                Text("${strings.value.users}: $nbrUsersShown/$nbrTotalUsers"),
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

  void _onDeleteButtonClick(BuildContext context) {
    _showCheckboxColumn.value = !_showCheckboxColumn.value;
    final strings = getTranslations(context).obs;

    ShadToaster.of(context).show(
      ShadToast.destructive(
        closeIcon: SizedBox(),
        duration: Duration(days: 365),
        title: Text(strings.value.deleteUser),
        description: Obx(
          () {
            return _selectedUsers.isEmpty
                ? Text(strings.value.selectUserDelete)
                : Text(
                    "Are you sure you want to delete ${_selectedUsers.length} user(s)?");
                   //S.of(context).delete_users(_selectedUsers.length);
          },
        ),
        action: Obx(
          () => _selectedUsers.isEmpty
              ? ShadButton(
                  onPressed: () {
                    _selectedUsers.clear();
                    _showCheckboxColumn.value = false;
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
                      child: Text(strings.value.repFav),
                    ),
                    ShadButton(
                      onPressed: () {
                        _selectedUsers.clear();
                        _showCheckboxColumn.value = false;
                        ShadToaster.of(context).hide();
                      },
                      child: Text(strings.value.repDeFav),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _deleteUsers(BuildContext context) async {
    final api = await ApiClientInstance.getApiClient();
    for (User user in _selectedUsers) {
      api.removeUser(
        id: user.userId,
      );
    }

    _selectedUsers.clear();
    _showCheckboxColumn.value = false;
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

            return Form(
              key: _formKeyAddUser,
              child: Column(
                children: [
                  _addUserAvatarSelected.value
                      ? IconButton(
                          padding: EdgeInsets.all(AppSizes.sm),
                          onPressed: () {
                            _addUserAvatarSelected.value = false;
                            _addUserAvatarBytes = null;
                          },
                          icon: SizedBox(
                            width: AppSizes.xl * 6,
                            height: AppSizes.xl * 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.memory(
                                kIsWeb
                                    ? _addUserAvatarBytes!
                                    : _addUserAvatarFile!.readAsBytesSync(),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            Rx<FutureState> _openFilePickerToast =
                                FutureState.loading.obs;
                            final toast = Toasts.showStatefulToast(
                              context: context,
                              message: strings.value.openingFilePicher,
                              messageError: strings.value.canceled,
                              messageSuccess: strings.value.fileSelected,
                              state: _openFilePickerToast,
                            );
                            // show image picker
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );

                            if (result != null) {
                              // set image file
                              if (result.files.first.bytes != null) {
                                _addUserAvatarBytes = result.files.first.bytes!;
                                _addUserAvatarSelected.value = true;
                                _addUserAvatarBytesFileName =
                                    result.files.first.name;
                              } else if (!kIsWeb) {
                                _addUserAvatarFile =
                                    File(result.files.first.path!);
                                _addUserAvatarSelected.value = true;
                              }
                              _openFilePickerToast.value = FutureState.success;
                              Future.delayed(Duration(seconds: 1),
                                  () => Toastification().dismissById(toast.id));

                              // close toast after delay
                            } else {
                              // User canceled the picker
                              _openFilePickerToast.value = FutureState.error;
                              // close toast after delay
                              Future.delayed(Duration(seconds: 1),
                                  () => Toastification().dismissById(toast.id));
                            }
                          },
                          child: _addUserPlaceHolderAvatar.value,
                        ),
                  SizedBox(height: AppSizes.sm),
                  // email
                  ShadInputFormField(
                    controller: _addUserEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.email(),
                    label: Text(strings.value.email),
                    placeholder: Text(strings.value.emailExemple),
                  ),
                  SizedBox(height: AppSizes.sm),
                  // password
                  ShadInputFormField(
                    controller: _addUserPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (v) => AppValidators.customPasswordValidator(v),
                    obscureText: true,
                    label: Text(strings.value.password),
                    placeholder: Text("********"),
                  ),
                  SizedBox(height: AppSizes.sm),
                  // name
                  ShadInputFormField(
                    controller: _addUserNameController,
                    keyboardType: TextInputType.name,
                    label: Text(strings.value.name),
                    placeholder: Text("Lyes Rabhi"),
                  ),
                  SizedBox(height: AppSizes.sm),
                  // role
                  Container(
                    constraints: BoxConstraints(
                      minWidth: context.width,
                    ),
                    child: ShadSelectFormField<Role>(
                      initialValue: _addUserRole.value,
                      enabled: userController.user?.role != Role.supervisor,
                      validator: (v) =>
                          AppValidators.roleSelectionValidator(v?.name),
                      options: _getRoleOptions(context),
                      label: Text(strings.value.role),
                      selectedOptionBuilder: (context, value) => Container(
                        constraints: BoxConstraints(
                          minWidth: context.width,
                        ),
                        child: Text("${strings.value.role}: ${value.name.toUpperCase()}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.getRoleColor(
                                      _addUserRole.value),
                                )),
                      ),
                      placeholder: Text(strings.value.role),
                      shrinkWrap: false,
                      onChanged: (value) {
                        if (value != null) _addUserRole.value = value;
                        _loadSuperiorsOptions(context);
                      },
                    ),
                  ),
                  SizedBox(height: AppSizes.sm),
                  // phone number
                  ShadInputFormField(
                    controller: _addUserPhoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) => AppValidators.phoneNumberValidator(v),
                    label: Text(strings.value.phoneNumber),
                    placeholder: Text("0549267381"),
                  ),

                  SizedBox(height: AppSizes.sm),
                  // superior
                  Container(
                    constraints: BoxConstraints(
                      minWidth: context.width,
                    ),
                    child: ShadSelectFormField<User>.withSearch(
                      label: Text(strings.value.superior),
                      validator: (value) =>
                          AppValidators.superiorSelectionValidator(
                        value?.id,
                        _addUserSuperiorOptions.map((o) => o.value).toList(),
                      ),
                      allowDeselection: true,
                      options: _searchAddUserSuperior.value
                          ? _searchAddUserSuperiorOptions
                          : _addUserSuperiorOptions,
                      placeholder: Container(
                          constraints: BoxConstraints(
                            minWidth: context.width,
                          ),
                          child: Text(strings.value.selectSuperior))),
                      anchor: ShadAnchorAuto(
                        preferBelow: false,
                      ),
                      onChanged: (value) {
                        print("value: $value");
                        _addUserSuperior = value;
                      },
                      selectedOptionBuilder: (context, value) => Container(
                        constraints: BoxConstraints(
                          minWidth: context.width,
                        ),
                        child: Text(
                            "${strings.value.superior}: ${value.role.name.toUpperCase()} ${value.name ?? value.email}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.getRoleColor(Role.values
                                      .firstWhere((r) =>
                                          r.name.toUpperCase() ==
                                          value.role.name.toUpperCase())),
                                )),
                      ),
                      onSearchChanged: (value) {
                        if (value.isNotEmpty) {
                          _searchAddUserSuperior.value =
                              false; // turn it off to trigger update later
                          _searchAddUserSuperiorOptions.clear();
                          _searchAddUserSuperiorOptions
                              .addAll(_addUserSuperiorOptions.where((o) {
                            if (o.value.name != null) {
                              if (o.value.name!.contains(value)) {
                                return true;
                              }
                            }
                            return o.value.email.contains(value);
                          }));
                          _searchAddUserSuperior.value =
                              true; // turning it back on to trigger update
                        } else {
                          _searchAddUserSuperior.value = false;
                          _searchAddUserSuperiorOptions.clear();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: AppSizes.md),
                ],
              ),
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
          ).optionalWhen(isAtMostSmallScreen(context)),
          DataCell(
            Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.sm),
                child: Avatar(user: user),
              ),
            ),
          ).optionalWhen(isAtMostSmallScreen(context)),
          DataCell(
            Text(
              "${user.userId}",
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ).optionalWhen(isAtMostMediumScreen(context)),
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
              user.username ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ).optionalWhen(isAtMostMediumScreen(context)),
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
                  ).optionalWhen(isAtMostMediumScreen(context)),
                  IconButton(
                    onPressed: () {
                      _showEditUserDialog(context, user);
                    },
                    icon: Icon(Icons.edit),
                  ).optionalWhen(isAtMostSmallScreen(context)),
                  IconButton(
                    onPressed: () {
                      _selectedUsers.add(user);
                      _onDeleteButtonClick(context);
                    },
                    icon: Icon(Icons.delete),
                  ).optionalWhen(isAtMostMediumScreen(context)),
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
                            text: "edit",
                          ).optionalWhen(isAtLeastMediumScreen(context)),
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
                  ).optionalWhen(isAtLeastLargeScreen(context)),
                ].nonNulls.toList(),
              ),
            ),
          ),
        ].nonNulls.toList(),
        selected: _selectedUsers.contains(user),
        onSelectChanged: (value) {
          if (_selectedUsers.contains(user)) {
            print("unselected ${user.userId}: $value");
            _selectedUsers.remove(user);
          } else {
            print("selected ${user.userId}: $value");
            _selectedUsers.add(user);
          }
        },
      );
    }).toList();
  }

  void _loadSuperiorsOptions(BuildContext context) async {
    //! todo: translate (Me)
    final _me = "${userController.user!.name ?? ""}(Me)";
    List<ShadOption<User>> options = [];

    if (userController.user?.role == Role.supervisor) {
      // can only add operators assigned to himself
      _addUserSuperiorOptions.value = [
        ShadOption(value: userController.user!, child: Text(_me))
      ];
      _loadedAddUserSuperiorOptions.value = true;
      return;
    }
    if (userController.user?.role == Role.admin) {
      // can add operators assigned to his supervisors subordinates
      // can add operators assigned to himself
      if (_addUserRole.value.name == Role.operateur.name) {
        try {
          _loadedAddUserSuperiorOptions.value = false;
          final api = await ApiClientInstance.getApiClient();
          final res = await api.getUser(id: userController.user!.id);
          userController.user = res.user;
          userController.user!.subordinates?.forEach((s) {
            if (s.subordinate == null) {
              logger.e("subordinate value is null, from api response");
              return;
            }
            if (s.subordinate!.role != Role.supervisor) {
              return;
            }

            options.add(
              ShadOption(
                value: s.subordinate!,
                child: Text(s.subordinate!.name ?? s.subordinate!.email),
              ),
            );
          });
          options
              .add(ShadOption(value: userController.user!, child: Text(_me)));
          _addUserSuperiorOptions.value = options;
          _loadedAddUserSuperiorOptions.value = true;
          return;
        } catch (e) {
          logger.e("failed to get subordinates: $e");
          Toasts.showErrorToastNotification(
              context: context,
              message: "Failed to get subordinates",
              title: "Error: Failed to get subordinates");
          _addUserSuperiorOptions.value = [];
          _loadedAddUserSuperiorOptions.value = true;
          return;
        }
      }

      // can add supervisors assigned to himself
      if (_addUserRole.value.name == Role.supervisor.name) {
        options.add(ShadOption(value: userController.user!, child: Text(_me)));
        _addUserSuperiorOptions.value = options;
        _loadedAddUserSuperiorOptions.value = true;
        return;
      }
    }

    // can add any kind of user
    try {
      final api = await ApiClientInstance.getApiClient();
      final res = await api.getUsers(enablePagination: false);
      _addUserSuperiorOptions.value = res.users
          .map(
            (u) => ShadOption(
              value: u,
              child: Text(u.name ?? u.email),
            ),
          )
          .toList();
      _loadedAddUserSuperiorOptions.value = true;
      return;
    } catch (e) {
      logger.e("failed to get users: $e");
      Toasts.showErrorToastNotification(
          context: context,
          message: "Failed to get users",
          title: "Error: Failed to get users");
      _addUserSuperiorOptions.value = [];
      _loadedAddUserSuperiorOptions.value = true;
      return;
    }
  }

  void _executeChangePerPageIfPossible(BuildContext context) {
    if (_perPageFormKey.currentState != null &&
        _perPageFormKey.currentState!.validate()) {
      _loadUsers(context);
    }
  }

  void _changePerPage(BuildContext context, String value) {
    if (value.isEmpty) {
      _perPageController.text = "${perPage?.value}";
    }
    int? newPerPage = int.tryParse(value);

    if (newPerPage != null) {
      perPage?.value = newPerPage;
      LocalStorage.setPerPage(newPerPage);
    }
  }

  Future _showEditUserDialog(BuildContext context, User user) async {
    _loadSuperiorsOptions(context);
    logger.d("showing edit dialog");
    User newUser = User(
      url: user.url,
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
    Uint8List? _editUserAvatarBytes;
    File? _editUserAvatarFile;
    String? _password;
    logger.d("showing edit dialog 2");
    final loadedUserDetails = false.obs;
    User? userDetails;
    final Rx<bool> _loadedRoles = false.obs;
    final RxList<Role> _roles = <Role>[].obs;
    ApiClientInstance.getApiClient().then((api) async {
      _roles.clear();
      _roles.addAll((await api.getRoles()).data);
      _loadedRoles.value = true;
      final res = await api.getUser(id: user.userId);
      userDetails = res;
      loadedUserDetails.value = true;
      logger.d("user details fetched");
    }).catchError((e) {
      logger.e("failed to get user details: $e");
      Toasts.showErrorToastNotification(
          context: context,
          message: "Details: ${e.toString()}",
          title: "Error: Failed to get user details");
      loadedUserDetails.value = true;
    });

    return showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: Text("User: ${user.username ?? user.email}"),
        description: Text("Edit User"),
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
                            child: Text("Delete"),
                            onPressed: () {
                              _selectedUsers.add(userDetails!);
                              _onDeleteButtonClick(
                                context,
                                onDeleteConfirmed: () =>
                                    Navigator.of(context).pop(),
                              );
                            },
                          ),
                          ShadButton(
                            icon: Icon(Icons.edit),
                            child: Text("Save"),
                            onPressed: () {
                              onSaveButtonPressed(
                                context: context,
                                user: newUser,
                                password:
                                    _password != null && _password!.isNotEmpty
                                        ? _password
                                        : null,
                                userAvatarBytes: _editUserAvatarBytes,
                                userAvatarFile: _editUserAvatarFile,
                              );
                            },
                          ),
                        ],
                      ),
                    ShadButton(
                      icon: Icon(Icons.close),
                      child: Text("Close"),
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
                !_loadedRoles.value ||
                !_loadedAddUserSuperiorOptions.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final role = _roles.firstWhereOrNull((r) => r.name == user.role);
            return UserForm(
              editable: true,
              showPlaceHolders: false,
              role: role,
              user: user,
              onAddUser: (email, username, password, phone, role, superior,
                      firstName, lastName, avatarBytes, avatarFile) =>
                  {
                _editUserAvatarBytes = avatarBytes,
                _editUserAvatarFile = avatarFile,
                _password = password,
                newUser = User(
                  url: newUser.url,
                  userId: newUser.userId,
                  email: email,
                  username: username,
                  phoneNumber: phone,
                  role: role.name,
                  superiors: superior != null
                      ? [
                          UserSerializerWithSuperiors(
                              url: superior.url,
                              userId: superior.userId,
                              email: superior.email,
                              username: superior.username,
                              superiors: superior.superiors)
                        ]
                      : [],
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
              formKeyAddUser: _formKeyAddUser,
              addUserSuperiorOptions: _addUserSuperiorOptions,
              loadSuperiorsOptions: _loadSuperiorsOptions,
            );
          },
        ),
      ),
    );
  }

  Future _showViewUserDialog(BuildContext context, User user) async {
    final loadedUserDetails = false.obs;
    User? userDetails;
    final Rx<bool> _loadedRoles = false.obs;
    final RxList<Role> _roles = <Role>[].obs;
    ApiClientInstance.getApiClient().then((api) async {
      _roles.clear();
      _roles.addAll((await api.getRoles()).data);
      _loadedRoles.value = false;
      final res = await api.getUser(id: user.userId);
      userDetails = res;
      loadedUserDetails.value = true;
      logger.d("user details fetched");
    }).catchError((e) {
      logger.e("failed to get user details: $e");
      Toasts.showErrorToastNotification(
          context: context,
          message: "Details: ${e.toString()}",
          title: "Error: Failed to get user details");
      loadedUserDetails.value = true;
    });

    return showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: Text("User: ${user.username ?? user.email}"),
        description: Text("View User Details"),
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
                            child: Text("Delete"),
                            onPressed: () {
                              _selectedUsers.add(userDetails!);
                              _onDeleteButtonClick(
                                context,
                                onDeleteConfirmed: () =>
                                    Navigator.of(context).pop(),
                              );
                            },
                          ),
                          ShadButton(
                            icon: Icon(Icons.edit),
                            child: Text("Edit"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _showEditUserDialog(context, user);
                            },
                          ),
                        ],
                      ),
                    ShadButton(
                      icon: Icon(Icons.close),
                      child: Text("Close"),
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
            if (!loadedUserDetails.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final role = _roles.firstWhereOrNull((r) => r.name == user.role);
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
                  TextEditingController(text: "Hashed Value"),
              addUserPhoneController:
                  TextEditingController(text: userDetails!.phoneNumber),
              formKeyAddUser: GlobalKey<FormState>(),
              addUserSuperiorOptions: <ShadOption<User>>[].obs,
              loadSuperiorsOptions: (context) =>
                  _loadSuperiors(context, userDetails!),
            );
          },
        ),
      ),
    );
  }

  void _onAddUserPressed(BuildContext context) async {
    if (!_formKeyAddUser.currentState!.validate()) {
      Toasts.showErrorToastNotification(
          context: context, message: "¨Please fix the errors in the form");
      return;
    }

    Rx<FutureState> loadingToastState = FutureState.loading.obs;
    // show loading toast
    final toast = Toasts.showStatefulToast(
      context: context,
      message: "Adding user...",
      messageError: "Failed to add user",
      messageSuccess: "User Added Successfully",
      state: loadingToastState,
    );
    // add user request
    try {
      final api = await ApiClientInstance.getApiClient();
      logger.e("addUserRole: ${_addUserRole!.name}");
      late final User res;
      if (kIsWeb) {
        res = await api.addUsersOnWeb(
          avatar: _addUserAvatarBytes,
          avatarFileName: _addUserAvatarBytesFileName,
          email: _addUserEmailController.text,
          password: _addUserPasswordController.text,
          role: _addUserRole!.name,
          phoneNumber: _addUserPhoneController.text,
          username: _addUserNameController.text,
          firstName: _addFirstNameController.text,
          lastName: _addLastNameController.text,
        );
      } else {
        res = await api.addUser(
          avatar: _addUserAvatarFile,
          email: _addUserEmailController.text,
          password: _addUserPasswordController.text,
          role: _addUserRole!.name,
          phoneNumber: _addUserPhoneController.text,
          username: _addUserNameController.text,
        );
      }

      if (_addUserSuperior != null) {
        await api.addSubordinateAndSuperior(
            superior: _addUserSuperior!.userId, subordinate: res.userId);
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
    if (!_formKeyAddUser.currentState!.validate()) {
      Toasts.showErrorToastNotification(
          context: context, message: "¨Please fix the errors in the form");
      return;
    }

    Rx<FutureState> loadingToastState = FutureState.loading.obs;
    // show loading toast
    final toast = Toasts.showStatefulToast(
      context: context,
      message: "Saving user...",
      messageError: "Failed to save user",
      messageSuccess: "User Saved Successfully",
      state: loadingToastState,
    );
    // add user request
    try {
      final api = await ApiClientInstance.getApiClient();
      //logger.e("addUserRole: ${_addUserRole!.name}");
      logger.e(
          "avatar: ${userAvatarBytes != null} $_addUserAvatarBytesFileName ${userAvatarFile != null}");
      late final User res;
      if (kIsWeb) {
        res = await api.partialUpdateUserOnWeb(
          id: user.userId,
          avatar: userAvatarBytes,
          avatarFileName: _addUserAvatarBytesFileName ?? "avatar.jpg",
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

      if (_addUserSuperior != null) {
        await api.addSubordinateAndSuperior(
            superior: _addUserSuperior!.userId, subordinate: res.userId);
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

  _getColumnSpacing(BuildContext context) {
    return isSmallScreen(context) ? AppSizes.sm : AppSizes.md;
  }
}

class Sorter {
  final bool isSelected;
  final String ordering_value;

  Sorter({required this.isSelected, required this.ordering_value});
}

extension WidgetOptionalWhen on Widget {
  Widget? optionalWhen(bool condition) {
    return condition ? null : this;
  }
}

extension DataColumnOptionalWhen on DataColumn2 {
  DataColumn2? optionalWhen(bool condition) {
    return condition ? null : this;
  }
}

extension DataCellOptionalWhen on DataCell {
  DataCell? optionalWhen(bool condition) {
    return condition ? null : this;
  }
}
