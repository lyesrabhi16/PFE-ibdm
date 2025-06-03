import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/extensions/widget_remove_when.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/screen.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final strings = getTranslations(context).obs;

    return AppCustomContainer(
      child: Obx(() {
        if (!_isHeightEnough()) {
          return SingleChildScrollView(
            child: _build(context, strings),
          );
        }
        return _build(context, strings);
      }),
    );
  }

  Column _build(BuildContext context, Rx<AppLocalizations> strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Logos
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 10),
                Image.asset('assets/images/ifruit_logo.png', height: 50),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Description
        Expanded(
          child: SingleChildScrollView(
            child: _content(),
          ),
        ).removeWhen(!_isHeightEnough()),
        _content().removeWhen(_isHeightEnough()),
        const SizedBox(height: 20),

        //const Spacer(),

        // Footer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Text(
            strings.value.createdBy,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ].nonNulls.toList(),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    String? content,
    Widget? contentWidget,
    required bool isDarkMode,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            contentWidget ??
                Text(
                  content ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    final strings = getTranslations(context).obs;
    final bool isDarkMode = Get.isDarkMode;

    return Column(
      children: [
        _buildCard(
          icon: Icons.info,
          title: strings.value.aProposIBDM,
          content: strings.value.aProposIBDMDescription,
          isDarkMode: isDarkMode,
        ),

        const SizedBox(height: 20),

        // Contact
        _buildCard(
          icon: Icons.contact_mail,
          title: strings.value.contactezNous,
          contentWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ContactItem(icon: Icons.person, text: "RABHI Lyes"),
              const _ContactItem(icon: Icons.phone, text: "+213(0)549267381"),
              const _ContactItem(icon: Icons.email, text: "lyes.rabhi.020@gmail.com"),
              const _ContactItem(
                  icon: Icons.location_on, text: "Ighzer Amokran, Ouzellaguen, Béjaia, Algérie"),
              const SizedBox(height: 10),
              const _ContactItem(icon: Icons.person, text: "KHELOUFI Mounir"),
              const _ContactItem(icon: Icons.phone, text: "+213(0)783965492"),
              const _ContactItem(icon: Icons.email, text: "mounirkheloufi2002@gmail.com"),
              const _ContactItem(
                  icon: Icons.location_on, text: "Beni Maouche, Béjaia, Algérie"),
            ],
          ),
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  bool _isHeightEnough() {
    return context.height >= 826;
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
