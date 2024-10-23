import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/screens/Login_screen/Login.dart';
import 'package:everestvpn/screens/Profile_screen/Profile.dart';
import 'package:everestvpn/screens/Home/home.dart';
import 'package:everestvpn/screens/Settings/settings.dart';
import 'package:everestvpn/screens/selection/vpnselection.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  var controller = Get.put(VpnController());
  bool isLogin = false;

  getLogin() async {
    await GetStorage.init();
    var storage = GetStorage();
    if (storage.read('token') != null) {
      setState(() {
        isLogin = true;
        controller.getUserProfile();
        controller.getProtocols();
      });
    }
    if (storage.read('auto') != null) {
      if (storage.read('auto') == 'true') {
        controller.toggleVPN(false);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLogin();
    controller.getRecent();
    controller.getInstalledApps();
    controller.getDeviceID();
    controller.determinePosition();
    controller.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Home(),
      SelectVpn(),
      Settings(),
      Profile(),
    ];

    return Obx(() {
      return Scaffold(
        body: pages[controller.currentIndex.value],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor ==
                    kContentColorDarkTheme
                ? kContainerLightColor
                : kContainerColor, // Background color of the navigation bar

            boxShadow: Theme.of(context).scaffoldBackgroundColor ==
                    kContentColorDarkTheme
                ? null
                : [
                    BoxShadow(
                      color: Color.fromARGB(15, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(0, -1),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    controller.currentIndex.value = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: controller.currentIndex.value != 0
                          ? 50
                          : MediaQuery.sizeOf(context).width * 0.28,
                      height: 43,
                      decoration: BoxDecoration(
                          color: controller.currentIndex.value != 0
                              ? Colors.transparent
                              : Theme.of(context).scaffoldBackgroundColor ==
                                      kContentColorDarkTheme
                                  ? Color.fromARGB(255, 255, 255, 255)
                                  : kSecondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: controller.currentIndex.value != 0
                          ? Center(
                              child: Image.asset(
                                "assets/home.png",
                                width: 22,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor ==
                                            kContentColorDarkTheme
                                        ? Color.fromARGB(255, 24, 24, 24)
                                        : Colors.white,
                              ),
                            )
                          : Center(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/home.png",
                                  width: 20,
                                  color: Theme.of(context)
                                              .scaffoldBackgroundColor ==
                                          kContentColorDarkTheme
                                      ? Color.fromARGB(255, 98, 98, 98)
                                      : Color(0xFFA4DDED),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Home',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: (Theme.of(context)
                                                  .scaffoldBackgroundColor ==
                                              kContentColorDarkTheme
                                          ? Color.fromARGB(255, 0, 0, 0)
                                          : Color(0xFFA4DDED))),
                                ),
                              ],
                            )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    controller.currentIndex.value = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: controller.currentIndex.value != 1
                          ? 50
                          : MediaQuery.sizeOf(context).width * 0.28,
                      height: 43,
                      decoration: BoxDecoration(
                          color: controller.currentIndex.value != 1
                              ? Colors.transparent
                              : Theme.of(context).scaffoldBackgroundColor ==
                                      kContentColorDarkTheme
                                  ? Color.fromARGB(255, 255, 255, 255)
                                  : kSecondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: controller.currentIndex.value != 1
                          ? Center(
                              child: Icon(
                                EvaIcons.globe2Outline,
                                size: 22,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor ==
                                            kContentColorDarkTheme
                                        ? Color.fromARGB(255, 30, 30, 30)
                                        : Colors.white,
                              ),
                            )
                          : Center(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  EvaIcons.globe2Outline,
                                  color: Theme.of(context)
                                              .scaffoldBackgroundColor ==
                                          kContentColorDarkTheme
                                      ? Color.fromARGB(255, 0, 0, 0)
                                      : Color(0xFFA4DDED),
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Servers',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: (Theme.of(context)
                                                  .scaffoldBackgroundColor ==
                                              kContentColorDarkTheme
                                          ? Color.fromARGB(255, 0, 0, 0)
                                          : Color(0xFFA4DDED))),
                                ),
                              ],
                            )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    controller.currentIndex.value = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: controller.currentIndex.value != 2
                          ? 50
                          : MediaQuery.sizeOf(context).width * 0.28,
                      height: 43,
                      decoration: BoxDecoration(
                          color: controller.currentIndex.value != 2
                              ? Colors.transparent
                              : Theme.of(context).scaffoldBackgroundColor ==
                                      kContentColorDarkTheme
                                  ? Color.fromARGB(255, 255, 255, 255)
                                  : kSecondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: controller.currentIndex.value != 2
                          ? Center(
                              child: Image.asset(
                                "assets/setting.png",
                                width: 22,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor ==
                                            kContentColorDarkTheme
                                        ? Color.fromARGB(255, 30, 30, 30)
                                        : Colors.white,
                              ),
                            )
                          : Center(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/setting.png",
                                  color: Theme.of(context)
                                              .scaffoldBackgroundColor ==
                                          kContentColorDarkTheme
                                      ? Color.fromARGB(255, 0, 0, 0)
                                      : Color(0xFFA4DDED),
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Setting',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: (Theme.of(context)
                                                  .scaffoldBackgroundColor ==
                                              kContentColorDarkTheme
                                          ? Color.fromARGB(255, 0, 0, 0)
                                          : Color(0xFFA4DDED))),
                                ),
                              ],
                            )),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (isLogin) {
                    setState(() {
                      controller.currentIndex.value = 3;
                    });
                  } else {
                    Get.offAll(Login());
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: controller.currentIndex.value != 3
                          ? 50
                          : MediaQuery.sizeOf(context).width * 0.28,
                      height: 43,
                      decoration: BoxDecoration(
                          color: controller.currentIndex.value != 3
                              ? Colors.transparent
                              : Theme.of(context).scaffoldBackgroundColor ==
                                      kContentColorDarkTheme
                                  ? Color.fromARGB(255, 255, 255, 255)
                                  : kSecondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: controller.currentIndex.value != 3
                          ? Center(
                              child: Image.asset(
                                "assets/user.png",
                                width: 22,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor ==
                                            kContentColorDarkTheme
                                        ? Color.fromARGB(255, 26, 26, 26)
                                        : Colors.white,
                              ),
                            )
                          : Center(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/user.png",
                                  color: Theme.of(context)
                                              .scaffoldBackgroundColor ==
                                          kContentColorDarkTheme
                                      ? Color.fromARGB(255, 0, 0, 0)
                                      : Color(0xFFA4DDED),
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: (Theme.of(context)
                                                  .scaffoldBackgroundColor ==
                                              kContentColorDarkTheme
                                          ? Color.fromARGB(255, 0, 0, 0)
                                          : Color(0xFFA4DDED))),
                                ),
                              ],
                            )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
