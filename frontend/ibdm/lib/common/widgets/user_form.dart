import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/colors.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:ibdm/utils/helpers/validators/app_validators.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_io/io.dart';

class UserForm extends StatelessWidget {
  UserForm({
    super.key,
    required this.formKeyAddUser,
    required this.addUserEmailController,
    required this.addUserNameController,
    required this.addUserPasswordController,
    required this.addUserPhoneController,
    this.editable = true,
    this.role,
    this.user,
    this.showPlaceHolders = true,
    required this.addUserSuperiorOptions,
    required this.addFirstNameController,
    required this.addLastNameController,
    this.onAddUser,
  });
  final User? user;
  static final UserController userController = Get.find();
  final Function(
    String email,
    String username,
    String password,
    String phone,
    Role role,
    User? superior,
    String firstName,
    String lastName,
    Uint8List? avatarBytes,
    File? avatarFile,
  )? onAddUser;

  final bool editable;
  static final RxList<Role> roles = <Role>[].obs;
  Role? role;
  final bool showPlaceHolders;
  // add user form
  final GlobalKey<FormState> formKeyAddUser;
  final TextEditingController addUserEmailController;
  final TextEditingController addUserNameController;
  final TextEditingController addFirstNameController;
  final TextEditingController addLastNameController;
  final TextEditingController addUserPasswordController;
  final TextEditingController addUserPhoneController;
  final RxList<ShadOption<User>> addUserSuperiorOptions;
  List<ShadOption<User>> get _addUserSuperiorOptions => addUserSuperiorOptions
      .where(
        (o) => user == null
            ? true
            : o.value.userId != user!.userId &&
                !user!.subordinates
                    .map((s) => s.userId)
                    .contains(o.value.userId),
      )
      .toList();
  bool get isEditing => user != null && editable == true;

  final Rx<bool> _loaded = false.obs;

  final Rx<bool> _loadedSuperiorInitialValue = false.obs;

  Role? _addUserRole;

  final Rx<bool> _searchAddUserSuperior = false.obs;

  final RxList<ShadOption<User>> _searchAddUserSuperiorOptions =
      <ShadOption<User>>[].obs;

  Rx<Icon> get _addUserPlaceHolderAvatar => Icon(
        LucideIcons.circleUserRound,
        size: AppSizes.xl * 3,
      ).obs;

  final Rx<bool> _addUserAvatarSelected = false.obs;

  File? _addUserAvatarFile;

  // use on non-web
  Uint8List? _addUserAvatarBytes;

  Role? getInitialRoleValue() {
    logger.e(
        "initial Role: ${userController.user?.role} ${userController.roles.map((r) => r.name)}");
    final user_managed_roles = userController.roles
        .firstWhereOrNull((e) => e.name == userController.user!.role)
        ?.managedRoles;
    logger.e("user_managed_roles: $user_managed_roles");
    return user_managed_roles == null || user_managed_roles.isEmpty
        ? null
        : userController.roles
            .firstWhereOrNull((e) => e.name == user_managed_roles.first);
  }

