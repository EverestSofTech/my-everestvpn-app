import 'dart:async'; // Import the Timer class
import 'dart:io';
import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/screens/Login_screen/Login.dart';
import 'package:everestvpn/screens/bottomnavbar/bottombar.dart';
import 'package:everestvpn/screens/desktopTabBar/desktopTabBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var controller = Get.put(VpnController());
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () async {
      await controller.getProtocols();
      await controller.checkLocation();
      await controller.getServers();
      await controller.initGlobe();
      await controller.getSettings();
      if (Platform.isWindows || Platform.isMacOS) {
        Get.offAll(DesktopTabBar());
      } else {
        Get.offAll(BottomNavScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Image.asset('assets/anima.gif'),
              )
            ]));
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: Text("Welcome to the Home Screen!"),
      ),
    );
  }
}
