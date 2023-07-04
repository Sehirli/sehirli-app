import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:sehirli/pages/home_pages/home_page.dart';
import 'package:sehirli/pages/home_pages/start_page.dart';
import 'package:sehirli/firebase_options.dart';
import 'package:sehirli/utils/authentication.dart';
import 'package:sehirli/injection_container.dart' as sl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await sl.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth auth = FirebaseAuth.instance;

  MobileAds.instance.initialize();

  Get.put(Authentication());

  if (auth.currentUser == null) {
    runApp(const SehirliApp(home: StartPage()));
  } else {
    await auth.currentUser!.reload();

    runApp(const SehirliApp(home: HomePage()));
  }
}

class SehirliApp extends StatelessWidget {
  final Widget home;

  const SehirliApp({
    super.key,
    required this.home
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Şehirli",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.white),
        useMaterial3: true,
        textTheme: GoogleFonts.kanitTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        )
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("tr")
      ],
      home: home,
    );
  }
}
