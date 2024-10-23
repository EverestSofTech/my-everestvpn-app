import 'dart:io';

import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/screens/Settings/vpnsettings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class Appsettings extends StatefulWidget {
  const Appsettings({super.key});

  @override
  State<Appsettings> createState() => _AppsettingsState();
}

class _AppsettingsState extends State<Appsettings> {
  bool _notiSwitch = false;
  bool _modeSwitch = false;
  var controller = Get.put(VpnController());
  getTheme() async {
    await GetStorage.init();
    final box = GetStorage();
    if (box.read('dark') != null) {
      if (box.read('dark') == 'true') {
        setState(() {
          _modeSwitch = true;
        });
      } else {
        setState(() {
          _modeSwitch = false;
        });
      }
    } else {
      setState(() {
        _modeSwitch = true;
      });
    }

    bool not = await Permission.notification.isGranted;
    setState(() {
      _notiSwitch = not;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            Platform.isMacOS || Platform.isWindows ? false : true,
        title: Text(
          Platform.isMacOS || Platform.isWindows ? '' : 'APP Settings',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SettingItem(
            icon: Icons.notifications_outlined,
            title: 'Enable push Notification',
            hasSwitch: true,
            switchValue: _notiSwitch,
            onSwitchChanged: (bool value) {
              setState(() {
                _notiSwitch = value;
              });
            },
          ),
          SettingItem(
            icon: Icons.nightlight_round_sharp,
            title: 'Appearance Mode',
            hasSwitch: true,
            switchValue: _modeSwitch,
            onSwitchChanged: (bool value) async {
              await GetStorage.init();
              final box = GetStorage();
              if (value == true) {
                Get.changeThemeMode(ThemeMode.dark);
                box.write('dark', 'true');
              } else {
                Get.changeThemeMode(ThemeMode.light);

                box.write('dark', 'false');
              }
              controller.initGlobe();
              setState(() {
                _modeSwitch = value;
              });
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
