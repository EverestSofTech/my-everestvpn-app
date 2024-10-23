import 'dart:io';

import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/screens/Get%20Support_screen/getSupport.dart';
import 'package:everestvpn/screens/Redeem_screen/Redeem.dart';
import 'package:everestvpn/screens/Settings/appsettings.dart';
import 'package:everestvpn/screens/Settings/vpnsettings.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var controller = Get.put(VpnController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: Platform.isMacOS || Platform.isWindows ? false : true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              _buildSettingsOption(
                Icons.card_giftcard,
                'Redeem',
                false,
                onTap: () {
                  Get.to(Redeem());
                },
              ),
              Platform.isMacOS || Platform.isWindows
                  ? Container()
                  : _buildSettingsOption(
                      Icons.app_settings_alt,
                      'App Setting',
                      false,
                      onTap: () {
                        Get.to(Appsettings());
                      },
                    ),
              _buildSettingsOption(
                Icons.shield_outlined,
                'VPN Setting',
                false,
                onTap: () {
                  Get.to(Vpnsettings());
                },
              ),
              _buildSettingsOption(
                Icons.info_outline,
                'Get Support',
                false,
                onTap: () {
                  Get.to(Getsupport());
                },
              ),
              _buildSettingsOption(
                null,
                'Share App',
                true,
                onTap: () {
                  // Handle Share App tap action here
                },
                imagePath: 'assets/sharearrow.png',
              ),
              _buildSettingsOption(
                Icons.system_update_alt_rounded,
                'Check for Update',
                false,
                onTap: () {
                  launchUrl(Uri.parse(controller
                      .settingsData.value.settings.first.appRedirectUrl));
                  // Handle Check for Update tap action here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    IconData? icon,
    String title,
    bool isImage, {
    required VoidCallback onTap,
    String? imagePath,
  }) {
    return Column(
      children: [
        ListTile(
          // minTileHeight: 50,
          leading: isImage
              ? Image.asset(
                  imagePath ?? '',
                  width: 24,
                  height: 24,
                  color: Theme.of(context).scaffoldBackgroundColor ==
                          kContentColorDarkTheme
                      ? Colors.black
                      : Colors.white,
                )
              : Icon(
                  icon,
                ), // Icon or image
          title: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
          ),
          onTap: onTap, // Use the onTap callback
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
