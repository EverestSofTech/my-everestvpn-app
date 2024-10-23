import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/screens/Home/home.dart';
import 'package:everestvpn/screens/Login_screen/Login.dart';
import 'package:everestvpn/screens/Profile_screen/Profile.dart';
import 'package:everestvpn/screens/Settings/appsettings.dart';
import 'package:everestvpn/screens/Settings/settings.dart';
import 'package:everestvpn/screens/selection/vpnselection.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DesktopTabBar extends StatefulWidget {
  const DesktopTabBar({super.key});

  @override
  State<DesktopTabBar> createState() => _DesktopTabBarState();
}

class _DesktopTabBarState extends State<DesktopTabBar> {
  int currentIndex = 0;
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
    controller.getDeviceID();
    controller.getInstalledApps();
    controller.determinePosition();
    controller.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 0.11,
            height: MediaQuery.sizeOf(context).height,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/everestlog.png',
                      height: 30,
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Text(
                    //   'Everest VPN',
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: currentIndex != 0 ? 50 : 110,
                        height: 43,
                        decoration: BoxDecoration(
                            color: currentIndex != 0
                                ? Colors.transparent
                                : Theme.of(context).scaffoldBackgroundColor ==
                                        kContentColorDarkTheme
                                    ? Color.fromARGB(255, 255, 255, 255)
                                    : kSecondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: currentIndex != 0
                            ? Center(
                                child: Image.asset(
                                  "assets/home.png",
                                  width: 22,
                                  color: Theme.of(context)
                                              .scaffoldBackgroundColor ==
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
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: currentIndex != 1 ? 50 : 110,
                        height: 43,
                        decoration: BoxDecoration(
                            color: currentIndex != 1
                                ? Colors.transparent
                                : Theme.of(context).scaffoldBackgroundColor ==
                                        kContentColorDarkTheme
                                    ? Color.fromARGB(255, 255, 255, 255)
                                    : kSecondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: currentIndex != 1
                            ? Center(
                                child: Image.asset(
                                  "assets/setting.png",
                                  width: 22,
                                  color: Theme.of(context)
                                              .scaffoldBackgroundColor ==
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
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (isLogin) {
                      setState(() {
                        currentIndex = 2;
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
                        width: currentIndex != 2 ? 50 : 110,
                        height: 43,
                        decoration: BoxDecoration(
                            color: currentIndex != 2
                                ? Colors.transparent
                                : Theme.of(context).scaffoldBackgroundColor ==
                                        kContentColorDarkTheme
                                    ? Color.fromARGB(255, 255, 255, 255)
                                    : kSecondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: currentIndex != 2
                            ? Center(
                                child: Image.asset(
                                  "assets/user.png",
                                  width: 22,
                                  color: Theme.of(context)
                                              .scaffoldBackgroundColor ==
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
          Container(
            width: MediaQuery.sizeOf(context).width * 0.89,
            height: MediaQuery.sizeOf(context).height,
            child: currentIndex == 2
                ? ProfileWidget()
                : currentIndex == 1
                    ? SettingWidget()
                    : HomeWidget(),
          ),
        ],
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: MediaQuery.sizeOf(context).width * 0.89, child: Profile()),
      ],
    );
  }
}

class SettingWidget extends StatelessWidget {
  const SettingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: MediaQuery.sizeOf(context).width * 0.45, child: Settings()),
        Container(
            width: MediaQuery.sizeOf(context).width * 0.44,
            child: Appsettings()),
      ],
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: MediaQuery.sizeOf(context).width * 0.45, child: SelectVpn()),
        Container(
            width: MediaQuery.sizeOf(context).width * 0.43, child: Home()),
      ],
    );
  }
}
