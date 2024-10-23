import 'dart:developer';

import 'package:everestvpn/engines/wireguardApis.dart';
import 'package:everestvpn/utils/constants.dart';
import 'package:get/get.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';
import 'package:wireguard_flutter/wireguard_flutter_platform_interface.dart';

class WireguardEngine {
  var wireguard = WireGuardFlutter.instance;
  // var controller = Get.put(VpnController());
  String config = '';
  VpnStage stage = VpnStage.disconnected;

  Future initWireguard() async {
    await wireguard.initialize(
      interfaceName: 'wg0',
    );
  }

  Future<VpnStage> getStage() async {
    var stages = stage;
    return stages;
  }

  Future<VpnStage> getStages() async {
    var stages = await wireguard.stage();
    if (stages == VpnStage.connected) {
      stage = VpnStage.connected;
    }
    return stages;
  }

  getWireguardConfig(
      {String userId = '',
      String address = '',
      String password = '',
      String configTemplate = ''}) async {
    log(userId);
    config = await WireguardApis()
        .getConfig(userId, address, password, configTemplate)
        .then((value) {
      log("config 2 ==========$value");
      return value!;
    });
  }

  startVPN({
    String userId = '',
    String address = '',
    String ipAddress = '',
    String configs = '',
    String password = '',
    String configTemplate = '',
    bool isConnected = false,
  }) async {
    if (isConnected == false) {
      stage = VpnStage.preparing;
    }
    await initWireguard();
    if (isConnected == false) {
      stage = VpnStage.connecting;
    }
    var conf = await getWireguardConfig(
      userId: userId,
      address: address,
      configTemplate: configTemplate,
      password: password,
    );
    log("config =========> $config");
    if (isConnected == false) {
      stage = VpnStage.connecting;
    }
    log("config =========> $config");
    log("address =========> ${address.split(":")[1].replaceAll('http://', '')}");
    await wireguard
        .startVpn(
      wgQuickConfig: config,
      providerBundleIdentifier: AppConstants.bundleIdentifierWG,
      serverAddress: address.split(":").first.replaceAll('http://', ''),
    )
        .onError((error, stackTrace) {
      log('Error starting VPN: $error');
      startVPN(
        userId: userId,
        address: address,
        ipAddress: ipAddress,
        configTemplate: configs,
        password: password,
      );
    });
    if (isConnected == false) {
      stage = VpnStage.connected;
    }
  }

  Future disconnect(
      {String userId = '',
      String address = '',
      String ipAddress = '',
      String configs = '',
      String password = '',
      String configTemplate = ''}) async {
    stage = VpnStage.disconnecting;
    wireguard.stopVpn().onError((error, stackTrace) async {
      print('Error disconnecting VPN: $error');
      await startVPN(
        userId: userId,
        address: address,
        configs: configs,
        ipAddress: ipAddress,
        password: password,
        configTemplate: configTemplate,
        isConnected: true,
      );
      disconnect(
        userId: userId,
        address: address,
        configs: configs,
        ipAddress: ipAddress,
        password: password,
        configTemplate: configTemplate,
      );
    });
    stage = VpnStage.disconnected;
  }
}
