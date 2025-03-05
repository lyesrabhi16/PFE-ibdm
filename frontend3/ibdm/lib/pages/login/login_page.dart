import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Pour vérifier la plateforme
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/language_switch_button.dart';
import 'package:ibdm/common/widgets/theme_mode_switch_button.dart';
import 'package:ibdm/pages/loading_page.dart';
import 'package:ibdm/pages/login/wide_login_page.dart';
import 'package:ibdm/pages/login/small_login_page.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';


void downloadCertificate(BuildContext context) async {
  final url = "https://localhost/ca";
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/ibdmCA.crt";
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Certificat téléchargé : $filePath")),
      );
      print("Fichier enregistré : $filePath");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec du téléchargement du certificat.")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur : $e")),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = !kIsWeb;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return LoadingPage();

    return SafeArea(
      child: Scaffold(
        body: isSmallScreen(context)
            ? SmallLoginPage()
            : NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                  title: Text('IBDM'),
                  snap: true,
                  centerTitle: true,
                  floating: true,
                  pinned: true,
                  leading: ThemeModeSwitchButton(),
                  actions: [
                    LanguageSwitchButton(),
                    SizedBox(width: AppSizes.sm),
                    IconButton(
                    icon: Icon(Icons.card_membership),
                    onPressed: () => downloadCertificate(context),
                    ),
                    SizedBox(width: AppSizes.sm),
                  ],
                  ),
                ],
                body: SizedBox(
                  width: context.width,
                  height: context.height,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: WideLoginPage(),
                  ),
                ),
              ),
      ),
    );
  }
}
