import 'dart:io';

import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/engines/ovpn_engine.dart';
import 'package:everestvpn/models/protocol_model.dart';
import 'package:everestvpn/screens/private%20browser/browser_screen.dart';
import 'package:everestvpn/screens/split%20tunnel/split_tunnel.dart';
import 'package:everestvpn/screens/subscription/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Vpnsettings extends StatefulWidget {
  const Vpnsettings({super.key});

  @override
  State<Vpnsettings> createState() => _VpnsettingsState();
}

class _VpnsettingsState extends State<Vpnsettings> {
  bool _vpnProtocolSwitch = false;
  bool _unsafeWifiDetectionSwitch = true;
  bool _adblockerSwitch = false;
  bool _autoConnectSwitch = false;
  var controller = Get.put(VpnController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProtocol();
  }

  getProtocol() async {
    if (controller.protocol.value == Protocol.wireguard) {
      _vpnProtocolSwitch = true;
    } else {
      _vpnProtocolSwitch = false;
    }
    await GetStorage.init();
    var box = GetStorage();
    if (box.read('auto') != null) {
      if (box.read('auto') == 'true') {
        _autoConnectSwitch = true;
      } else {
        _autoConnectSwitch = false;
      }
    } else {
      _autoConnectSwitch = false;
    }
    if (box.read('ad') != null) {
      if (box.read('ad') == 'true') {
        _adblockerSwitch = true;
      } else {
        _adblockerSwitch = false;
      }
    } else {
      _adblockerSwitch = false;
    }
    if (box.read('wifi') != null) {
      if (box.read('wifi') == 'true') {
        _unsafeWifiDetectionSwitch = true;
      } else {
        _unsafeWifiDetectionSwitch = false;
      }
    } else {
      _unsafeWifiDetectionSwitch = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APP Settings',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Platform.isWindows || Platform.isMacOS
              ? Container()
              : SettingItem(
                  icon: Icons.vpn_lock,
                  title: 'VPN Protocol',
                  subtitle: 'Switch button to turn on Wireguard',
                  hasSwitch: true,
                  switchValue: _vpnProtocolSwitch,
                  onSwitchChanged: (bool value) {
                    if (controller.isPremium.value == false) {
                      Get.to(SubscriptionScreen());
                    } else {
                      setState(() {
                        _vpnProtocolSwitch = value;
                      });
                      if (_vpnProtocolSwitch) {
                        GetStorage().write('protocol', 'wireguard');
                        controller.protocol.value = Protocol.wireguard;
                      } else {
                        GetStorage().write('protocol', 'openvpn');
                        controller.protocol.value = Protocol.openVPN;
                      }
                      controller.pickRandomServer();
                    }
                  },
                ),
          Platform.isWindows || Platform.isMacOS ? Container() : Divider(),
          SettingItem(
            icon: Icons.wifi,
            title: 'Unsafe Wifi Detection',
            subtitle: 'By enabling this you can detect unsafe wifi',
            hasSwitch: true,
            switchValue: _unsafeWifiDetectionSwitch,
            onSwitchChanged: (bool value) {
              setState(() {
                _unsafeWifiDetectionSwitch = value;
              });
              if (_unsafeWifiDetectionSwitch) {
                GetStorage().write('wifi', 'true');
              } else {
                GetStorage().write('wifi', 'false');
              }
            },
          ),
          Divider(),
          SettingItem(
            icon: Icons.block,
            title: 'Adblocker',
            subtitle: 'Adblocker only works in private browser',
            hasSwitch: true,
            switchValue: _adblockerSwitch,
            onSwitchChanged: (bool value) {
              setState(() {
                _adblockerSwitch = value;
              });
              if (_adblockerSwitch) {
                GetStorage().write('ad', 'true');
              } else {
                GetStorage().write('ad', 'false');
              }
            },
          ),
          Divider(),
          SettingItem(
            icon: Icons.autorenew,
            title: 'Auto Connect',
            subtitle: 'Switch button to turn on auto connect',
            hasSwitch: true,
            switchValue: _autoConnectSwitch,
            onSwitchChanged: (bool value) {
              setState(() {
                _autoConnectSwitch = value;
              });
              setState(() {
                _autoConnectSwitch = value;
              });
              if (_autoConnectSwitch) {
                GetStorage().write('auto', 'true');
              } else {
                GetStorage().write('auto', 'false');
              }
            },
          ),
          Divider(),
          !Platform.isAndroid
              ? Container()
              : SettingItem(
                  icon: Icons.power_settings_new,
                  title: 'Autokill Switch',
                  onTap: () {
                    // Handle tap
                    OVPNEngine.openKillSwitch();
                  },
                  hasTrailingIcon: true,
                ),
          !Platform.isAndroid ? Container() : Divider(),
          !Platform.isAndroid
              ? Container()
              : SettingItem(
                  icon: Icons.alt_route,
                  title: 'Split Tunneling',
                  subtitle: 'Bypass your VPN by selecting the apps',
                  onTap: () {
                    // Handle tap
                    Get.to(SplitTunnelScreen());
                  },
                  hasTrailingIcon: true,
                ),
          Platform.isWindows || Platform.isMacOS
              ? Container()
              : !Platform.isAndroid
                  ? Container()
                  : Divider(),
          Platform.isWindows || Platform.isMacOS
              ? Container()
              : SettingItem(
                  icon: Icons.public,
                  title: 'Private Browser',
                  subtitle: 'Browse anything and hide your identity',
                  onTap: () {
                    Get.to(BrowserScreen());
                    // Handle tap
                  },
                  hasTrailingIcon: true,
                ),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool hasSwitch;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final bool hasTrailingIcon;
  final VoidCallback? onTap;

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.hasSwitch = false,
    this.switchValue,
    this.onSwitchChanged,
    this.hasTrailingIcon = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: Colors.grey),
            )
          : null,
      trailing: hasSwitch
          ? Switch(
              value: switchValue ?? false,
              onChanged: onSwitchChanged,
            )
          : hasTrailingIcon
              ? Icon(Icons.arrow_forward_ios)
              : null,
      onTap: onTap,
    );
  }
}
