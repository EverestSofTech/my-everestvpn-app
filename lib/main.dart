import 'dart:io';

import 'package:everestvpn/firebase_options.dart';
import 'package:everestvpn/screens/Splash_screen/Splash.dart';
import 'package:everestvpn/screens/Home/Notification/notification.dart';
import 'package:everestvpn/screens/Settings/settings.dart';
import 'package:everestvpn/screens/Settings/vpnsettings.dart';
import 'package:everestvpn/screens/bottomnavbar/bottombar.dart';

import 'package:everestvpn/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> _backgroundMessage(RemoteMessage message) async {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_backgroundMessage);
  if (Platform.isAndroid || Platform.isIOS) {
    MobileAds.instance.initialize();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getTheme() async {
    await GetStorage.init();
    final box = GetStorage();
    if (box.read('dark') != null) {
      if (box.read('dark') == 'true') {
        Get.changeThemeMode(ThemeMode.dark);
      } else {
        Get.changeThemeMode(ThemeMode.light);
      }
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Everest VPN',
      debugShowCheckedModeBanner: false,
      scrollBehavior: CupertinoScrollBehavior(),
      defaultTransition: Transition.rightToLeft,
      darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