  Iterable<Widget> getRoleOptions(BuildContext context) {
    final _currentUserRole =
        roles.firstWhereOrNull((r) => r.name == userController.user?.role);

    logger.e(
        "current_user_role: $_currentUserRole ${userController.user?.role} $roles");

    return _currentUserRole?.managedRoles.map((roleName) => ShadOption(
              value: roles.firstWhere((r) => r.name == roleName),
              child: Text(
                roleName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.getRoleColorWithRoleValue(roleName),
                    ),
              ),
            )) ??
        <ShadOption>[];
  }

  final Rx<bool> _showUserAvatar = true.obs;

  User? _addUserSuperior;

  Future<void> _load(context) async {
    _loaded.value = false;
    roles.clear();
    final List<Role> localRoles = await userController.getRoles(context);
    roles.addAll(localRoles);
    await getInitialValueOfSuperior();
    _loaded.value = true;
  }

  _valuesChanged() {
    logger.e("values changed: ${addUserEmailController.text}");
    if (_addUserRole == null) {
      return;
    }
    onAddUser?.call(
      addUserEmailController.text,
      addUserNameController.text,
      addUserPasswordController.text,
      addUserPhoneController.text,
      _addUserRole!,
      _addUserSuperior,
      addFirstNameController.text,
      addLastNameController.text,
      _addUserAvatarBytes,
      _addUserAvatarFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;
    logger.d("building user form");
    _addUserRole = getInitialRoleValue();
    final userRole = (role ?? _addUserRole).obs;
    _load(context);
    return Obx(() {
      _addUserRole = userRole.value;
      if (!_loaded.value) {
        return CircularProgressIndicatorWithText(
          text: strings.value.loading,
        );
      }
      logger
          .e("User: $user ${user?.avatarUrl} ${_addUserAvatarSelected.value}");

      _valuesChanged();
      return Form(
        key: formKeyAddUser,
        onChanged: () {
          logger.e("form changed: $_addUserSuperior");
          if (userRole.value == null) {
            logger.e("role is null in user form on changed");
            return;
          }
          _addUserRole = userRole.value;
          printMessage("_addUserSuperior: $_addUserSuperior");
          _valuesChanged();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _addUserAvatarSelected.value
                  ? IconButton(
                      padding: EdgeInsets.all(AppSizes.sm),
                      onPressed: editable
                          ? () {
                              _addUserAvatarSelected.value = false;
                              _addUserAvatarBytes = null;
                            }
                          : null,
                      icon: SizedBox(
                        width: AppSizes.xl * 6,
                        height: AppSizes.xl * 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.memory(
                            getSelectedAvatar()!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  : _showUserAvatar.value && user?.avatarUrl != null
                      ? IconButton(
                          padding: EdgeInsets.all(AppSizes.sm),
                          onPressed: editable
                              ? () {
                                  _addUserAvatarSelected.value = false;
                                  _addUserAvatarBytes = null;
                                  _addUserAvatarFile = null;
                                  _showUserAvatar.value = false;
                                }
                              : null,
                          icon: SizedBox(
                            width: AppSizes.xl * 6,
                            height: AppSizes.xl * 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: user!.avatarUrl!,
                                errorWidget: (context, url, error) => Icon(
                                  LucideIcons.circleUserRound,
                                  size: AppSizes.xl * 3,
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : TextButton(
                          style: Theme.of(context)
                              .textButtonTheme
                              .style
                              ?.copyWith(
                                iconColor: editable
                                    ? null
                                    : WidgetStatePropertyAll(role != null
                                        ? AppColors.getRoleColorWithRole(role!)
                                        : Colors.white),
                              ),
                          onPressed: !editable
                              ? () {}
                              : () async {
                                  Rx<FutureState> openFilePickerToast =
                                      FutureState.loading.obs;
                                  final toast = Toasts.showStatefulToast(
                                    context: context,
                                    message: strings.value.openingFilePicker,
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
                                      _addUserAvatarBytes =
                                          result.files.first.bytes!;
                                      _addUserAvatarSelected.value = true;
                                    } else if (!kIsWeb) {
                                      _addUserAvatarFile =
                                          File(result.files.first.path!);
                                      _addUserAvatarSelected.value = true;
                                    }

                                    _valuesChanged();

                                    openFilePickerToast.value =
                                        FutureState.success;
                                    Future.delayed(
                                        Duration(seconds: 1),
                                        () => Toastification()
                                            .dismissById(toast.id));

                                    // close toast after delay
                                  } else {
                                    // User canceled the picker
                                    openFilePickerToast.value =
                                        FutureState.error;
                                    // close toast after delay
                                    Future.delayed(
                                        Duration(seconds: 1),
                                        () => Toastification()
                                            .dismissById(toast.id));
                                  }
                                },
                          child: _addUserPlaceHolderAvatar.value,
                        ),
              SizedBox(height: AppSizes.sm),
              // email
              ShadInputFormField(
                enabled: editable,
                controller: addUserEmailController,
                keyboardType: TextInputType.emailAddress,
                validator: FormBuilderValidators.email(),
                label: Text(strings.value.email),
                placeholder: Text("account@exmaple.com"),
              ),
              SizedBox(height: AppSizes.sm),
              // password
              ShadInputFormField(
                enabled: editable,
                controller: addUserPasswordController,
                onChanged: (v) {
                  _valuesChanged();
                },
                keyboardType: TextInputType.visiblePassword,
                validator: (v) => AppValidators.customPasswordValidator(v,
                    optional: isEditing),
                obscureText: true,
                label: Text(isEditing
                    ? strings.value.newPassword
                    : strings.value.password),
                placeholder: Text("********"),
              ),
              SizedBox(height: AppSizes.sm),
              // first_name
              ShadInputFormField(
                enabled: editable,
                controller: addFirstNameController,
                keyboardType: TextInputType.name,
                validator: FormBuilderValidators.firstName(),
                label: Text(strings.value.firstName),
                placeholder: showPlaceHolders ? Text("Lyes") : null,
              ),
              // last_name
              ShadInputFormField(
                enabled: editable,
                controller: addLastNameController,
                keyboardType: TextInputType.name,
                validator: FormBuilderValidators.lastName(),
                label: Text(strings.value.lastName),
                placeholder: showPlaceHolders ? Text("Rabhi") : null,
              ),
              // username
              ShadInputFormField(
                enabled: editable,
                controller: addUserNameController,
                keyboardType: TextInputType.name,
                validator: FormBuilderValidators.username(
                  allowDash: true,
                  allowDots: true,
                  allowNumbers: true,
                  allowSpace: true,
                  allowUnderscore: true,
                ),
                label: Text(strings.value.username),
                placeholder: showPlaceHolders ? Text("Lyes Rabhi") : null,
              ),
              SizedBox(height: AppSizes.sm),
              // role
              Container(
                constraints: BoxConstraints(
                  minWidth: context.width,
                ),
                child: ShadSelectFormField<Role>(
                  initialValue: userRole.value,
                  enabled: editable,
                  validator: (v) =>
                      AppValidators.roleSelectionValidator(v?.name),
                  options: getRoleOptions(context),
                  label: Text(strings.value.role),
                  onChanged: (value) {
                    logger.e(
                        "before value: ${value?.name} __userRole: ${userRole.value?.name}");
                    userRole.value = value;
                    _addUserRole = value;
                    _valuesChanged();

                    logger.e(
                        "after value: ${value?.name} __userRole: ${userRole.value?.name}");
                  },
                  selectedOptionBuilder: (context, value) {
                    return Container(
                      constraints: BoxConstraints(
                        minWidth: context.width,
                      ),
                      child: Text(
                          strings.value.selectedRole(value.name.toUpperCase()),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: AppColors.getRoleColorWithRole(value),
                              )),
                    );
                  },
                  placeholder: Text(strings.value.role),
                  shrinkWrap: false,
                ),
              ),
              SizedBox(height: AppSizes.sm),
              // phone number
              ShadInputFormField(
                enabled: editable,
                controller: addUserPhoneController,
                keyboardType: TextInputType.phone,
                validator: (v) => AppValidators.phoneNumberValidator(v),
                label: Text(strings.value.phoneNumber),
                placeholder: showPlaceHolders ? Text("0549267381") : null,
              ),

              SizedBox(height: AppSizes.sm),
              // superior
              Container(
                constraints: BoxConstraints(
                  minWidth: context.width,
                ),
                child: ShadSelectFormField<User>.withSearch(
                  initialValue: _addUserSuperior,
                  enabled: editable,
                  label: Text(strings.value.superior),
                  validator: (value) =>
                      AppValidators.superiorSelectionValidator(
                    user?.userId.toString(),
                    value?.userId.toString(),
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
                      child: Text(strings.value.selectASuperior)),
                  anchor: ShadAnchorAuto(
                    preferBelow: false,
                  ),
                  onChanged: (value) {
                    logger.d("superior value: ${value?.email}");
                    _addUserSuperior = value;
                    _valuesChanged();
                  },
                  selectedOptionBuilder: (context, value) => Container(
                    constraints: BoxConstraints(
                      minWidth: context.width,
                    ),
                    child: Text(
                        strings.value.selectedSuperior(
                            "${value.role} ${getUserName(value)}"),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.getRoleColorWithRoleValue(
                                  value.role),
                            )),
                  ),
                  onSearchChanged: (value) {
                    if (value.isNotEmpty) {
                      _searchAddUserSuperior.value =
                          false; // turn it off to trigger update later
                      _searchAddUserSuperiorOptions.clear();
                      _searchAddUserSuperiorOptions
                          .addAll(_addUserSuperiorOptions.where((o) {
                        if (o.value.username.contains(value)) {
                          return true;
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
        ),
      );
    });
  }

  Future<void> getInitialValueOfSuperior() async {
    _loadedSuperiorInitialValue.value = false;
    if (user == null) {
      _addUserSuperior = userController.user;
      return;
    }

    if (user!.superiors.isEmpty) {
      _addUserSuperior = null;
      return;
    }

    _addUserSuperior = await (await ApiClientInstance.getApiClient())
        .getUser(id: user!.superiors.first.userId);

    _loadedSuperiorInitialValue.value = true;
  }

  Uint8List? getSelectedAvatar() {
    if (_addUserAvatarSelected.value) {
      return kIsWeb
          ? _addUserAvatarBytes!
          : _addUserAvatarFile!.readAsBytesSync();
    }
    return null;
  }
}
