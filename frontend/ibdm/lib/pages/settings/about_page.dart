import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.isDarkMode;
    final strings = getTranslations(context).obs;

    return AppCustomContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  const _ContactItem(
                      icon: Icons.phone, text: "+213 123 456 789"),
                  const _ContactItem(icon: Icons.email, text: "ifri@ifri.dz"),
                  const _ContactItem(icon: Icons.web, text: "www.ifri.dz"),
                  _ContactItem(
                      icon: Icons.location_on, text: strings.value.adresse),
                ],
              ),
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 20),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.lightBlueAccent,
              child: Text(
                strings.value.createdBy,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
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
