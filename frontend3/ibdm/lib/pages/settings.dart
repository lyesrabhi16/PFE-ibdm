import 'package:flutter/material.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/routes.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final localecontroller = Get.find<LocaleController>();

    return AppCustomContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Paramètres",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSettingCard(
                    icon: Icons.email,
                    title: "Email",
                    onTap: () => Get.toNamed(Routes.emailSettings),
                  ),
                  _buildSettingCard(
                    icon: Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    title: Get.isDarkMode ? "Mode clair" : "Mode sombre",
                    trailing: ThemeModeSwitchButton(),
                  ),
                  _buildSettingCard(
                    icon: Icons.language,
                    title: "Langue",
                    subtitle: localecontroller.locale.value.languageCode,
                    trailing: SizedBox(
                      height: 30,
                      width: 60,
                      child: LanguageSwitchButton(),
                    ),
                  ),
                  _buildSettingCard(
                    icon: Icons.help,
                    title: "Aide et Assistance",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
