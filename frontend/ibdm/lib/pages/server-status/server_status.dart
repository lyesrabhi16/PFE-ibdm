import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/pages/users.dart';
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

  Rx<bool> refresh = false.obs;
  int retries = 3;

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
            child: Obx(() {
              if (retries == 0) {
                return Center(
                  child:
                      Text(strings.value.failedToConnectToStatusBroadcast(0)),
                );
              }
              if (!loaded.value) {
                printMessage("loading because of loaded value");
                load();
                logger.e("loading because of loaded value");
                return CircularProgressIndicatorWithText(
                  text: strings.value.loading,
                );
              }

              if (refresh.value) {
                refresh.value = false;
              }

              try {
                return _build();
              } catch (e) {
                printMessage("error: $e");
                ServerStatusPage.channel?.sink.close();
                ServerStatusPage.stream = null;
                load();
                return CircularProgressIndicatorWithText(
                  text: strings.value.loading,
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  _build() {
    try {
      final strings = getTranslations(context).obs;
      return StreamBuilder(
        stream: ServerStatusPage.stream,
        builder: (context, snapshot) {
          printMessage("snapshot: $snapshot");
          if (snapshot.connectionState == ConnectionState.waiting) {
            printMessage("waiting for connection");
            return CircularProgressIndicatorWithText(
              text: strings.value.waitingForConnection,
            );
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.hasError ||
              snapshot.data.isEmpty) {
            logger.e("loading inside of stream builder");
            if (ServerStatusPage.channel?.closeCode != null ||
                snapshot.connectionState != ConnectionState.active) {
              logger.e("closing channel");
              ServerStatusPage.channel?.sink.close();
              ServerStatusPage.stream = null;
              logger.e("reopening channel...");
              Future.delayed(Duration(seconds: 1), load);
            }
            return CircularProgressIndicatorWithText(
              text: strings.value.reconnecting,
            );
          }
          final data = JsonCodec().decode(snapshot.data);
          if (data["data"] == null || data["data"].isEmpty) {
            logger.e("data is null");
            return CircularProgressIndicatorWithText(
              text: strings.value.waitingForValidData,
            );
          }

          try {
            final decoded = data["data"];
            status = SystemStatus.fromJson(decoded);
          } catch (e) {
            logger.e("Error parsing data: $e");
            return const Center(
              child: Text("Error parsing data"),
            );
          }
          return _content();
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
  }

  _content() {
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

  bool loading = false;
  int counter = 0;
  int blocked = 0;
  Future<void> load() async {
    counter++;
    if (loading) {
      blocked++;
      return;
    }
    loading = true;
    final strings = getTranslations(context);
    printMessage("load...");

    loaded.value = false;

    try {
      if (ServerStatusPage.stream == null) {
        try {
          printMessage("connecting to ServerStatusPage broadcast");
          ServerStatusPage.channel = WebSocketChannel.connect(
              Uri.parse(ApiConfig.status_broadcast_websocket_url));

          printMessage("ServerStatusPage broadcast connected");
          await ServerStatusPage.channel!.ready;
          printMessage("ServerStatusPage broadcast ready");
          ServerStatusPage.stream =
              ServerStatusPage.channel!.stream.asBroadcastStream();
          loaded.value = true;
          printMessage("ServerStatusPage broadcast loaded");
        } catch (e) {
          printMessage("error connecting to ServerStatusPage broadcast: $e");
          logger.e(
              "Error connecting to ServerStatusPage broadcast${retries > 0 ? ',retrying' : ''}");
          if (retries > 0) {
            printMessage("retrying in 3 second");
            retries--;
            if (retries > 0) {
              Future.delayed(Duration(seconds: 3), load);
            }
          }
          Toasts.showErrorToastNotification(
              context: context,
              message: strings.failedToConnectToStatusBroadcast(retries));
        }
      } else {
        printMessage("Not Loading because Stream is not null");
      }
    } catch (e) {
      printMessage("loading faild: $e");
    } finally {
      loaded.value = true;
      loading = false;
    }
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
