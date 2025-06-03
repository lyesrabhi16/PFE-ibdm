import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibdm/app.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  // remove the # from the url
  setPathUrlStrategy();

  GoogleFonts.config.allowRuntimeFetching = false;
  // TODO: add google fonts
  /* LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  }); */
  runApp(MyApp());

  ByteData caCert = await rootBundle.load('assets/certificates/CA.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(caCert.buffer.asUint8List());
}
