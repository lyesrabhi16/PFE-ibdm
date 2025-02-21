import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/local_storage.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/page_index.dart';
import 'package:ibdm/utils/helpers/validators/app_validators.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_io/io.dart';
import 'package:ibdm/generated/l10n.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/common/widgets/responsive_appbar.dart';
import 'package:ibdm/utils/constants/routes.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  static final UserController userController = Get.find();

  final Rx<bool> _loaded = false.obs;
  final Rx<bool> _loadedAddUserSuperiorOptions = false.obs;
  final RxList<ShadOption<User>> _addUserSuperiorOptions =
      <ShadOption<User>>[].obs;

  final RxMap<String, bool> _hovered = <String, bool>{}.obs;

  static Rx<int>? perPage = 10.obs;
  static final _perPageController = TextEditingController(
    text: "${perPage?.value}",
  );
  static final Rx<bool> _expandPerPage = false.obs;
  static final _perPageFormKey = GlobalKey<FormState>();

  static final Rx<bool> _filtersActive = false.obs;
  static final _filtersPopoverController = ShadPopoverController();
  static final Rx<String> _roleFilter = "".obs;

  static final Rx<bool> _sortActive = false.obs;
  static final _sortPopoverController = ShadPopoverController();
  final RxMap<String, bool> _sorters = {
    "id": false,
    "email": false,
    "name": false,
    "role": false,
  }.obs;

  int? nbrTotalUsers;
  int? nbrUsersShown;
  int? nbrTotalPages;
  int? currentPage;
  List<User> usersData = [];

  static final RxList<PageIndex> searchedPageIndexes = <PageIndex>[].obs;

  // add user form
  static final _formKeyAddUser = GlobalKey<FormState>();
  static final _addUserEmailController = TextEditingController();
  static final _addUserNameController = TextEditingController();
  static final _addUserPasswordController = TextEditingController();
  static final _addUserPhoneController = TextEditingController();
  static final _addUserRole = _getInitialRoleValue().obs;
  static User? _addUserSuperior;
  static final _searchAddUserSuperior = false.obs;
  static final _searchAddUserSuperiorOptions = <ShadOption<User>>[].obs;
  static final Rx<Icon> _addUserPlaceHolderAvatar = Icon(
    LucideIcons.circleUserRound,
    size: AppSizes.xl * 3,
  ).obs;
  static final Rx<bool> _addUserAvatarSelected = false.obs;
  static File? _addUserAvatarFile; // use on non-web
  static Uint8List? _addUserAvatarBytes; // use on web
  static String? _addUserAvatarBytesFileName; // use on web

  static final Rx<bool> _showCheckboxColumn = false.obs;

  static final RxSet<User> _selectedUsers = <User>{}.obs;

  void _loadUsers(
    BuildContext context, {
    int page = 1,
  }) {
    // mark as not loaded
    _loaded.value = false;
    ApiClientInstance.getApiClient().then((apiClient) async {
      // use stored perPage if it exists
      int? perPageInStorage = await LocalStorage.getPerPage();
      if (perPageInStorage != null && perPageInStorage != perPage?.value) {
        perPage?.value = perPageInStorage;
      }
      print("perPage?.value: ${perPage?.value}");
      // get data from api
      GetUsersResponse res = await apiClient.getUsers(
        perPage: perPage?.value,
        page: page,
      );

      // set data
      usersData = res.users;
      nbrTotalPages = res.nbrTotalPages!;
      nbrUsersShown = usersData.length;
      nbrTotalUsers = res.nbrTotalUsers;
      currentPage = res.currentPage!;
      perPage = res.perPage!.obs;

      // mark as loaded
      _loaded.value = true;
    }).catchError((err) {
      _loaded.value = true;
      if (err is DioException) {
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
    });
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

  @override
  Widget build(BuildContext context) {
    _loadUsers(context);

    final colorScheme = Theme.of(context).colorScheme;
    final strings = getTranslations(context).obs;
    String getRoleLabel(BuildContext context, Role r) {
      final strings = getTranslations(context); 
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

    return Scaffold(
      appBar: ResponsiveAppBar(
        userName: userController.user?.name ?? "No Name",
        userImage: (userController.user?.avatarUrl != null &&
                userController.user!.avatarUrl!.isNotEmpty)
            ? userController.user!.avatarUrl!
            : '',
        onLogout: () {
          userController.logoutUser();
          Get.offAllNamed(Routes.login);
        },
      ),
      body: Obx(
        () {
          List<Widget> pageIndexesButtons = [];
          if (_loaded.value && usersData.isNotEmpty) {
            final indexes = _getIndexesOfPages(currentPage!, nbrTotalPages!);
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
                            "$v",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        anchor: ShadAnchorAuto(preferBelow: false),
                        options: [
                          ...searchedPageIndexes.map((pi) => pi.button)
                        ],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SearchBar(
                                    onChanged: (value) async {
                                      final api = await ApiClientInstance
                                          .getApiClient();
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
                                          hoverBackgroundColor: colorScheme
                                              .surfaceContainerHighest,
                                          foregroundColor:
                                              colorScheme.onSurface,
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
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                                vertical: AppSizes.sm,
                              ),
                              child: Row(
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
                                                _roleFilter.value = value ?? "";
                                              },
                                              dropdownMenuEntries: Role.values
                                                  .where((r) =>
                                                      r !=
                                                      Role
                                                          .$unknown) // Exclure la valeur inconnue
                                                  .map((role) =>
                                                      DropdownMenuEntry(
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
                                                    strings.value.id,
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
                                                    strings.value.email,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  onChanged: (value) =>
                                                      _sorters['Email'] = value,
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
                                                  value:
                                                      _sorters["Name"] ?? false,
                                                  label: Text(
                                                    strings.value.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  onChanged: (value) =>
                                                      _sorters['Name'] = value,
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
                                                  value:
                                                      _sorters["Role"] ?? false,
                                                  label: Text(
                                                    strings.value.role,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  onChanged: (value) =>
                                                      _sorters['Role'] = value,
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
                                onSelectAll: (selectedAll) =>
                                    selectedAll == true
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Text(
                                      "${strings.value.users}: $nbrUsersShown/$nbrTotalUsers"),
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
      ),
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
    api.deleteUsers(
      userIds: _selectedUsers.map((u) => u.id).toList(),
    );
    _selectedUsers.clear();
    _showCheckboxColumn.value = false;
    ShadToaster.of(context).hide();
  }

  Future<dynamic> _showAddUserDialog(BuildContext context) {
    _addUserRole.value = _getInitialRoleValue();
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
            onPressed: () async {
              if (!_formKeyAddUser.currentState!.validate()) {
                Toasts.showErrorToastNotification(
                    context: context,
                    message: strings.value.pleaseFixErrorsInTheForm);
                return;
              }

              Rx<FutureState> loadingToastState = FutureState.loading.obs;
              // show loading toast
              final toast = Toasts.showStatefulToast(
                context: context,
                message: strings.value.addUserMessage,
                messageError: strings.value.failedToAddUserMessage,
                messageSuccess: strings.value.successAddUserMessage,
                state: loadingToastState,
              );
              // add user request
              try {
                final api = await ApiClientInstance.getApiClient();
                //print("superior: ${_addUserSuperior}");
                PostApiUsersResponse res;
                if (kIsWeb) {
                  res = await api.addUsersOnWeb(
                    avatar: _addUserAvatarBytes,
                    avatarFileName: _addUserAvatarBytesFileName,
                    email: _addUserEmailController.text,
                    password: _addUserPasswordController.text,
                    role: _addUserRole.value,
                    phoneNumber: _addUserPhoneController.text,
                    name: _addUserNameController.text,
                    superiorId: _addUserSuperior?.id,
                  );
                } else {
                  res = await api.addUser(
                    avatar: _addUserAvatarFile,
                    email: _addUserEmailController.text,
                    password: _addUserPasswordController.text,
                    role: _addUserRole.value,
                    phoneNumber: _addUserPhoneController.text,
                    name: _addUserNameController.text,
                    superiorId: _addUserSuperior?.id,
                  );
                }

                // show success toast
                loadingToastState.value = FutureState.success;
                // close toast after a short duration
                Future.delayed(Duration(seconds: 1),
                    () => Toastification().dismissById(toast.id));
                // reload users list
                _loadUsers(context);
              } catch (e) {
                logger.e("failed to add user: $e");
                // show error toast
                loadingToastState.value = FutureState.error;
                // close toast after a duration
                Future.delayed(Duration(seconds: 3),
                    () => Toastification().dismissById(toast.id));
              }
            },
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
                            Rx<FutureState> openFilePickerToast =
                                FutureState.loading.obs;
                            final toast = Toasts.showStatefulToast(
                              context: context,
                              message: strings.value.openingFilePicher,
                              messageError: strings.value.canceled,
                              messageSuccess: strings.value.fileSelected,
                              state: openFilePickerToast,
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
                              openFilePickerToast.value = FutureState.success;
                              Future.delayed(Duration(seconds: 1),
                                  () => Toastification().dismissById(toast.id));

                              // close toast after delay
                            } else {
                              // User canceled the picker
                              openFilePickerToast.value = FutureState.error;
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
                        child: Text(
                            "${strings.value.role}: ${value.name.toUpperCase()}",
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
                          child: Text(strings.value.selectSuperior)),
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

  static Role _getInitialRoleValue() {
    switch (userController.user?.role) {
      case Role.adminSystem:
        return Role.admin;
      case Role.admin:
        return Role.supervisor;
      case Role.supervisor:
        return Role.operateur;
      default:
        return Role.operateur;
    }
  }

  Iterable<Widget> _getRoleOptions(BuildContext context) {
    List<Role> roles = [];
    switch (userController.user?.role) {
      case Role.adminSystem:
        roles = Role.values.toList();
        break;
      case Role.admin:
        roles = [Role.supervisor, Role.operateur];
        break;
      case Role.supervisor:
        roles = [Role.operateur];
        break;
      default:
        roles = [];
        break;
    }
    return roles.map((role) => ShadOption(
          value: role,
          child: Text(
            role.name.toUpperCase(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.getRoleColor(role),
                ),
          ),
        ));
  }

  WidgetStateProperty<Color>? _getRowColor(BuildContext context, User user) {
    return WidgetStateProperty.resolveWith((s) {
      if (s.any((s) => [
            WidgetState.hovered,
            WidgetState.selected,
            WidgetState.focused
          ].contains(s))) {
        return AppColors.getRoleColor(user.role);
      } else {
        return Colors.transparent;
      }
    });
  }

  List<DataRow> _getRows(BuildContext context) {
    return usersData.map((user) {
      if (_hovered[user.id] == null) {
        _hovered[user.id] = false;
      }

      return DataRow2(
        color: _getRowColor(context, user),
        cells: [
          DataCell(
            Text(
              (usersData.indexOf(user) + 1).toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsets.all(AppSizes.sm),
              child: ShadAvatar(
                Icons.person_sharp,
                size: Size(
                  AppSizes.xl * 2,
                  AppSizes.xl * 5,
                ),
                fit: BoxFit.cover,
                backgroundColor: AppColors.getRoleColor(user.role),
              ),
            ),
          ),
          DataCell(
            Text(
              user.id,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            Text(
              user.name ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          DataCell(
            MouseRegion(
              onEnter: (p) => _hovered[user.id] = true,
              onExit: (p) => _hovered[user.id] = false,
              child: Text(
                user.role.name.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _hovered[user.id] == true
                          ? null
                          : AppColors.getRoleColor(user.role),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          DataCell(
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _showViewUserDialog(context, user);
                  },
                  icon: Icon(Icons.remove_red_eye_rounded),
                ),
                IconButton(
                  onPressed: () {
                    _showEditUserDialog(context, user);
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _selectedUsers.add(user);
                    _onDeleteButtonClick(context);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ],
        selected: _selectedUsers.contains(user),
        onSelectChanged: (value) {
          if (_selectedUsers.contains(user)) {
            print("unselected ${user.id}: $value");
            _selectedUsers.remove(user);
          } else {
            print("selected ${user.id}: $value");
            _selectedUsers.add(user);
          }
        },
      );
    }).toList();
  }

  void _loadSuperiorsOptions(BuildContext context) async {
    final me = "${userController.user!.name ?? ""}(Me)";
    List<ShadOption<User>> options = [];

    if (userController.user?.role == Role.supervisor) {
      // can only add operators assigned to himself
      _addUserSuperiorOptions.value = [
        ShadOption(value: userController.user!, child: Text(me))
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
          options.add(ShadOption(value: userController.user!, child: Text(me)));
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
        options.add(ShadOption(value: userController.user!, child: Text(me)));
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

  void _showEditUserDialog(BuildContext context, User user) {}

  void _showViewUserDialog(BuildContext context, User user) {}
}

extension DataRowExtention on DataRow {
  Widget withMouseRegion({
    required void Function(PointerEnterEvent) onEnter,
    required void Function(PointerExitEvent) onExit,
    void Function(PointerHoverEvent)? onHover,
  }) {
    return MouseRegion(
      onEnter: (p) => onEnter(p),
      onExit: (p1) => onExit(p1),
      child: this as Widget,
    );
  }
}
