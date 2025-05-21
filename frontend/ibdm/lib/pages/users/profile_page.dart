import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/circular_progress_indicator_with_text.dart';
import 'package:ibdm/common/widgets/user_form.dart';
import 'package:ibdm/services/api/api_client.dart';
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/services/toasts.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/constants/types.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/user_helpers.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:toastification/toastification.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Function? _getContext;
  BuildContext get getContext => _getContext!.call()!;

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    return AppCustomContainer(
        child: Padding(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: SingleChildScrollView(child: _buildBody())));
  }

  final formKeyAddUser = GlobalKey<FormState>();
  final addUserEmailController = TextEditingController();
  final addUserNameController = TextEditingController();
  final addUserPasswordController = TextEditingController();
  final addUserPhoneController = TextEditingController();
  final addUserSuperiorOptions = <ShadOption<User>>[].obs;
  final addFirstNameController = TextEditingController();
  final addLastNameController = TextEditingController();

  final UserController userController = Get.find<UserController>();
  final _loadedUserSuperiorOptions = false.obs;
  final _editable = false.obs;

  String? email;
  String? username;
  String? password;
  String? phone;
  Role? role;
  User? superior;
  String? firstName;
  String? lastName;
  Uint8List? avatarBytes;
  File? avatarFile;

  _buildBody() {
    final strings = getTranslations(context).obs;
    addUserEmailController.text = userController.user?.email ?? "";
    addUserNameController.text = userController.user?.username ?? "";
    addUserPhoneController.text = userController.user?.phoneNumber ?? "";
    addFirstNameController.text = userController.user?.firstName ?? "";
    addLastNameController.text = userController.user?.lastName ?? "";
    return Container(
      constraints: BoxConstraints(
        minHeight: 600,
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Title
            Text(strings.value.profile,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )).marginAll(AppSizes.md),
            Center(
              child: userController.user == null
                  ? Text("How did you get here?",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          )).marginAll(AppSizes.md)
                  : Container(
                      constraints: BoxConstraints(
                          minWidth: min(400, context.width),
                          maxWidth: min(400, context.width),
                          minHeight: 400),
                      child: Obx(() {
                        final role = userController.roles.firstWhereOrNull(
                            (r) => r.name == userController.user!.role);
                        if (!_loadedUserSuperiorOptions.value) {
                          loadSuperiorsOptions(
                            context,
                            loadedUserSuperiorOptions:
                                _loadedUserSuperiorOptions,
                            ResultSuperiorOptions: addUserSuperiorOptions,
                          );
                          return CircularProgressIndicatorWithText(
                            text: strings.value.loading,
                          );
                        }
                        logger.f(
                            "superior options: ${addUserSuperiorOptions.length}");
                        return Column(
                          children: [
                            UserForm(
                              editable: _editable.value,
                              showPlaceHolders: false,
                              showRole:
                                  userController.user!.role == "ADMIN_SYSTEM" ||
                                      !_editable.value,
                              showSuperior:
                                  userController.user!.role == "ADMIN_SYSTEM" ||
                                      !_editable.value,
                              role: role,
                              user: userController.user,
                              formKeyAddUser: formKeyAddUser,
                              addUserEmailController: addUserEmailController,
                              addUserNameController: addUserNameController,
                              addUserPasswordController:
                                  addUserPasswordController,
                              addUserPhoneController: addUserPhoneController,
                              addUserSuperiorOptions: addUserSuperiorOptions,
                              addFirstNameController: addFirstNameController,
                              addLastNameController: addLastNameController,
                              onAddUser: (email,
                                      username,
                                      password,
                                      phone,
                                      role,
                                      superior,
                                      firstName,
                                      lastName,
                                      avatarBytes,
                                      avatarFile) =>
                                  {
                                this.email = email,
                                this.username = username,
                                this.password = password,
                                this.phone = phone,
                                this.role = role,
                                this.superior = superior,
                                this.firstName = firstName,
                                this.lastName = lastName,
                                this.avatarBytes = avatarBytes,
                                this.avatarFile = avatarFile
                              },
                            ),
                            // Buttons
                            Wrap(
                              children: [
                                ShadButton(
                                  icon: Icon(
                                    _editable.value
                                        ? Icons.edit_off
                                        : Icons.edit,
                                    size: AppSizes.md,
                                  ),
                                  onPressed: () {
                                    _editable.value = !_editable.value;
                                  },
                                  child: Text(strings.value.edit),
                                ).marginOnly(right: AppSizes.sm),
                                ShadButton(
                                  icon: Icon(
                                    Icons.save,
                                    size: AppSizes.md,
                                  ),
                                  onPressed: () => onSaveButtonPressed(
                                    context: context,
                                    user: User(
                                      userId: userController.user!.userId,
                                      firstName: firstName ??
                                          userController.user!.firstName,
                                      lastName: lastName ??
                                          userController.user!.lastName,
                                      username: username ??
                                          userController.user!.username,
                                      email:
                                          email ?? userController.user!.email,
                                      phoneNumber: phone ??
                                          userController.user!.phoneNumber,
                                      role: role?.name ??
                                          userController.user!.role,
                                      superiors: superior != null
                                          ? [
                                              UserSerializerWithSuperiors(
                                                userId: superior!.userId,
                                                email: superior!.email,
                                                superiors: superior!.superiors,
                                                username: superior!.username,
                                                role: superior!.role,
                                              )
                                            ]
                                          : userController.user!.superiors,
                                      avatarUrl: userController.user!.avatarUrl,
                                      subordinates:
                                          userController.user!.subordinates,
                                      userPermissions:
                                          userController.user!.userPermissions,
                                    ),
                                    userAvatarBytes: avatarBytes,
                                    userAvatarFile: avatarFile,
                                    password: password,
                                  ),
                                  child: Text(strings.value.save),
                                ),
                              ],
                            ).marginAll(AppSizes.md),
                          ],
                        );
                      }),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> onSaveButtonPressed({
    required BuildContext context,
    required User user,
    Uint8List? userAvatarBytes,
    File? userAvatarFile,
    String? password,
  }) async {
    final strings = getTranslations(context).obs;
    if (!formKeyAddUser.currentState!.validate()) {
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
          "${strings.value.avatar} : ${userAvatarBytes != null} ${userAvatarFile != null}");
      late final User res;
      if (kIsWeb) {
        res = await api.partialUpdateUserOnWeb(
          id: user.userId,
          avatar: userAvatarBytes,
          avatarFileName: "avatar.jpg",
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
      if (superior != null) {
        if (user.superiors.isEmpty) {
          await api.addSubordinateAndSuperior(
              body: SubordinateAndSuperiorRequest(
                  superior: superior!.userId, subordinate: res.userId));
        } else {
          final res = await api.getSubordinateAndSuperiorId(
              superior: user.superiors.first.userId, subordinate: user.userId);
          await api.partialUpdateSubordinateAndSuperior(
            id: res.id,
            body: PatchedSubordinateAndSuperiorRequest(
                superior: superior!.userId, subordinate: user.userId),
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
          Duration(seconds: 1), () => toastification.dismissById(toast.id));
    } catch (e) {
      logger.e("failed to add user: $e");
      // show error toast
      loadingToastState.value = FutureState.error;
      // close toast after a duration
      Future.delayed(
          Duration(seconds: 3), () => Toastification().dismissById(toast.id));
    }
  }
}
