import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
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
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final Rx<bool> _triggerUpdateVar = false.obs;
  void _triggerUpdate() => _triggerUpdateVar.value = !_triggerUpdateVar.value;

  final Rx<bool> _loaded = false.obs;

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
      nbrTotalPages = res.nbrTotalPages;
      nbrUsersShown = usersData.length;
      nbrTotalUsers = res.nbrTotalUsers;
      currentPage = res.currentPage;
      perPage = res.perPage.obs;

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

    return Obx(
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
                return Obx(
                  () => ConstrainedBox(
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
                      options: [...searchedPageIndexes.map((pi) => pi.button)],
                      searchPlaceholder: Text("Search..."),
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
                  ),
                );
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
                          child: Text("User Management",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        SizedBox(height: AppSizes.xl),
                        //TODO: add actions
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
                                  hintText: "Search...",
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
                                        child: Text("Add User")),
                                    ShadButton.destructive(
                                        onPressed: () {
                                          _showCheckboxColumn.value =
                                              !_showCheckboxColumn.value;

                                          ShadToaster.of(context)
                                              .show(ShadToast.destructive(
                                            closeIcon: SizedBox(),
                                            duration: Duration(days: 365),
                                            title: Text("Delete Users"),
                                            description: Obx(
                                              () {
                                                return _selectedUsers.isEmpty
                                                    ? Text(
                                                        "Select users to delete")
                                                    : Text(
                                                        "Are you sure you want to delete ${_selectedUsers.length} user(s)?");
                                              },
                                            ),
                                            action: Obx(
                                              () => _selectedUsers.isEmpty
                                                  ? ShadButton(
                                                      onPressed: () {
                                                        _selectedUsers.clear();
                                                        _showCheckboxColumn
                                                            .value = false;
                                                        ShadToaster.of(context)
                                                            .hide();
                                                      },
                                                      child: Text("Cancel"),
                                                    )
                                                  : Row(
                                                      children: [
                                                        ShadButton(
                                                          onPressed: () async {
                                                            await _deleteUsers(
                                                                context);
                                                          },
                                                          child: Text("Yes"),
                                                        ),
                                                        ShadButton(
                                                          onPressed: () {
                                                            _selectedUsers
                                                                .clear();
                                                            _showCheckboxColumn
                                                                .value = false;
                                                            ShadToaster.of(
                                                                    context)
                                                                .hide();
                                                          },
                                                          child: Text("No"),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ));
                                        },
                                        enabled: !_showCheckboxColumn.value,
                                        child: Text("Delete")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: AppSizes.sm),
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
                                          Text("Filters",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium),
                                          SizedBox(
                                            height: AppSizes.sm,
                                          ),
                                          Text("Filter users",
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
                                          Text("Filter by Role",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                          SizedBox(
                                            height: AppSizes.sm,
                                          ),
                                          DropdownMenu(
                                            hintText: "Role",
                                            label: Text("Role"),
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
                                            initialSelection: _roleFilter.value,
                                            onSelected: (value) {
                                              _roleFilter.value = value ?? "";
                                            },
                                            dropdownMenuEntries: [
                                              DropdownMenuEntry(
                                                value: "USER",
                                                label: "USER",
                                              ),
                                              DropdownMenuEntry(
                                                value: "ADMIN",
                                                label: "ADMIN",
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    child: IconWithLabelButton(
                                      icon: Icons.filter_alt,
                                      active: _filtersActive.value,
                                      text: "Filter",
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
                                          Text("Sort",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium),
                                          SizedBox(
                                            height: AppSizes.sm,
                                          ),
                                          Text("Sort users",
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
                                          Text("Sort by:",
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
                                                value: _sorters["id"] ?? false,
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
                                                value:
                                                    _sorters["Email"] ?? false,
                                                label: Text(
                                                  "Email",
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
                                                  "Name",
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
                                                  "Role",
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
                                      text: "Sort",
                                      onTap: () {
                                        _sortActive.value = !_sortActive.value;
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
                                          _perPageValidator(value),
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
                                        labelText: "Per Page",
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
                            child: SingleChildScrollView(
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
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    "No",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    "Avatar",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    "ID",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    "Email",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    "Name",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ))),
                                  DataColumn(
                                      label: Expanded(
                                          child: Text(
                                    "Role",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ))),
                                ],
                                rows: _getRows(context),
                              ),
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
                                Text("Page: $currentPage"),
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
                                      child: Text("Prev"),
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
                                      child: Text("Next"),
                                    ),
                                  ],
                                ),
                                Text("Users: $nbrUsersShown/$nbrTotalUsers"),
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

  Future<void> _deleteUsers(BuildContext context) async {
    final api = await ApiClientInstance.getApiClient();
    api.deleteUsers(
        userIds: _selectedUsers.map((u) => u.id).toList() as UserIdsArray);
    _selectedUsers.clear();
    _showCheckboxColumn.value = false;
    ShadToaster.of(context).hide();
  }

  Future<dynamic> _showAddUserDialog(BuildContext context) {
    return showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: Text("Add User"),
        description: Text("Add one user"),
        actions: [
          ShadButton(
            child: Text("Add User"),
            onPressed: () async {
              Rx<FutureState> _loadingToastState = FutureState.loading.obs;
              // show loading toast
              final toast = Toasts.showStatefulToast(
                context: context,
                message: "Adding user...",
                messageError: "Failed to add user",
                messageSuccess: "User Added Successfully",
                state: _loadingToastState,
              );
              // add user request
              try {
                final api = await ApiClientInstance.getApiClient();
                final res = await api.addUser(
                  body: AddUserInput(
                    email: _addUserEmailController.text,
                    password: _addUserPasswordController.text,
                    role: Role.operateur,
                    phoneNumber: _addUserPhoneController.text,
                    name: _addUserNameController.text,
                  ),
                );
                // show success toast
                _loadingToastState.value = FutureState.success;
                // close toast after a short duration
                Future.delayed(Duration(seconds: 1),
                    () => Toastification().dismissById(toast.id));
              } catch (e) {
                logger.e("failed to add user: $e");
                // show error toast
                _loadingToastState.value = FutureState.error;
                // close toast after a duration
                Future.delayed(Duration(seconds: 3),
                    () => Toastification().dismissById(toast.id));
              }
            },
          )
        ],
        child: Form(
          key: _formKeyAddUser,
          child: Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  LucideIcons.circleUserRound,
                  size: AppSizes.xl * 3,
                ),
              ),
              // email
              ShadInputFormField(
                controller: _addUserEmailController,
                keyboardType: TextInputType.emailAddress,
                validator: FormBuilderValidators.email(),
                label: Text("Email"),
                placeholder: Text("account@exmaple.com"),
              ),
              // password
              ShadInputFormField(
                controller: _addUserPasswordController,
                keyboardType: TextInputType.visiblePassword,
                validator: FormBuilderValidators.password(),
                obscureText: true,
                label: Text("Password"),
                placeholder: Text("********"),
              ),
              // name
              ShadInputFormField(
                controller: _addUserNameController,
                keyboardType: TextInputType.name,
                label: Text("Name"),
                placeholder: Text("Lyes Rabhi"),
              ),
              // role
              // phone number
              ShadInputFormField(
                controller: _addUserPhoneController,
                keyboardType: TextInputType.phone,
                validator: FormBuilderValidators.phoneNumber(),
                label: Text("Phone number"),
                placeholder: Text("0549267381"),
              ),
            ],
          ),
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
            showEditIcon: true,
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
      ).;
    }).toList();
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

  String? _perPageValidator(String? value) {
    final String? error = IntegerValidator().validate(value);
    if (error != null) {
      _expandPerPage.value = true;
      return error;
    } else {
      _expandPerPage.value = false;
    }
    return null;
  }
}

class PageIndex {
  final int index;
  final Widget button;

  PageIndex({required this.index, required this.button});
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
