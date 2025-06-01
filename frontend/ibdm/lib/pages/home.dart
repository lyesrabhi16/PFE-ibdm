import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/extensions/rbac_extensions.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/common/widgets/app_line_chart.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/setting_card.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/pages/reports/reports_page.dart';
import 'package:ibdm/pages/settings/emails/email_sents_page.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/socket.dart';
import 'package:ibdm/utils/constants/permissions.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/graphs.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static WebSocketChannel? statusChannel;
  static WebSocketChannel? sentEmailsChannel;
  static WebSocketChannel? siroperieChannel;
  static WebSocketChannel? filtrationChannel;
  static WebSocketChannel? utiliteChannel;

  static closeChannels() {
    statusChannel?.sink.close();
    sentEmailsChannel?.sink.close();
    siroperieChannel?.sink.close();
    filtrationChannel?.sink.close();
    utiliteChannel?.sink.close();
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void deactivate() {
    Home.closeChannels();
    super.deactivate();
  }

  @override
  void dispose() {
    Home.closeChannels();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Get.currentRoute != Routes.home) {
      Home.closeChannels();
      return const SizedBox.shrink();
    }

    final strings = getTranslations(context).obs;
    final userController = Get.find<UserController>();
    Stream? statusBroadcastStream;
    Stream? sentEmailsBroadcastStream;
    Stream? siroperieBroadcastStream;
    Stream? filtrationBroadcastStream;
    Stream? utiliteBroadcastStream;

    final items = [];
    return FutureBuilder(future: Future.sync(() async {
      Home.statusChannel =
          await getWebSocketChannel(ApiConfig.status_broadcast_websocket_url);
      statusBroadcastStream = Home.statusChannel!.stream.asBroadcastStream();

      Home.sentEmailsChannel = await getWebSocketChannel(
          ApiConfig.sent_emails_broadcast_websocket_url);
      sentEmailsBroadcastStream =
          Home.sentEmailsChannel!.stream.asBroadcastStream();

      Home.siroperieChannel =
          await getWebSocketChannel(ApiConfig.sucre_broadcast_websocket_url);
      siroperieBroadcastStream =
          Home.siroperieChannel!.stream.asBroadcastStream();

      Home.filtrationChannel = await getWebSocketChannel(
          ApiConfig.filtration_broadcast_websocket_url);
      filtrationBroadcastStream =
          Home.filtrationChannel!.stream.asBroadcastStream();

      Home.utiliteChannel =
          await getWebSocketChannel(ApiConfig.utilite_broadcast_websocket_url);
      utiliteBroadcastStream = Home.utiliteChannel!.stream.asBroadcastStream();
    }), builder: (context, snapshot) {
      return Obx(() {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:
                CircularProgressIndicatorWithText(text: strings.value.loading),
          );
        }
        if (items.isEmpty) {
          items.addAll([
            HomePageItemBuilder(
              title: strings.value.reports,
              icon: LucideIcons.fileText,
              child: FutureBuilder<List<Widget>>(
                  future: Future.sync(() => getTodaysReports(context)),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicatorWithText(
                          text: strings.value.loadingReports);
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(strings.value.errorLoadingReports),
                      );
                    }
                    return Column(children: [
                      ...snapshot.data!,
                    ]);
                  }),
            ).withAnyPermissionOf([
              Permissions.viewCo2ReportsPage,
              Permissions.viewSucreReportsPage,
              Permissions.viewFiltrationReportsPage,
              Permissions.viewUtiliteReportsPage,
            ]),
            LinkedHomePageItemBuilders(
              item1: HomePageItemBuilder(
                title: strings.value.serverStatus,
                icon: LucideIcons.server,
                child: StreamBuilder(
                    stream: statusBroadcastStream,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicatorWithText(
                            text: strings.value.loadingReports);
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        logger.e("error: ${snapshot.error}");
                        return Center(
                          child: Text(strings.value
                              .failedToConnectToStatusBroadcast(0)),
                        );
                      }
                      final data = JsonCodec().decode(snapshot.data);
                      if (data["data"] == null || data["data"].isEmpty) {
                        logger.e("data is null");
                        return CircularProgressIndicatorWithText(
                          text: strings.value.waitingForValidData,
                        );
                      }
                      SystemStatus status = SystemStatus.fromJson(data["data"]);
                      return Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              strings.value.cpuUsage,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "${status.systemInfo.cpuPercent}%",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: status.systemInfo.cpuPercent > 80
                                        ? errorColor
                                        : successColor,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              strings.value.memoryUsage,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "${status.systemInfo.memoryPercentUsed}%",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        status.systemInfo.memoryPercentUsed > 80
                                            ? errorColor
                                            : successColor,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              strings.value.storageUsage,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "${(status.systemInfo.usedStorage * 100 / status.systemInfo.totalStorage).toStringAsFixed(2)}%",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: (status.systemInfo.usedStorage *
                                                100 /
                                                status
                                                    .systemInfo.totalStorage) >
                                            80
                                        ? errorColor
                                        : successColor,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              strings.value.environment,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "${status.systemInfo.envMode.toUpperCase()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(),
                            ),
                          ],
                        ),
                      ]);
                    }),
              ),
              item2: HomePageItemBuilder(
                title: strings.value.databases,
                icon: LucideIcons.database,
                child: StreamBuilder(
                    stream: statusBroadcastStream,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicatorWithText(
                            text: strings.value.loading);
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(strings.value
                              .failedToConnectToStatusBroadcast(0)),
                        );
                      }
                      final data = JsonCodec().decode(snapshot.data);
                      if (data["data"] == null || data["data"].isEmpty) {
                        logger.e("data is null");
                        return CircularProgressIndicatorWithText(
                          text: strings.value.waitingForValidData,
                        );
                      }
                      SystemStatus status = SystemStatus.fromJson(data["data"]);
                      return Column(children: [
                        ...status.databases
                            .toJson()
                            .entries
                            .map(
                              (db) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    db.key,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    (db.value is StandardDatabase
                                        ? (db.value as StandardDatabase).state
                                        : (db.value as RedisDatabase).state),
                                    softWrap: false,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: (db.value is StandardDatabase
                                                      ? (db.value
                                                              as StandardDatabase)
                                                          .state
                                                      : (db.value
                                                              as RedisDatabase)
                                                          .state) ==
                                                  "CONNECTED"
                                              ? successColor
                                              : errorColor,
                                        ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ]);
                    }),
              ),
            ).withPermission(Permissions.viewServerStatusPage),
            HomePageItemBuilder(
              title: strings.value.emailSents,
              icon: LucideIcons.mail,
              child: FutureBuilder(
                future: Future.sync(getLast5Emails),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  List<Widget> _emailCards = <Widget>[...snapshot.data!];
                  return StreamBuilder(
                      stream: sentEmailsBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value.failedToLoadData),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        if (data["data"] != null && data["data"].isNotEmpty) {
                          final email = SentEmail.fromJson(data["data"]);
                          _emailCards.insert(0, _emailCard(email));
                        }

                        if (_emailCards.length > 5) {
                          _emailCards.removeRange(5, _emailCards.length);
                        }
                        printMessage("emailCards: $_emailCards");
                        return Column(children: _emailCards);
                      });
                },
              ),
            ).withPermission(Permissions.viewEmailsSent),
            HomePageItemBuilder(
              title: strings.value.siroperieTitle,
              icon: LucideIcons.boxes,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future:
                    Future.sync(() async => await Graphs.getSucreTotalGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }

                  return StreamBuilder(
                      stream: siroperieBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToSiroperieBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        final sucre = Sucre.fromJson(data["data"]);
                        liveData.add({
                          "Tetra": {
                            "x": sucre.date.millisecondsSinceEpoch,
                            "y": (sucre.tS21 ?? 0) +
                                (sucre.tS22 ?? 0) +
                                (sucre.tS23 ?? 0) +
                                (sucre.tS24 ?? 0) +
                                (sucre.tS25 ?? 0),
                          },
                          "Adue": {
                            "x": sucre.date.millisecondsSinceEpoch,
                            "y": (sucre.aT02 ?? 0) +
                                (sucre.aT03 ?? 0) +
                                (sucre.aT04 ?? 0) +
                                (sucre.aT05 ?? 0) +
                                (sucre.aT06 ?? 0),
                          }
                        });
                        logger.e(
                            "liveData sucre: start: ${DateTime.fromMillisecondsSinceEpoch(liveData.first["Tetra"]["x"])} end: ${DateTime.fromMillisecondsSinceEpoch(liveData.last["Tetra"]["x"])}");

                        //logger.e("liveData: $liveData");
                        return AppLineChart(
                            isLive: true,
                            liveDate: sucre.date,
                            graphTypes: [
                              GraphType(
                                name: "TOTAL",
                                ySuffix: " L",
                                includesXMax: true,
                                graphData: {
                                  "Tetra": [for (var e in liveData) e["Tetra"]],
                                  "Adue": [for (var e in liveData) e["Adue"]],
                                },
                                supportsFetchType: false,
                                getGraphData: Graphs.getSucreTotalGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewSiroperiePage),
            HomePageItemBuilder(
              title:
                  "${strings.value.filtrationTitle} - ${strings.value.niveau}",
              icon: Icons.battery_full_rounded,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future: Future.sync(
                    () async => await Graphs.getFiltrationNiveauGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  logger.e(
                      "liveData niveau: start: ${DateTime.fromMillisecondsSinceEpoch(liveData.first["Eau Brute"]["x"])} end: ${DateTime.fromMillisecondsSinceEpoch(liveData.last["Eau Brute"]["x"])}");
                  return StreamBuilder(
                      stream: filtrationBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToFiltrationBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final niveau = Niveau.fromJson(data["data"]["niveau"]);
                        liveData.add({
                          "Eau Brute": {
                            "x": niveau.date.millisecondsSinceEpoch,
                            "y": (niveau.nivF1 ?? 0) + (niveau.nivF2 ?? 0),
                          },
                          "Eau Filtrée": {
                            "x": niveau.date.millisecondsSinceEpoch,
                            "y": (niveau.nivUf1 ?? 0) + (niveau.nivUf2 ?? 0),
                          },
                          "Eau Osmosée": {
                            "x": niveau.date.millisecondsSinceEpoch,
                            "y": (niveau.nivOs1 ?? 0) +
                                (niveau.nivOs2 ?? 0) +
                                (niveau.nivOs3 ?? 0) +
                                (niveau.nivOs4 ?? 0) +
                                ((niveau.nivOs5 ?? 0) + (niveau.nivOs6 ?? 0)) /
                                    2 *
                                    7,
                          },
                          "Double Osmose Utilité": {
                            "x": niveau.date.millisecondsSinceEpoch,
                            "y": niveau.nivOs7 ?? 0,
                          },
                        });
                        return AppLineChart(
                            isLive: true,
                            liveDate: niveau.date,
                            graphTypes: [
                              GraphType(
                                name: "Niveau",
                                includesXMax: true,
                                ySuffix: " M3",
                                graphData: {
                                  "Eau Brute": [
                                    for (var e in liveData) e["Eau Brute"]
                                  ],
                                  "Eau Filtrée": [
                                    for (var e in liveData) e["Eau Filtrée"]
                                  ],
                                  "Eau Osmosée": [
                                    for (var e in liveData) e["Eau Osmosée"]
                                  ],
                                  "Double Osmose Utilité": [
                                    for (var e in liveData)
                                      e["Double Osmose Utilité"]
                                  ],
                                },
                                supportsFetchType: false,
                                getGraphData: Graphs.getSucreTotalGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewFiltrationPage),
            HomePageItemBuilder(
              title:
                  "${strings.value.filtrationTitle} - ${strings.value.volume}",
              icon: Icons.battery_full_rounded,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future: Future.sync(
                    () async => await Graphs.getFiltrationVolumeGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  return StreamBuilder(
                      stream: filtrationBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToFiltrationBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final volume = Volume.fromJson(data["data"]["volume"]);
                        liveData.add({
                          "forage": {
                            "x": volume.date.millisecondsSinceEpoch,
                            "y": volume.volFor ?? 0,
                          },
                          "UF": {
                            "x": volume.date.millisecondsSinceEpoch,
                            "y": (volume.volUf1 ?? 0) +
                                (volume.volUf2 ?? 0) +
                                (volume.volUf3 ?? 0) +
                                (volume.volUf4 ?? 0) +
                                (volume.volUf5 ?? 0) +
                                (volume.volUf6 ?? 0),
                          },
                          "OS": {
                            "x": volume.date.millisecondsSinceEpoch,
                            "y": (volume.volOs1 ?? 0) +
                                (volume.volOs2 ?? 0) +
                                (volume.volOs3 ?? 0) +
                                (volume.volOs4 ?? 0) +
                                (volume.volOs5 ?? 0) +
                                (volume.volOs6 ?? 0),
                          },
                          "contre lavage": {
                            "x": volume.date.millisecondsSinceEpoch,
                            "y": volume.volConLav ?? 0,
                          },
                        });
                        return AppLineChart(
                            isLive: true,
                            liveDate: volume.date,
                            graphTypes: [
                              GraphType(
                                includesXMax: true,
                                name: "Niveau",
                                ySuffix: " M3",
                                graphData: {
                                  "forage": [
                                    for (var e in liveData) e["forage"]
                                  ],
                                  "UF": [for (var e in liveData) e["UF"]],
                                  "OS": [for (var e in liveData) e["OS"]],
                                  "contre lavage": [
                                    for (var e in liveData) e["contre lavage"]
                                  ],
                                },
                                supportsFetchType: false,
                                getGraphData: Graphs.getSucreTotalGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewFiltrationPage),
            HomePageItemBuilder(
              title:
                  "${strings.value.filtrationTitle} - ${strings.value.debit}",
              icon: Icons.battery_full_rounded,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future: Future.sync(
                    () async => await Graphs.getFiltrationDebitGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  return StreamBuilder(
                      stream: filtrationBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToFiltrationBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final e = Debit.fromJson(data["data"]["debit"]);
                        liveData.add({
                          "Forage": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": (e.dF1 ?? 0) + (e.dF2 ?? 0),
                          },
                          "UF": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": (e.dUf1 ?? 0) +
                                (e.dUf2 ?? 0) +
                                (e.dUf3 ?? 0) +
                                (e.dUf4 ?? 0) +
                                (e.dUf5 ?? 0) +
                                (e.dUf6 ?? 0),
                          },
                          "OS": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": (e.dOs1 ?? 0) +
                                (e.dOs2 ?? 0) +
                                (e.dOs3 ?? 0) +
                                (e.dOs4 ?? 0) +
                                (e.dOs5 ?? 0) +
                                (e.dOs6 ?? 0),
                          },
                        });

                        //logger.e("debit data: $liveData");
                        final graphData = {
                          "Forage": [for (var e in liveData) e["Forage"]],
                          "UF": [for (var e in liveData) e["UF"]],
                          "OS": [for (var e in liveData) e["OS"]],
                        };
                        //logger.e("graphData: $graphData");
                        return AppLineChart(
                            isLive: true,
                            liveDate: e.date,
                            graphTypes: [
                              GraphType(
                                includesXMax: true,
                                name: "Debit",
                                ySuffix: " M3/h",
                                graphData: graphData,
                                supportsFetchType: false,
                                getGraphData: Graphs.getSucreTotalGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewFiltrationPage),
            HomePageItemBuilder(
              title:
                  "${strings.value.filtrationTitle} - ${strings.value.pression}",
              icon: Icons.battery_full_rounded,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future: Future.sync(
                    () async => await Graphs.getFiltrationPressionGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  return StreamBuilder(
                      stream: filtrationBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToFiltrationBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final e = PresCond.fromJson(data["data"]["pres_cond"]);
                        liveData.add({
                          "uf": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pUf ?? 0,
                          },
                          "uf4": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pUf4 ?? 0,
                          },
                          "uf6": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pUf6 ?? 0,
                          },
                          "os1": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs1 ?? 0,
                          },
                          "os2": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs2 ?? 0,
                          },
                          "os3": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs3 ?? 0,
                          },
                          "os4": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs4 ?? 0,
                          },
                          "os5": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs5 ?? 0,
                          },
                          "os6": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs6 ?? 0,
                          },
                          "os7": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs7 ?? 0,
                          },
                          "os8": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs8 ?? 0,
                          },
                          "os9": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs9 ?? 0,
                          },
                          "os71": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOs71 ?? 0,
                          },
                          "ose1": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOse1 ?? 0,
                          },
                          "ose2": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pOse2 ?? 0,
                          },
                          "conc": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.pConc ?? 0,
                          },
                        });
                        //logger.e("pression data: $liveData");
                        return AppLineChart(
                            isLive: true,
                            liveDate: e.date,
                            graphTypes: [
                              GraphType(
                                name: "Pression",
                                includesXMax: true,
                                ySuffix: " Bars",
                                graphData: {
                                  "uf": [for (var e in liveData) e["uf"]],
                                  "uf4": [for (var e in liveData) e["uf4"]],
                                  "uf6": [for (var e in liveData) e["uf6"]],
                                  "os1": [for (var e in liveData) e["os1"]],
                                  "os2": [for (var e in liveData) e["os2"]],
                                  "os3": [for (var e in liveData) e["os3"]],
                                  "os4": [for (var e in liveData) e["os4"]],
                                  "os5": [for (var e in liveData) e["os5"]],
                                  "os6": [for (var e in liveData) e["os6"]],
                                  "os7": [for (var e in liveData) e["os7"]],
                                  "os8": [for (var e in liveData) e["os8"]],
                                  "os9": [for (var e in liveData) e["os9"]],
                                  "os71": [for (var e in liveData) e["os71"]],
                                  "ose1": [for (var e in liveData) e["ose1"]],
                                  "ose2": [for (var e in liveData) e["ose2"]],
                                  "conc": [for (var e in liveData) e["conc"]],
                                },
                                supportsFetchType: false,
                                getGraphData:
                                    Graphs.getFiltrationPressionGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewFiltrationPage),
            HomePageItemBuilder(
              title:
                  "${strings.value.filtrationTitle} - ${strings.value.conductivity}",
              icon: Icons.battery_full_rounded,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future: Future.sync(
                    () async => await Graphs.getFiltrationConductiviteGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  return StreamBuilder(
                      stream: filtrationBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToFiltrationBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final e = PresCond.fromJson(data["data"]["pres_cond"]);
                        liveData.add({
                          "UF": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cUf ?? 0,
                          },
                          "OS1": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs1 ?? 0,
                          },
                          "OS2": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs2 ?? 0,
                          },
                          "OS3": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs3 ?? 0,
                          },
                          "OS4": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs4 ?? 0,
                          },
                          "OS5": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs5 ?? 0,
                          },
                          "OS6": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs6 ?? 0,
                          },
                          "OS7": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs7 ?? 0,
                          },
                          "OS8": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs8 ?? 0,
                          },
                          "OS9": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOs9 ?? 0,
                          },
                          "OSE": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.cOse ?? 0,
                          },
                        });
                        return AppLineChart(
                            isLive: true,
                            liveDate: e.date,
                            graphTypes: [
                              GraphType(
                                name: "Conductivité",
                                includesXMax: true,
                                ySuffix: " µS",
                                graphData: {
                                  "UF": [for (var e in liveData) e["UF"]],
                                  "OS1": [for (var e in liveData) e["OS1"]],
                                  "OS2": [for (var e in liveData) e["OS2"]],
                                  "OS3": [for (var e in liveData) e["OS3"]],
                                  "OS4": [for (var e in liveData) e["OS4"]],
                                  "OS5": [for (var e in liveData) e["OS5"]],
                                  "OS6": [for (var e in liveData) e["OS6"]],
                                  "OS7": [for (var e in liveData) e["OS7"]],
                                  "OS8": [for (var e in liveData) e["OS8"]],
                                  "OS9": [for (var e in liveData) e["OS9"]],
                                  "OSE": [for (var e in liveData) e["OSE"]],
                                },
                                supportsFetchType: false,
                                getGraphData:
                                    Graphs.getFiltrationConductiviteGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewFiltrationPage),
            HomePageItemBuilder(
              title: "${strings.value.utilite} - ${strings.value.temperature}",
              icon: LucideIcons.gauge,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future: Future.sync(
                    () async => await Graphs.getUtiliteTempGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  return StreamBuilder(
                      stream: utiliteBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToUtiliteBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final e = Utilite.fromJson(data["data"]["utilite"]);
                        liveData.add({
                          "Temp Trane Krones": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utKrTt ?? 0,
                          },
                          "Temp Trane Sidel": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utSidTt ?? 0,
                          },
                          "Temp Compresseur Krones": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utKrTc ?? 0,
                          },
                          "Temp Compresseur Sidel": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utSidTc ?? 0,
                          },
                        });
                        return AppLineChart(
                            isLive: true,
                            liveDate: e.date,
                            graphTypes: [
                              GraphType(
                                name: "Conductivité",
                                includesXMax: true,
                                ySuffix: " °C",
                                graphData: {
                                  "Temp Trane Krones": [
                                    for (var e in liveData)
                                      e["Temp Trane Krones"]
                                  ],
                                  "Temp Trane Sidel": [
                                    for (var e in liveData)
                                      e["Temp Trane Sidel"]
                                  ],
                                  "Temp Compresseur Krones": [
                                    for (var e in liveData)
                                      e["Temp Compresseur Krones"]
                                  ],
                                  "Temp Compresseur Sidel": [
                                    for (var e in liveData)
                                      e["Temp Compresseur Sidel"]
                                  ],
                                },
                                supportsFetchType: false,
                                getGraphData: Graphs.getUtiliteTempGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewUtilitePage),
            HomePageItemBuilder(
              title: "${strings.value.utilite} - ${strings.value.pression}",
              icon: LucideIcons.gauge,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future: Future.sync(
                    () async => await Graphs.getUtilitePressionGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  return StreamBuilder(
                      stream: utiliteBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToUtiliteBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final e = Utilite.fromJson(data["data"]["utilite"]);
                        liveData.add({
                          "Pression 7 Krones": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utKrP7 ?? 0,
                          },
                          "Pression 7 Sidel": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utSidP7 ?? 0,
                          },
                          "Pression 40 Krones": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utKrP40 ?? 0,
                          },
                          "Pression 40 Sidel": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utSidP40 ?? 0,
                          },
                          "Pression Azote Krones": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utKrPn2 ?? 0,
                          },
                          "Pression Azote Sidel": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utSidPn2 ?? 0,
                          },
                          "Pression Chaudiere Krones": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utKrPv ?? 0,
                          },
                          "Pression Chaudiere Sidel": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utSidPv ?? 0,
                          },
                          "Pression Gaz Krones": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utKrPg ?? 0,
                          },
                          "Pression Gaz Sidel": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utSidPg ?? 0,
                          },
                        });
                        //logger.e("util pression data: $liveData");
                        return AppLineChart(
                            isLive: true,
                            liveDate: e.date,
                            graphTypes: [
                              GraphType(
                                name: "Pression",
                                includesXMax: true,
                                ySuffix: " Bars",
                                graphData: {
                                  "Pression 7 Krones": [
                                    for (var e in liveData)
                                      e["Pression 7 Krones"]
                                  ],
                                  "Pression 7 Sidel": [
                                    for (var e in liveData)
                                      e["Pression 7 Sidel"]
                                  ],
                                  "Pression 40 Krones": [
                                    for (var e in liveData)
                                      e["Pression 40 Krones"]
                                  ],
                                  "Pression 40 Sidel": [
                                    for (var e in liveData)
                                      e["Pression 40 Sidel"]
                                  ],
                                  "Pression Azote Krones": [
                                    for (var e in liveData)
                                      e["Pression Azote Krones"]
                                  ],
                                  "Pression Azote Sidel": [
                                    for (var e in liveData)
                                      e["Pression Azote Sidel"]
                                  ],
                                  "Pression Chaudiere Krones": [
                                    for (var e in liveData)
                                      e["Pression Chaudiere Krones"]
                                  ],
                                  "Pression Chaudiere Sidel": [
                                    for (var e in liveData)
                                      e["Pression Chaudiere Sidel"]
                                  ],
                                  "Pression Gaz Krones": [
                                    for (var e in liveData)
                                      e["Pression Gaz Krones"]
                                  ],
                                  "Pression Gaz Sidel": [
                                    for (var e in liveData)
                                      e["Pression Gaz Sidel"]
                                  ],
                                },
                                supportsFetchType: false,
                                getGraphData: Graphs.getUtiliteTempGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewUtilitePage),
            HomePageItemBuilder(
              title: "${strings.value.co2} - ${strings.value.niveau}",
              icon: LucideIcons.cloud,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future:
                    Future.sync(() async => await Graphs.getCO2NiveauGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  return StreamBuilder(
                      stream: utiliteBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToUtiliteBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final e =
                            Co2Ifruit.fromJson(data["data"]["co2_ifruit"]);
                        liveData.add({
                          "MGI": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utCo2Vc1 ?? 0,
                          },
                          "CEVITAL": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utCo2Vc2 ?? 0,
                          },
                          "N2": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utN2Vn2 ?? 0,
                          },
                        });
                        return AppLineChart(
                            isLive: true,
                            liveDate: e.date,
                            graphTypes: [
                              GraphType(
                                includesXMax: true,
                                name: "Niveau",
                                ySuffix: " KG",
                                graphData: {
                                  "MGI": [for (var e in liveData) e["MGI"]],
                                  "CEVITAL": [
                                    for (var e in liveData) e["CEVITAL"]
                                  ],
                                  "N2": [for (var e in liveData) e["N2"]],
                                },
                                supportsFetchType: false,
                                getGraphData: Graphs.getCO2NiveauGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewCo2Page),
            HomePageItemBuilder(
              title: "${strings.value.co2} - ${strings.value.pression}",
              icon: LucideIcons.cloud,
              constraints: const BoxConstraints(
                maxWidth: 600,
                minWidth: 600,
                minHeight: 300,
              ),
              child: FutureBuilder(
                future: Future.sync(
                    () async => await Graphs.getCO2PressionGraphData(
                          DateTime.now().startOfDay,
                          DateTime.now().endOfDay,
                          FetchType.hours,
                        )),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicatorWithText(
                        text: strings.value.loading);
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(strings.value.failedToLoadData),
                    );
                  }
                  final List<Map> liveData = [];
                  final List keys = snapshot.data!.keys.toList();
                  final List values = snapshot.data!.entries.first.value;
                  for (var i = 0; i < values.length; i++) {
                    final mValue = {};
                    for (var j = 0; j < keys.length; j++) {
                      if (snapshot.data![keys[j]][i] != null) {
                        mValue[keys[j]] = snapshot.data![keys[j]][i];
                      }
                    }
                    if (mValue.entries.isNotEmpty) {
                      liveData.insert(0, mValue);
                    }
                  }
                  return StreamBuilder(
                      stream: utiliteBroadcastStream,
                      builder: (context, streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicatorWithText(
                              text: strings.value.loading);
                        }
                        if (streamSnapshot.hasError) {
                          return Center(
                            child: Text(strings.value
                                .failedToConnectToUtiliteBroadcast(0)),
                          );
                        }
                        final data = JsonCodec().decode(streamSnapshot.data);
                        //logger.e("data: $data");
                        final e =
                            Co2Ifruit.fromJson(data["data"]["co2_ifruit"]);
                        liveData.add({
                          "MGI": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utCo2Pc1 ?? 0,
                          },
                          "CEVITAL": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utCo2Pc2 ?? 0,
                          },
                          "N2": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utN2Pn2 ?? 0,
                          },
                          "NOURISSE": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utCo2Pn ?? 0,
                          },
                          "SOUDE": {
                            "x": e.date.millisecondsSinceEpoch,
                            "y": e.utSoude ?? 0,
                          },
                        });
                        return AppLineChart(
                            isLive: true,
                            liveDate: e.date,
                            graphTypes: [
                              GraphType(
                                includesXMax: true,
                                name: "Pression",
                                ySuffix: " Bars",
                                graphData: {
                                  "MGI": [for (var e in liveData) e["MGI"]],
                                  "CEVITAL": [
                                    for (var e in liveData) e["CEVITAL"]
                                  ],
                                  "N2": [for (var e in liveData) e["N2"]],
                                  "NOURISSE": [
                                    for (var e in liveData) e["NOURISSE"]
                                  ],
                                  "SOUDE": [for (var e in liveData) e["SOUDE"]],
                                },
                                supportsFetchType: false,
                                getGraphData: Graphs.getCO2NiveauGraphData,
                              ),
                            ]);
                      });
                },
              ),
            ).withPermission(Permissions.viewCo2Page),
          ].nonNulls.toList());
        }
        return AppCustomContainer(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          strings.value.welcome,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ).marginAll(AppSizes.sm),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          getUserName(userController.user!),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ).marginAll(AppSizes.sm),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  if (items.isEmpty)
                    Center(
                      child: Text(
                        strings.value.nothingToDisplay,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                  if (items.isNotEmpty)
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: AppSizes.md,
                      runSpacing: AppSizes.md,
                      children: [
                        for (var item in items)
                          if (item is LinkedHomePageItemBuilders)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ConstrainedBox(
                                  constraints: item.item1.constraints,
                                  child: Card(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerLow,
                                    elevation: 3,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.all(AppSizes.sm),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  item.item1.icon,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                const SizedBox(
                                                    width: AppSizes.sm),
                                                Text(
                                                  item.item1.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            item.item1.child,
                                          ],
                                        )),
                                  ),
                                ),
                                const SizedBox(width: AppSizes.md),
                                ConstrainedBox(
                                  constraints: item.item2.constraints,
                                  child: Card(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerLow,
                                    elevation: 3,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.all(AppSizes.sm),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  item.item2.icon,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                                const SizedBox(
                                                    width: AppSizes.sm),
                                                Text(
                                                  item.item2.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            item.item2.child,
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            )
                          else if (item is HomePageItemBuilder)
                            ConstrainedBox(
                              constraints: item.constraints,
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                elevation: 3,
                                child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              item.icon,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            const SizedBox(width: AppSizes.sm),
                                            Text(
                                              item.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: AppSizes.md,
                                        ),
                                        item.child,
                                      ],
                                    )),
                              ),
                            )
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  FutureOr getLast5Emails() async {
    final api = await ApiClientInstance.getApiClient();
    final res = await api.getSentEmails(
      enablePagination: true,
      page: 1,
      perPage: 5,
    );
    return res.data.map((email) => _emailCard(email)).toList();
  }

  SettingCard _emailCard(SentEmail email) {
    final strings = getTranslations(context).obs;
    return SettingCard(
      title: email.schedule != null
          ? '${strings.value.scheduleEmail} ${email.schedule!.rapport.json}'
          : '${strings.value.alert} ${email.alert!.alert.monitoredValue.json}',
      trailing: Text(
        DateFormat("dd-MM-yyyy HH:mm").format(email.tempsEnvoi),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
      ),
      subtitle: email.receptionist,
      titleTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: email.schedule != null
                ? Theme.of(context).colorScheme.primary
                : email.alert!.alertType == AlertTypeEnum.danger
                    ? errorColor
                    : Colors.amber,
          ),
      onTap: () {
        showViewSentEmailDialog(context, sent: email);
      },
    );
  }
}

class HomePageItemBuilder {
  final String title;
  final IconData? icon;
  final Widget child;
  final BoxConstraints constraints;
  HomePageItemBuilder(
      {this.title = "",
      this.icon,
      this.child = const SizedBox(),
      this.constraints = const BoxConstraints(
        maxWidth: 400,
        minWidth: 200,
        minHeight: 100,
      )});
}

class LinkedHomePageItemBuilders {
  final HomePageItemBuilder item1;
  final HomePageItemBuilder item2;
  LinkedHomePageItemBuilders({required this.item1, required this.item2});
}
