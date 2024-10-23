import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:everestvpn/models/vpn_status.dart';
import 'package:everestvpn/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class OVPNEngine {
  static const String _methodChannelVpnControl =
      "${AppConstants.pkgName}/vpncontrol";
  static const _eventChannelVpnStage = '${AppConstants.pkgName}/vpnstage';
  static const _eventChannelVpnStatus = '${AppConstants.pkgName}/vpnstatus';
  static const EventChannel _eventChannel = EventChannel(_eventChannelVpnStage);

  static Stream<String> vpnStageSnapshot() => _eventChannel
      .receiveBroadcastStream()
      .map((event) => event == vpnDenied ? vpnDisconnected : event);

  ///Snapshot of VPN Connection Status
  static Stream<VpnStatus?> vpnStatusSnapshot() =>
      EventChannel(_eventChannelVpnStatus)
          .receiveBroadcastStream()
          .map((event) => VpnStatus.fromJson(jsonDecode(event)))
          .cast();

  static Future<VpnStage> initializeIos() async {
    return const MethodChannel(_methodChannelVpnControl)
        .invokeMethod("initialize", {
      "groupIdentifier": 'group.${AppConstants.pkgName}',
      "providerBundleIdentifier": "${AppConstants.bundleIdentifierOVPN}",
      "localizedDescription": AppConstants.appName,
    }).then((value) {
      return OVPNEngine.stage();
    });
  }

  static Future<void> startVpn(
      {String config = '',
      String country = '',
      String password = '',
      List? bypassPackages,
      String username = ''}) async {
    if (Platform.isIOS) await initializeIos();
    const MethodChannel(_methodChannelVpnControl).invokeMethod("start", {
      "config": config,
      "country": country.toString(),
      "username": username,
      "bypass_packages": bypassPackages == null ? [] : bypassPackages,
      "password": password,
    }).then((value) {
      log("start vpn response from native is: $value");
    });
  }

  static Future<void> stopVpn() =>
      const MethodChannel(_methodChannelVpnControl).invokeMethod("stop");
  static Future<void> openKillSwitch() =>
      const MethodChannel(_methodChannelVpnControl).invokeMethod("kill_switch");
  static Future<void> refreshStage() =>
      const MethodChannel(_methodChannelVpnControl).invokeMethod("refresh");
  static Future<void> dispose() =>
      const MethodChannel(_methodChannelVpnControl).invokeMethod("dispose");
  static Future<VpnStage> stage() =>
      const MethodChannel(_methodChannelVpnControl)
          .invokeMethod("stage")
          .then((value) {
        if (value == null || value.isEmpty) {
          return VpnStage.values.byName("disconnected");
        } else {
          return VpnStage.disconnected;
        }
      });
  static Future<bool> isConnected() =>
      stage().then((value) => value == VpnStage.connected);

  static const String vpnConnected = "connected";
  static const String vpnDisconnecting = "disconnecting";
  static const String vpnDisconnected = "disconnected";
  static const String vpnWaitConnection = "wait_connection";
  static const String vpnAuthenticating = "authenticating";
  static const String vpnReconnect = "reconnect";
  static const String vpnNoConnection = "no_connection";
  static const String vpnConnecting = "connecting";
  static const String vpnPrepare = "prepare";
  static const String vpnDenied = "denied";
  static const String vpnExiting = "exiting";
  static const String vpnInvalid = "invalid";
}
