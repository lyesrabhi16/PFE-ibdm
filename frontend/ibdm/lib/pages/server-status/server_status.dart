import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/pages/users.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/common_heplers.dart';
import 'package:ibdm/utils/helpers/data_representation.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerStatusPage extends StatefulWidget {
  const ServerStatusPage({super.key});

  static WebSocketChannel? channel;
  static Stream? stream;

  @override
  State<ServerStatusPage> createState() => _ServerStatusPageState();
}

class _ServerStatusPageState extends State<ServerStatusPage> {
  Function? _getContext;
  BuildContext get getContext => _getContext!.call()!;
  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;
  ThemeData get theme => Theme.of(getContext);
  IbdmApiClient? api;
  final loaded = false.obs;
  final _loadedStatus = false.obs;
  SystemStatus? status;

  List<DataRepresentation> get systemContainerInfo {
    final strings = getTranslations(context).obs;
    return [
      DataRepresentation(
        name: strings.value.os,
        code: "os",
        source: status?.systemInfo.toJson(),
      ),
      DataRepresentation(
        name: strings.value.cpuUsage,
        code: "cpu_percent",
        source: status?.systemInfo.toJson(),
        transform: (v) {
          return "${(v as double).toStringAsFixed(2)}%";
        },
      ),
      DataRepresentation(
        name: strings.value.totalStorage,
        code: "total_storage",
        source: status?.systemInfo.toJson(),
        transform: (v) => fromBytesToHumanReadableSize(v),
      ),
      DataRepresentation(
        name: strings.value.usedStorage,
        code: "used_storage",
        source: status?.systemInfo.toJson(),
        transform: (v) => fromBytesToHumanReadableSize(v),
      ),
      DataRepresentation(
        name: strings.value.storageUsage,
        code: "disk_percent_used",
        source: status?.systemInfo.toJson(),
        transform: (v) {
          return "${(v as double).toStringAsFixed(2)}%";
        },
      ),
    ];
  }

  List<DataRepresentation> get networkContainerInfo {
    final strings = getTranslations(context).obs;
    return [
      DataRepresentation(
        name: strings.value.sent,
        code: "network_io_sent",
        source: status?.systemInfo.toJson(),
        transform: (dynamic v) {
          return fromBytesToHumanReadableSize(v);
        },
      ),
      DataRepresentation(
        name: strings.value.received,
        code: "network_io_received",
        source: status?.systemInfo.toJson(),
        transform: (dynamic v) {
          return fromBytesToHumanReadableSize(v);
        },
      ),
      for (var e in (status != null
          ? status!.systemInfo.ipAddresses.entries
          : <String, String>{}.entries))
        DataRepresentation(
          name: e.key,
          code: e.key,
          source: status!.systemInfo.ipAddresses,
        )
    ];
  }

  List<DataRepresentation> get memoryContainerInfo {
    final strings = getTranslations(context).obs;
    return [
      DataRepresentation(
        name: strings.value.totalMemory,
        code: "total_memory",
        source: status?.systemInfo.toJson(),
        transform: (dynamic v) {
          return fromBytesToHumanReadableSize(v);
        },
      ),
      DataRepresentation(
        name: strings.value.usedMemory,
        code: "used_memory",
        source: status?.systemInfo.toJson(),
        toValue: (status) {
          return status["total_memory"] - status["available_memory"];
        },
        transform: (dynamic v) {
          return fromBytesToHumanReadableSize(v);
        },
      ),
      DataRepresentation(
        name: strings.value.availableMemory,
        code: "available_memory",
        source: status?.systemInfo.toJson(),
        transform: (dynamic v) {
          return fromBytesToHumanReadableSize(v);
        },
      ),
      DataRepresentation(
        name: strings.value.memoryUsage,
        code: "memory_percent_used",
        source: status?.systemInfo.toJson(),
        transform: (dynamic v) {
          return "${v.toStringAsFixed(2)}%";
        },
      ),
    ];
  }

  List<DataRepresentation> get generalInfo {
    final strings = getTranslations(context).obs;
    return [
      DataRepresentation(
        name: strings.value.host_name,
        code: "hostname",
        source: status?.systemInfo.toJson(),
      ),
      DataRepresentation(
        name: strings.value.lastUpdateTime,
        code: "last_updated",
        source: status?.toJson(),
        toValue: (status) {
          final date = (DateTime.parse(status["last_updated"]));
          return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
        },
      ),
      DataRepresentation(
        name: strings.value.lastUpdateDate,
        code: "last_updated",
        source: status?.toJson(),
        toValue: (status) {
          final date = (DateTime.parse(status["last_updated"]));
          return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
        },
      ),
      DataRepresentation(
        name: strings.value.osBootTime,
        code: "boot_time",
        source: status?.systemInfo.toJson(),
      ),
      DataRepresentation(
        name: strings.value.osTime,
        code: "system_time",
        source: status?.systemInfo.toJson(),
      ),
    ];
  }

