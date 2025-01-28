import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  Rx<bool> _loaded = false.obs;

  final RxMap<String, bool> _sorters = {
    "id": false,
    "email": false,
    "name": false,
    "role": false,
  }.obs;

  final RxMap<String, bool> _hovered = new Map<String, bool>().obs;

  @override
  Widget build(BuildContext context) {
    List<User> usersData = [];
    _loaded.value = false;

    int nbrTotalUsers = 20;
    int nbrUsersShown = usersData.length;
    int nbrTotalPages = 2;
    int currentPage = 1;

    ApiClientInstance.getApiClient().then((apiClient) async {
      GetApiUsersResponse res = await apiClient.getUsers();
      usersData = res.users;
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

    return Obx(
      () {
        return AppCustomContainer(
          child: Center(
            child: Padding(
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
                            constraints: BoxConstraints(
                              maxWidth: AppSizes.lg * 8,
                              minHeight: AppSizes.lg * 1.5,
                              maxHeight: AppSizes.lg * 1.5,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.surfaceContainer),
                            elevation: WidgetStatePropertyAll(0),
                            leading: Icon(Icons.search),
                            hintText: "Search...",
                          ),
                          Row(
                            children: [
                              ShadButton(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerLow,
                                  hoverBackgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  onPressed: () {},
                                  child: Text("Add User")),
                              ShadButton.destructive(
                                  onPressed: () {}, child: Text("Delete")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.sm),
                  ShadAccordion<String>(
                    children: [
                      ShadAccordionItem(
                        titleStyle: Theme.of(context).textTheme.titleMedium,
                        value: "Filter",
                        title: Text("Filters"),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(AppSizes.sm),
                              child: Row(
                                children: [
                                  DropdownMenu(
                                    hintText: "Role",
                                    label: Text("Role"),
                                    inputDecorationTheme: Theme.of(context)
                                        .inputDecorationTheme
                                        .copyWith(
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  ShadAccordion<String>(
                    children: [
                      ShadAccordionItem(
                          titleStyle: Theme.of(context).textTheme.titleMedium,
                          value: "SortBy",
                          title: Text("Sort By"),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShadSwitch(
                                uncheckedTrackColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                checkedTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                value: _sorters["id"] ?? false,
                                label: Text(
                                  "ID",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onChanged: (value) => _sorters['id'] = value,
                              ),
                              ShadSwitch(
                                uncheckedTrackColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                checkedTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                value: _sorters["Email"] ?? false,
                                label: Text(
                                  "Email",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onChanged: (value) => _sorters['Email'] = value,
                              ),
                              ShadSwitch(
                                uncheckedTrackColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                checkedTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                value: _sorters["Name"] ?? false,
                                label: Text(
                                  "Name",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onChanged: (value) => _sorters['Name'] = value,
                              ),
                              ShadSwitch(
                                uncheckedTrackColor:
                                    Theme.of(context).colorScheme.surfaceDim,
                                checkedTrackColor:
                                    Theme.of(context).colorScheme.primary,
                                value: _sorters["Role"] ?? false,
                                label: Text(
                                  "Role",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onChanged: (value) => _sorters['Role'] = value,
                              ),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(height: AppSizes.sm),

                  _loaded.value
                      ?
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
                            child: DataTable(
                              columns: [
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
                              rows: usersData.map((user) {
                                if (_hovered[user.id] == null) {
                                  _hovered[user.id] = false;
                                }

                                return DataRow(
                                    color: _hovered[user.id] ?? false
                                        ? WidgetStatePropertyAll(
                                            Theme.of(context)
                                                .colorScheme
                                                .primaryContainer)
                                        : null,
                                    cells: [
                                      DataCell(
                                        MouseRegion(
                                          onHover: (_) => {
                                            _hovered[user.id] = true,
                                          },
                                          onExit: (_) {
                                            _hovered[user.id] = false;
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.all(AppSizes.sm),
                                            child: ShadAvatar(
                                              Icons.person_sharp,
                                              size: Size(
                                                AppSizes.xl * 2,
                                                AppSizes.xl * 5,
                                              ),
                                              fit: BoxFit.cover,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        MouseRegion(
                                          onHover: (_) => {
                                            _hovered[user.id] = true,
                                          },
                                          onExit: (_) {
                                            _hovered[user.id] = false;
                                          },
                                          child: Text(
                                            user.id,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        MouseRegion(
                                          onHover: (_) => {
                                            _hovered[user.id] = true,
                                          },
                                          onExit: (_) {
                                            _hovered[user.id] = false;
                                          },
                                          child: Text(
                                            user.email,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        MouseRegion(
                                          onHover: (_) => {
                                            _hovered[user.id] = true,
                                          },
                                          onExit: (_) {
                                            _hovered[user.id] = false;
                                          },
                                          child: Text(
                                            user.name ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        MouseRegion(
                                          onHover: (_) => {
                                            _hovered[user.id] = true,
                                          },
                                          onExit: (_) {
                                            _hovered[user.id] = false;
                                          },
                                          child: Text(
                                            user.role,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ]);
                              }).toList(),
                            ),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                  SizedBox(height: AppSizes.sm),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
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
                                child: Text("Prev"),
                              ),
                              ShadButton(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Text("$currentPage"),
                              ),
                              ShadButton(
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
            ),
          ),
        );
      },
    );
  }
}
