import 'dart:math';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/divider_with_text.dart';
import 'package:ibdm/common/widgets/icon_with_label_button.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/data_representation.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';

class ServerSettingsPage extends StatefulWidget {
  const ServerSettingsPage({super.key});

  @override
  State<ServerSettingsPage> createState() => _ServerSettingsPageState();
}

class _ServerSettingsPageState extends State<ServerSettingsPage> {
  Function? _getContext;
  BuildContext get getContext => _getContext!.call()!;
  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  IbdmApiClient? api;
  final RxBool loaded = false.obs;
  final RxBool _isDataLoading = false.obs;
  final RxBool _showChangeSecretKey = false.obs;

  Rx<ServerConfig?> config = Rx<ServerConfig?>(null);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? secretKey;

  static final TextEditingController _addAllowedHostController =
      TextEditingController();

  static final TextEditingController _addTrustedOriginController =
      TextEditingController();

  final RxBool _showAddEmailProviderForm = false.obs;

  final RxBool _showAddDatabaseForm = false.obs;

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    _getContext = () => context;
    return AppCustomContainer(
      backButton: true,
      child: Container(
        constraints: BoxConstraints(
          minWidth: context.width,
          maxWidth: context.width,
          minHeight: max(context.height - AppSizes.heightOffset * 2, 600),
          maxHeight: max(context.height - AppSizes.heightOffset * 2, 600),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: Obx(
              () {
                if (!loaded.value) {
                  load();
                  return CircularProgressIndicatorWithText(
                    text: strings.value.loadingServerConfig,
                  );
                }
                logger.e("Config: ${config.value!.toJson()}");
                return Column(
                  children: [
                    Text(
                      strings.value.serverSettings,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    SizedBox(height: AppSizes.xl),
                    IconWithLabelButton(
                      icon: Icons.save,
                      text: strings.value.save,
                      onTap: () {
                        if (_formKey.currentState?.validate() != true) {
                          if (context.mounted) {
                            Toasts.showErrorToastNotification(
                                context: context,
                                message:
                                    strings.value.pleaseFixErrorsInTheForm);
                          }
                          return;
                        }
                        showShadDialog(
                          context: context,
                          builder: (context) => ShadDialog.alert(
                            title: Text(strings.value.saveConfig),
                            actions: [
                              ShadButton.secondary(
                                icon: Icon(Icons.close),
                                child: Text(strings.value.cancel),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ShadButton(
                                icon: Icon(Icons.save),
                                child: Text(strings.value.save),
                                onPressed: () async {
                                  saveConfig();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                            child: Text(strings.value.saveConfigAlertMessage),
                          ).marginOnly(
                            top: AppSizes.md,
                          ),
                        );
                      },
                    ),
                    IconWithLabelButton(
                      icon: Icons.refresh,
                      text: strings.value.refresh,
                      onTap: () {
                        load();
                      },
                    ),
                    DividerWithText(
                      text: strings.value.serverSettings,
                      color: colorScheme.primary,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: AppSizes.xl,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400,
                                ),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          initialValue: config.value?.version,
                                          onChanged: (value) {
                                            modifyConfig("VERSION", value);
                                          },
                                          validator:
                                              FormBuilderValidators.required(
                                            errorText:
                                                strings.value.requiredField,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: strings.value.version,
                                            hintText: "1.0.0",
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.sm),
                                        ShadSelectFormField<String>(
                                          initialValue: config.value?.envMode,
                                          onChanged: (value) {
                                            modifyConfig("ENV_MODE", value);
                                          },
                                          placeholder: Center(
                                              child: Text(
                                                  strings.value.environment)),
                                          selectedOptionBuilder:
                                              (context, value) => Center(
                                            child: Text(
                                              " ${strings.value.environment}: ${value.toString()} ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                          minWidth: 375,
                                          maxWidth: 375,
                                          options: [
                                            Center(
                                              child: ShadOption(
                                                  value: "development",
                                                  child: Center(
                                                      child:
                                                          Text("development"))),
                                            ),
                                            Center(
                                              child: ShadOption(
                                                  value: "production",
                                                  child: Center(
                                                      child:
                                                          Text("production"))),
                                            ),
                                          ],
                                          allowDeselection: false,
                                        ),
                                        SizedBox(height: AppSizes.sm),
                                        if (_showChangeSecretKey.value)
                                          TextFormField(
                                            onChanged: (value) {
                                              secretKey = value;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText:
                                                  strings.value.newSecretKey,
                                              hintText: "secretkey",
                                            ),
                                          ),
                                        Center(
                                          child: ShadButton.ghost(
                                            child: Text(
                                              _showChangeSecretKey.value
                                                  ? strings.value.cancel
                                                  : strings
                                                      .value.changeSecretKey,
                                            ),
                                            onPressed: () {
                                              if (_showChangeSecretKey.value) {
                                                secretKey = null;
                                              }
                                              _showChangeSecretKey.value =
                                                  !_showChangeSecretKey.value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400,
                                ),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ShadSwitchFormField(
                                          initialValue:
                                              config.value?.debug ?? false,
                                          inputLabel: Text(strings.value.debug),
                                          onChanged: (value) {
                                            modifyConfig("DEBUG", value);
                                          },
                                        ),
                                        ShadSwitchFormField(
                                          initialValue:
                                              config.value?.logTOFiles ?? false,
                                          inputLabel:
                                              Text(strings.value.logToFiles),
                                          onChanged: (value) {
                                            modifyConfig("LOG_TO_FILES", value);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400,
                                ),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          initialValue:
                                              "${config.value?.serverDBConnectionCheckTimeout}",
                                          onChanged: (value) {
                                            modifyConfig(
                                                "SERVER_DB_CONNECTION_CHECK_TIMEOUT",
                                                int.tryParse(value) ?? 0);
                                          },
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.integer(
                                                errorText: strings.value
                                                    .invalidField(strings.value
                                                        .dbConnectionCheckTimeout)),
                                            FormBuilderValidators.min(
                                              1,
                                              errorText: strings.value.min(1),
                                            ),
                                          ]),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: strings
                                                .value.dbConnectionCheckTimeout,
                                            hintText: "10",
                                            suffix: Text(
                                              strings.value.seconds,
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.sm),
                                        TextFormField(
                                          initialValue:
                                              "${config.value?.systemMonitorDBTimeout}",
                                          onChanged: (value) {
                                            modifyConfig(
                                                "SYSTEM_MONITOR_DB_TIMEOUT",
                                                int.tryParse(value) ?? 0);
                                          },
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.integer(
                                                errorText: strings.value
                                                    .invalidField(strings.value
                                                        .systemMonitorDBTimeout)),
                                            FormBuilderValidators.min(
                                              1,
                                              errorText: strings.value.min(1),
                                            ),
                                          ]),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: strings
                                                .value.systemMonitorDBTimeout,
                                            hintText: "10",
                                            suffix: Text(
                                              strings.value.seconds,
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.sm),
                                        TextFormField(
                                          initialValue:
                                              "${config.value?.dataStoppedWaitSeconds}",
                                          onChanged: (value) {
                                            modifyConfig(
                                                "DATA_STOPPED_WAIT_SECONDS",
                                                int.tryParse(value) ?? 0);
                                          },
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.integer(
                                                errorText: strings.value
                                                    .invalidField(strings.value
                                                        .dataStoppedWaitSeconds)),
                                            FormBuilderValidators.min(
                                              1,
                                              errorText: strings.value.min(1),
                                            ),
                                          ]),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: strings
                                                .value.dataStoppedWaitSeconds,
                                            hintText: "600",
                                            suffix: Text(
                                              strings.value.seconds,
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.sm),
                                        TextFormField(
                                          initialValue:
                                              "${config.value?.logSizeLimit}",
                                          onChanged: (value) {
                                            modifyConfig("LOG_SIZE_LIMIT",
                                                int.tryParse(value) ?? 0);
                                          },
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.integer(
                                                errorText: strings.value
                                                    .invalidField(strings
                                                        .value.logSizeLimit)),
                                            FormBuilderValidators.min(
                                              0,
                                              errorText: strings.value.min(0),
                                            ),
                                          ]),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText:
                                                strings.value.logSizeLimit,
                                            hintText: "100",
                                            suffix: Text(
                                              "MB",
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.sm),
                                        TextFormField(
                                          initialValue:
                                              "${config.value?.countOFLogsTOKeep}",
                                          onChanged: (value) {
                                            modifyConfig(
                                                "COUNT_OF_LOGS_TO_KEEP",
                                                int.tryParse(value) ?? 0);
                                          },
                                          validator:
                                              FormBuilderValidators.compose([
                                            FormBuilderValidators.integer(
                                                errorText: strings.value
                                                    .invalidField(strings.value
                                                        .numberOfLogsToKeep)),
                                            FormBuilderValidators.min(
                                              1,
                                              errorText: strings.value.min(1),
                                            ),
                                          ]),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: strings
                                                .value.numberOfLogsToKeep,
                                            hintText: "100",
                                            suffix: Text(
                                              strings.value.logs,
                                              style: TextStyle(
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.md),
                          Wrap(
                            spacing: AppSizes.lg,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400,
                                  minWidth: 400,
                                ),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(children: [
                                      Text(strings.value.allowedHosts,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                      SizedBox(height: AppSizes.sm),
                                      Divider(),
                                      for (String host
                                          in config.value?.allowedHosts ?? [])
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FittedBox(child: Text(host)),
                                            ShadButton.ghost(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                // Remove host logic here
                                                final allowedHosts = config
                                                        .value?.allowedHosts ??
                                                    [];
                                                allowedHosts.remove(host);
                                                modifyConfig("ALLOWED_HOSTS",
                                                    allowedHosts);
                                              },
                                            ),
                                          ],
                                        ),
                                      SizedBox(
                                        width: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                onSubmitted: (value) {
                                                  // Add host logic here
                                                  final allowedHosts = config
                                                          .value
                                                          ?.allowedHosts ??
                                                      [];
                                                  allowedHosts.add(value);
                                                  modifyConfig("ALLOWED_HOSTS",
                                                      allowedHosts);
                                                },
                                                controller:
                                                    _addAllowedHostController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: strings
                                                      .value.addAllowedHost,
                                                  hintText:
                                                      "www.example.com or .example.com or *",
                                                ),
                                              ),
                                            ),
                                            ShadButton.ghost(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                // Add host logic here
                                                final allowedHosts = config
                                                        .value?.allowedHosts ??
                                                    [];
                                                allowedHosts.add(
                                                    _addAllowedHostController
                                                        .text);
                                                modifyConfig("ALLOWED_HOSTS",
                                                    allowedHosts);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400,
                                  minWidth: 400,
                                ),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(children: [
                                      Text(strings.value.trustedOrigins,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                      SizedBox(height: AppSizes.sm),
                                      Divider(),
                                      for (String host
                                          in config.value?.csrfTrustedOrigins ??
                                              [])
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FittedBox(child: Text(host)),
                                            ShadButton.ghost(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                // Remove host logic here
                                                final trustedOrigins = config
                                                        .value
                                                        ?.csrfTrustedOrigins ??
                                                    [];
                                                trustedOrigins.remove(host);
                                                modifyConfig(
                                                    "CSRF_TRUSTED_ORIGINS",
                                                    trustedOrigins);
                                              },
                                            ),
                                          ],
                                        ),
                                      SizedBox(
                                        width: 400,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    _addTrustedOriginController,
                                                onFieldSubmitted: (v) {
                                                  // Add host logic here
                                                  final trustedOrigins = config
                                                          .value
                                                          ?.csrfTrustedOrigins ??
                                                      [];
                                                  trustedOrigins.add(
                                                      _addTrustedOriginController
                                                          .text);
                                                  modifyConfig(
                                                      "CSRF_TRUSTED_ORIGINS",
                                                      trustedOrigins);
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: strings
                                                      .value.addTrustedOrigin,
                                                  hintText:
                                                      "https://www.example.com:8443",
                                                ),
                                              ),
                                            ),
                                            ShadButton.ghost(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                // Add host logic here
                                                final trustedOrigins = config
                                                        .value
                                                        ?.csrfTrustedOrigins ??
                                                    [];
                                                trustedOrigins.add(
                                                    _addTrustedOriginController
                                                        .text);
                                                modifyConfig(
                                                    "CSRF_TRUSTED_ORIGINS",
                                                    trustedOrigins);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.md),
                          Wrap(
                            spacing: AppSizes.xl,
                            direction: Axis.horizontal,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400,
                                  minWidth: 400,
                                ),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(children: [
                                      Text(strings.value.emailProviders,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                      SizedBox(height: AppSizes.sm),
                                      Divider(),
                                      for (var provider in config
                                              .value?.emailProviders?.entries ??
                                          {}.entries)
                                        EmailProviderCard(
                                          provider: provider.value,
                                          color:
                                              colorScheme.surfaceContainerHigh,
                                          name: provider.key,
                                          onEdit: (newProvider) {
                                            config.update((c) => c!
                                                    .emailProviders?[
                                                provider.key] = newProvider);
                                          },
                                          onDelete: (_) {
                                            config.update((c) => c!
                                                .emailProviders
                                                ?.remove(provider.key));
                                          },
                                        ),
                                      SizedBox(height: AppSizes.sm),
                                      if (_showAddEmailProviderForm.value)
                                        EmailProviderCard(
                                          name: strings.value.newEmailProvider,
                                          editable: true,
                                          isAddProviderCard: true,
                                          onAdd: (newProvider) {
                                            config.update((c) =>
                                                c!.emailProviders?[newProvider
                                                    .host] = newProvider);
                                          },
                                        ),
                                      Center(
                                        child: ShadButton(
                                          width: 400,
                                          icon: Icon(
                                              _showAddEmailProviderForm.value
                                                  ? Icons.close
                                                  : Icons.add),
                                          onPressed: () {
                                            _showAddEmailProviderForm.value =
                                                !_showAddEmailProviderForm
                                                    .value;
                                          },
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400,
                                  minWidth: 400,
                                ),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.sm),
                                    child: Column(children: [
                                      Text(strings.value.databases,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                      SizedBox(height: AppSizes.sm),
                                      Divider(),
                                      if (config.value?.redisDB != null)
                                        DatabaseCard(
                                          color:
                                              colorScheme.surfaceContainerHigh,
                                          database: config.value!.redisDB,
                                          onEdit: (newDatabase) {
                                            modifyConfig("REDIS_DB",
                                                newDatabase.toJson());
                                          },
                                          name: config.value!.redisDB?.name ??
                                              "Redis",
                                        ),
                                      for (var db
                                          in config.value?.databases?.entries ??
                                              {}.entries)
                                        DatabaseCard(
                                          database: db.value,
                                          color:
                                              colorScheme.surfaceContainerHigh,
                                          name: db.key,
                                          onEdit: (newDatabase) {
                                            config.update((c) =>
                                                c!.databases?[db.key] =
                                                    newDatabase);
                                          },
                                          onDelete: (_) {
                                            config.update((c) =>
                                                c!.databases?.remove(db.key));
                                          },
                                        ),
                                      SizedBox(height: AppSizes.sm),
                                      if (_showAddDatabaseForm.value)
                                        DatabaseCard(
                                          name: strings.value.newDatabase,
                                          editable: true,
                                          isAddDatabaseCard: true,
                                          onAdd: (newDatabase, identifier) {
                                            config.update((c) =>
                                                c!.databases?[identifier] =
                                                    newDatabase);
                                          },
                                        ),
                                      Center(
                                        child: ShadButton(
                                          width: 400,
                                          icon: Icon(_showAddDatabaseForm.value
                                              ? Icons.close
                                              : Icons.add),
                                          onPressed: () {
                                            // Add host logic here
                                            _showAddDatabaseForm.value =
                                                !_showAddDatabaseForm.value;
                                          },
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> load() async {
    if (loaded.value) {
      loaded.value = false;
    }
    api ??= await ApiClientInstance.getApiClient();
    try {
      await _loadConfig();
      printMessage("loading config");
      /* config.value = ServerConfig.fromJson({
        "VERSION": "1.0.2",
        "ENV_MODE": "production",
        "DEBUG": false,
        "SYSTEM_MONITOR_DB_TIMEOUT": 3,
        "ALLOWED_HOSTS": ["172.20.101.145"],
        "CSRF_TRUSTED_ORIGINS": [
          "https://172.20.101.145",
          "https://localhost:8443"
        ],
        "LOG_TO_FILES": true,
        "SERVER_DB_CONNECTION_CHECK_TIMEOUT": 3,
        "REDIS_DB": {
          "ENGINE": null,
          "NAME": null,
          "USER": null,
          "PASSWORD": null,
          "HOST": null,
          "PORT": "6379",
          "OPTIONS": null
        },
        "DATABASES": {
          "ibdm": {
            "ENGINE": "mssql",
            "NAME": "ibdm_test",
            "USER": "ibdm-system",
            "PASSWORD":
                "gAAAAABoARhvwpKn78L-Go4x7XipuMHF1Ua_XTkxHbFEcVMrdFgy6Y1RtZJN4vFzwaQDCo95RA8Y49MnevHCtSkn9QL5BoWKpA==",
            "HOST": "127.0.0.1",
            "PORT": "1433",
            "OPTIONS": {"driver": "ODBC Driver 17 for SQL Server"}
          },
          "siroperie": {
            "ENGINE": "mssql",
            "NAME": "siroperie",
            "USER": "Ifri",
            "PASSWORD":
                "gAAAAABoARhwv3HaydAtltlEoL5HhdUluDBxDWWR-Gpud4Eal11Si_ixZ6P0HW2xL8TlMDZe6Rbm2Nvvn_8bVaobUvSJB_-tvA==",
            "HOST": "172.20.101.144",
            "PORT": "1433",
            "OPTIONS": {"driver": "ODBC Driver 17 for SQL Server"}
          },
          "filtration": {
            "ENGINE": "mssql",
            "NAME": "Filtration",
            "USER": "Ifri",
            "PASSWORD":
                "gAAAAABoARhwTUbNfu2DPFIoQ6ypRbvspehkDN51hAods7-0rZG0FLB5QCjEBu1S6sPDKWEyiPjAgRCZhxIlTUnigTzG-1TMlQ==",
            "HOST": "172.20.101.144",
            "PORT": "1433",
            "OPTIONS": {"driver": "ODBC Driver 17 for SQL Server"}
          },
          "utilite": {
            "ENGINE": "mssql",
            "NAME": "Utilite",
            "USER": "Ifri",
            "PASSWORD":
                "gAAAAABoARhw3ADec88ZoRJbSkQYv-zi8fzY9GD92ibMd_eRNUsewb57Fc72i3c84xh7RwmRIgA-XSWXE2rumAErxWWXXgJkhA==",
            "HOST": "172.20.101.144",
            "PORT": "1433",
            "OPTIONS": {"driver": "ODBC Driver 17 for SQL Server"}
          }
        },
        "EMAIL_PROVIDERS": {
          "172.16.10.29": {
            "HOST": "172.16.10.29",
            "PORT": 587,
            "USE_TLS": true,
            "USER": "Industrie@ifri-dz.local",
            "PASSWORD":
                "gAAAAABoARhwW1m0WScaEeHi2yWGP3Ff0_zqSkY3_jp3M9uhiIrDKTevz6cvWvX4heCb0Zf3HVK6GGfz2RDJDIRUaDxRpqTLFA==",
            "EMAIL_OF_SENDER": "Industrie@ifri-dz.com"
          }
        }
      }); */
      printMessage("config loaded : ${config.value}");
    } catch (e) {
      printMessage("error loading config : $e");
    } finally {
      loaded.value = true;
    }
  }

  _loadConfig() async {
    final strings = getTranslations(context);
    _isDataLoading.value = true;

    // Load alerts
    try {
      config.value = await api!.getServerConfig();
    } catch (e) {
      logger.e("Failed to load config : $e");
      if (context.mounted) {
        Toasts.showErrorToastNotification(
            context: context, message: strings.failedToLoadServerConfig);
      }
    }
    _isDataLoading.value = false;
  }

  ServerConfig? modifyConfig(String s, dynamic value) {
    final newConfig = config.value!.toJson();
    final databases = Map.fromEntries(config.value!.databases!.entries.map((e) {
      return MapEntry(e.key, e.value.toJson());
    }));
    newConfig["DATABASES"] = databases;

    final emailProviders =
        Map.fromEntries(config.value!.emailProviders!.entries.map((e) {
      return MapEntry(e.key, e.value.toJson());
    }));
    newConfig["EMAIL_PROVIDERS"] = emailProviders;
    newConfig["REDIS_DB"] = config.value?.redisDB?.toJson();

    newConfig[s] = value;

    config.value = ServerConfig.fromJson(newConfig);
    return config.value;
  }

  Future<void> saveConfig() async {
    final strings = getTranslations(context);
    final _state = FutureState.loading.obs;
    final toast = Toasts.showStatefulToast(
      state: _state,
      context: context,
      message: strings.savingConfig,
      messageError: strings.failedToSaveConfig,
      messageSuccess: strings.configSaved,
    );
    try {
      final jsonConfig = config.value!.toJson();
      jsonConfig["DATABASES"] = Map.fromEntries(config.value!.databases!.entries
          .map((e) => MapEntry(e.key, e.value.toJson())));
      jsonConfig["EMAIL_PROVIDERS"] = Map.fromEntries(config
          .value!.emailProviders!.entries
          .map((e) => MapEntry(e.key, e.value.toJson())));
      jsonConfig["REDIS_DB"] = config.value?.redisDB?.toJson();
      if (secretKey != null) {
        jsonConfig["SECRET_KEY"] = secretKey;
      }
      final res = await api?.setServerConfig(
        body: ServerConfigRequest.fromJson(jsonConfig),
      );
      _state.value = FutureState.success;
    } catch (e) {
      _state.value = FutureState.error;
      logger.e("Failed to save config : $e");
      if (context.mounted) {
        Toasts.showErrorToastNotification(
            context: context, message: strings.failedToSaveConfig);
      }
    } finally {
      Future.delayed(Durations.long2, () {
        toastification.dismissById(toast.id);
      });
    }
  }
}

class DatabaseCard extends StatelessWidget {
  final StandardDatabaseConf? database;
  final String name;
  final Color? color;
  final Function(StandardDatabaseConf)? onDelete;
  final Function(StandardDatabaseConf)? onEdit;
  final Function(StandardDatabaseConf newDatabase, String dbIdentifier)? onAdd;
  final bool isAddDatabaseCard;
  final bool editable;
  DatabaseCard(
      {super.key,
      this.database,
      required this.name,
      this.color,
      this.onDelete,
      this.onEdit,
      this.onAdd,
      this.isAddDatabaseCard = false,
      this.editable = false});

  final RxBool _editable = false.obs;

  String? dbIdentifier;
  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    if (editable != _editable.value) {
      _editable.value = editable;
    }
    StandardDatabaseConf _database = database ??
        StandardDatabaseConf(
          engine: "mssql",
          options: {
            "driver": "ODBC Driver 17 for SQL Server",
          },
          name: "",
          host: "",
          port: "1433",
          user: "",
          password: "",
        );
    final RxMap _data = _database.toJson().obs;
    List<DataRepresentation> data = [
      DataRepresentation(
          name: strings.value.engine,
          code: "ENGINE",
          source: _database.toJson()),
      DataRepresentation(
          name: strings.value.host, code: "HOST", source: _database.toJson()),
      DataRepresentation(
          name: strings.value.port, code: "PORT", source: _database.toJson()),
      DataRepresentation(
          name: strings.value.name, code: "NAME", source: _database.toJson()),
      DataRepresentation(
          name: strings.value.user, code: "USER", source: _database.toJson()),
      DataRepresentation(
          name: strings.value.password,
          code: "PASSWORD",
          source: _database.toJson()),
    ];
    final controllers = {};
    for (var d in data) {
      if (d.value != null) {
        controllers[d.code] = TextEditingController(text: d.value.toString());
      }
    }
    for (var d in _database.options?.entries ?? {}.entries) {
      if (d.value != null) {
        controllers[d.key] = TextEditingController(text: d.value.toString());
      }
    }
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DividerWithText(text: name),
                SizedBox(height: AppSizes.md),
                for (var d in data) ...[
                  if (d.value != null) ...[
                    Center(
                        child: TextField(
                      enabled: _editable.value,
                      controller: controllers[d.code],
                      onChanged: (v) {
                        _data[d.code] = v;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: d.name,
                      ),
                    )),
                    SizedBox(height: AppSizes.sm)
                  ]
                ],
                for (var o in _database.options?.entries ?? {}.entries) ...[
                  if (o.value != null) ...[
                    Center(
                        child: TextField(
                      enabled: _editable.value,
                      controller: controllers[o.key],
                      onChanged: (v) {
                        _data["OPTIONS"][o.key] = v;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: o.key,
                      ),
                    )),
                    SizedBox(height: AppSizes.sm)
                  ],
                  SizedBox(height: AppSizes.sm)
                ],
                if (isAddDatabaseCard) ...[
                  Center(
                      child: DropdownMenu(
                    enabled: _editable.value,
                    controller: controllers["identifier"],
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: "ibdm",
                        label: "ibdm",
                      ),
                      DropdownMenuEntry(
                        value: "siroperie",
                        label: "siroperie",
                      ),
                      DropdownMenuEntry(
                        value: "filtration",
                        label: "filtration",
                      ),
                      DropdownMenuEntry(
                        value: "utilite",
                        label: "utilite",
                      ),
                    ],
                    onSelected: (value) {
                      dbIdentifier = value;
                    },
                    initialSelection: dbIdentifier,
                    label: Text(strings.value.dbIdentifier),
                    width: 400,
                  )),
                  SizedBox(height: AppSizes.sm),
                  IconWithLabelButton(
                    icon: Icons.add,
                    text: strings.value.add,
                    onTap: () {
                      final newDatabase = StandardDatabaseConf.fromJson(
                          _data as Map<String, dynamic>);
                      onAdd?.call(newDatabase, dbIdentifier!);
                    },
                  ),
                ],
                if (!isAddDatabaseCard)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (_editable.value)
                        ShadButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            _editable.value = false;
                          },
                        ),
                      if (onEdit != null)
                        ShadButton.ghost(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Edit provider logic here
                            if (_editable.value) {
                              _editable.value = false;
                              final newDatabase = StandardDatabaseConf.fromJson(
                                  _data as Map<String, dynamic>);
                              onEdit?.call(newDatabase);
                            } else {
                              _editable.value = true;
                            }
                          },
                        ),
                      if (onDelete != null)
                        ShadButton.destructive(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Delete provider logic here
                            final newDatabase = StandardDatabaseConf.fromJson(
                                _data as Map<String, dynamic>);
                            onDelete?.call(newDatabase);
                          },
                        )
                    ],
                  )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class EmailProviderCard extends StatelessWidget {
  final EmailProviderConf? provider;
  final String name;
  final Color? color;
  final Function(EmailProviderConf)? onDelete;
  final Function(EmailProviderConf)? onEdit;
  final Function(EmailProviderConf)? onAdd;
  final bool isAddProviderCard;
  final bool editable;
  EmailProviderCard({
    super.key,
    this.provider,
    required this.name,
    this.color,
    this.onDelete,
    this.onEdit,
    this.isAddProviderCard = false,
    this.editable = false,
    this.onAdd,
  });
  final RxBool _editable = false.obs;
  @override
  Widget build(BuildContext context) {
    if (editable != _editable.value) {
      _editable.value = editable;
    }
    EmailProviderConf _provider = provider ??
        EmailProviderConf(
            host: "localhost",
            port: 587,
            useTls: true,
            user: "username",
            password: "password",
            emailOFSender: "email@example.com");
    final RxMap _data = _provider.toJson().obs;
    final strings = getTranslations(context).obs;
    List<DataRepresentation> data = [
      DataRepresentation(
          name: strings.value.host, code: "HOST", source: _provider.toJson()),
      DataRepresentation(
          name: strings.value.port, code: "PORT", source: _provider.toJson()),
      DataRepresentation(
          name: strings.value.user, code: "USER", source: _provider.toJson()),
      DataRepresentation(
          name: strings.value.password,
          code: "PASSWORD",
          source: _provider.toJson()),
    ];
    final controllers = {};
    for (var d in data) {
      if (d.value != null) {
        controllers[d.code] = TextEditingController(text: d.value.toString());
      }
    }
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DividerWithText(text: name),
              for (var d in data) ...[
                if (d.value != null) ...[
                  Center(
                      child: TextField(
                    enabled: _editable.value,
                    controller: controllers[d.code],
                    onChanged: (v) {
                      _data[d.code] = v;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: d.name,
                    ),
                  )),
                  SizedBox(height: AppSizes.sm)
                ]
              ],
              ShadSwitch(
                value: _data["USE_TLS"] as bool,
                enabled: _editable.value,
                label: Text(strings.value.useTls),
                onChanged: (value) {
                  _data["USE_TLS"] = value;
                },
              ),
              if (isAddProviderCard) ...[
                IconWithLabelButton(
                  icon: Icons.add,
                  text: strings.value.add,
                  onTap: () {
                    final newProvider = EmailProviderConf.fromJson(
                        _data as Map<String, dynamic>);
                    onAdd?.call(newProvider);
                  },
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (!isAddProviderCard) ...[
                    if (_editable.value)
                      ShadButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _editable.value = false;
                        },
                      ),
                    ShadButton.ghost(
                      icon: Icon(_editable.value ? Icons.save : Icons.edit),
                      onPressed: () {
                        if (_editable.value) {
                          _editable.value = false;
                          final newProvider = EmailProviderConf.fromJson(
                              _data as Map<String, dynamic>);
                          onEdit?.call(newProvider);
                        } else {
                          _editable.value = true;
                        }
                      },
                    ),
                    ShadButton.destructive(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        final newProvider = EmailProviderConf.fromJson(
                            _data as Map<String, dynamic>);
                        onDelete?.call(newProvider);
                      },
                    ),
                  ]
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