  List<DataRepresentation> get logoContainerInfo {
    final strings = getTranslations(context).obs;
    return [
      DataRepresentation(
        name: strings.value.version,
        code: "version",
        source: status?.toJson(),
      ),
      DataRepresentation(
        name: strings.value.environment,
        code: "env",
        source: status?.toJson(),
      ),
      DataRepresentation(
        name: strings.value.debug,
        code: "debug",
        source: status?.toJson(),
        transform: (dynamic v) {
          return v == true ? strings.value.on : strings.value.off;
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;
    return AppCustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minWidth: context.width,
              maxWidth: context.width,
              minHeight: context.height,
              maxHeight: double.infinity,
            ),
            child: FutureBuilder(
              future: Future.wait([load()]),
              builder: (context, _) {
                if (!loaded.value) {
                  return Obx(() {
                    return CircularProgressIndicatorWithText(
                      text: strings.value.loading,
                    );
                  });
                }
                try {
                  return StreamBuilder(
                    stream: ServerStatusPage.stream,
                    builder: (context, snapshot) {
                      printMessage("snapshot: $snapshot");
                      if (snapshot.hasData) {
                        final data = JsonCodec().decode(snapshot.data);
                        if (data != null &&
                            data.containsKey("data") &&
                            data["data"] != null) {
                          try {
                            final decoded = data["data"];
                            status = SystemStatus.fromJson(decoded);
                          } catch (e) {
                            logger.e("Error parsing data: $e");
                            return const Center(
                              child: Text("Error parsing data"),
                            );
                          }
                        }
                      } else if (snapshot.hasError) {
                        logger.e("Error: ${snapshot.error}");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicatorWithText(
                          text: strings.value.waitingForConnection,
                        );
                      }
                      return _build();
                    },
                  );
                } catch (e) {
                  logger.e("Error in Future Builder: $e");
                  load();
                  return Center(
                    child: Text(
                      "Error loading data: $e",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  _build() {
    final strings = getTranslations(context).obs;
    return Obx(
      () {
        if (!loaded.value) {
          return CircularProgressIndicatorWithText(
            text: strings.value.loading,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              strings.value.serverStatus,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Container(
                  child: _dbStatesContainer(),
                ).marginSymmetric(horizontal: AppSizes.xl),
                Container(
                  child: _logoContainer(),
                ).marginSymmetric(horizontal: AppSizes.xl),
                Container(
                  child: _memoryContainer(),
                ).marginSymmetric(horizontal: AppSizes.xl),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Container(
                  child: _networkContainer(),
                ).marginSymmetric(horizontal: AppSizes.xl),
                Container(
                  child: _generalInfoContainer(),
                ).marginSymmetric(horizontal: AppSizes.xl),
                Container(
                  child: _systemContainer(),
                ).marginSymmetric(horizontal: AppSizes.xl)
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    printMessage("Call Load Status");
    await _loadStatus();
    printMessage("Status Loaded");

    loaded.value = true;
  }

  _dbStatesContainer() {
    final strings = getTranslations(context).obs;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.sm,
            ),
            Text(
              strings.value.databases,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              constraints: BoxConstraints(
                minWidth: 400,
                maxWidth: 400,
                minHeight: 300,
                maxHeight: 300,
              ),
              child: DataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                    ),
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                    ).removeWhen(isAtMostSmallScreen(context)),
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                    ),
                  ].nonNulls.toList(),
                  rows: (status?.databases.toJson())?.entries.map((db) {
                        return DataRow(
                            cells: [
                          DataCell(FittedBox(
                            child: Text(
                              db.key,
                              softWrap: false,
                            ),
                          )),
                          DataCell(FittedBox(
                            child: Text(
                              db.value is StandardDatabase
                                  ? "${(db.value as StandardDatabase).info?.entries.first.value.percent.toStringAsFixed(2)}%"
                                  : "${(db.value as RedisDatabase).info?.entries.first.value.percent.toStringAsFixed(2)}%",
                              softWrap: false,
                            ),
                          )).removeWhen(isAtMostSmallScreen(context)),
                          DataCell(Text(
                            (db.value is StandardDatabase
                                ? (db.value as StandardDatabase).state
                                : (db.value as RedisDatabase).state),
                            softWrap: false,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: (db.value is StandardDatabase
                                          ? (db.value as StandardDatabase).state
                                          : (db.value as RedisDatabase)
                                              .state) ==
                                      "CONNECTED"
                                  ? successColor
                                  : errorColor,
                            ),
                          )),
                        ].nonNulls.toList());
                      }).toList() ??
                      []),
            ),
          ],
        ),
      ),
    );
  }

  _memoryContainer() {
    final strings = getTranslations(context).obs;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.sm,
            ),
            Text(
              strings.value.memory,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 400,
                maxWidth: 400,
                minHeight: 300,
                maxHeight: 300,
              ),
              child: DataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                      size: ColumnSize.S,
                    ),
                  ],
                  rows: memoryContainerInfo.map((e) {
                    return DataRow(cells: [
                      DataCell(FittedBox(
                        child: Text(
                          e.name.toUpperCase(),
                          softWrap: false,
                        ),
                      )),
                      DataCell(FittedBox(
                        child: Text(
                          e.value.toString().toUpperCase(),
                          softWrap: false,
                        ),
                      )),
                    ]);
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  _generalInfoContainer() {
    final strings = getTranslations(context).obs;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.sm,
            ),
            Text(
              strings.value.info,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 400,
                maxWidth: 400,
                minHeight: 300,
                maxHeight: 300,
              ),
              child: DataTable2(
                columns: [
                  DataColumn2(
                    label: Text(
                      "",
                      softWrap: false,
                    ),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text(
                      "",
                      softWrap: false,
                    ),
                    size: ColumnSize.S,
                  ),
                ],
                rows: generalInfo.map((e) {
                  return DataRow(cells: [
                    DataCell(FittedBox(
                      child: Text(
                        e.name.toUpperCase(),
                        softWrap: false,
                      ),
                    )),
                    DataCell(FittedBox(
                      child: Text(
                        e.value.toString().toUpperCase(),
                        softWrap: false,
                      ),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _networkContainer() {
    final strings = getTranslations(context).obs;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.sm,
            ),
            Text(
              strings.value.network,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 400,
                maxWidth: 400,
                minHeight: 300,
                maxHeight: 300,
              ),
              child: DataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                      size: ColumnSize.S,
                    ),
                  ],
                  rows: networkContainerInfo.map((e) {
                    return DataRow(cells: [
                      DataCell(FittedBox(
                        child: Text(
                          e.name.toUpperCase(),
                          softWrap: false,
                        ),
                      )),
                      DataCell(FittedBox(
                        child: Text(
                          e.value.toString().toUpperCase(),
                          softWrap: false,
                        ),
                      )),
                    ]);
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  _systemContainer() {
    final strings = getTranslations(context).obs;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.sm,
            ),
            Text(
              strings.value.os,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 400,
                maxWidth: 400,
                minHeight: 300,
                maxHeight: 300,
              ),
              child: DataTable2(
                  columns: [
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text(
                        "",
                        softWrap: false,
                      ),
                      size: ColumnSize.S,
                    ),
                  ],
                  rows: systemContainerInfo.map((e) {
                    return DataRow(cells: [
                      DataCell(FittedBox(
                        child: Text(
                          e.name.toUpperCase(),
                          softWrap: false,
                        ),
                      )),
                      DataCell(FittedBox(
                        child: Text(
                          e.value.toString().toUpperCase(),
                          softWrap: false,
                        ),
                      )),
                    ]);
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  _loadStatus() async {
    final strings = getTranslations(context);
    _loadedStatus.value = false;
    try {
      logger.e("closing status channel");
      ServerStatusPage.channel?.sink.close();
      ServerStatusPage.stream = null;
      logger.e("reopening status channel");
      ServerStatusPage.channel = WebSocketChannel.connect(
        Uri.parse(ApiConfig.status_broadcast_websocket_url),
      );
      await ServerStatusPage.channel!.ready;
      ServerStatusPage.stream ??= ServerStatusPage.channel!.stream;
    } catch (e) {
      logger.e("failed to load server status: $e");
      if (context.mounted) {
        Toasts.showErrorToastNotification(
            context: context, message: strings.failedToLoadServerStatus);
      }
    }
    _loadedStatus.value = true;
  }

  _logoContainer() {
    final strings = getTranslations(context).obs;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.sm,
            ),
            Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: 400,
                maxWidth: 400,
                minHeight: 200,
                maxHeight: 200,
              ),
              child: DataTable2(
                columns: [
                  DataColumn2(
                    label: Text(""),
                  ),
                  DataColumn2(
                    label: Text(""),
                  ),
                ],
                rows: logoContainerInfo
                    .map((e) => DataRow2(cells: [
                          DataCell(
                            FittedBox(
                              child: Text(
                                e.name.toUpperCase(),
                                softWrap: false,
                              ),
                            ),
                          ),
                          DataCell(
                            FittedBox(
                              child: Text(
                                e.value.toString().toUpperCase(),
                                softWrap: false,
                              ),
                            ),
                          ),
                        ]))
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadButton(
                  onPressed: () {
                    Get.toNamed(Routes.serverSettings);
                  },
                  icon: const Icon(Icons.settings),
                  child: Text(
                    strings.value.settings,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                ShadButton(
                  onPressed: () {
                    api!.restartServer();
                  },
                  icon: const Icon(Icons.restart_alt_rounded),
                  child: Text(
                    strings.value.restartServer,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
