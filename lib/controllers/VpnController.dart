import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:everestvpn/engines/ovpn_engine.dart';
import 'package:everestvpn/engines/wireguard_engine.dart';
import 'package:everestvpn/models/locationModel.dart';
import 'package:everestvpn/models/notifcation_model.dart';
import 'package:everestvpn/models/protocol_model.dart';
import 'package:everestvpn/models/serverModel.dart';
import 'package:everestvpn/models/settings_model.dart';
import 'package:everestvpn/services/api_services.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:everestvpn/utils/constants.dart';
import 'package:everestvpn/utils/urls.dart';
import 'package:everestvpn/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/point_connection.dart';
import 'package:flutter_earth_globe/point_connection_style.dart';
import 'package:flutter_earth_globe/sphere_style.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:latlong2/latlong.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class VpnController extends GetxController {
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  RxInt currentIndex = 0.obs;
  RxInt currentServer = 0.obs;
  AnimatedMapController? animatedMapController;
  RxInt currentSubServer = 0.obs;
  RxBool isSubServer = false.obs;
  Rx<VpnStage> stage = VpnStage.disconnected.obs;
  Rx<Protocol> protocol = Protocol.openVPN.obs;
  RxBool isPremium = false.obs;
  RxString premiumDate = "".obs;
  RxString device_id = "".obs;
  RxList<AppInfo> apps = [
    AppInfo(
      name: 'Google Chrome',
      packageName: 'com.android.chrome',
      icon: null,
      versionCode: 1,
      versionName: '1.0',
      builtWith: BuiltWith.flutter,
      installedTimestamp: 9,
    ),
  ].obs;
  RxList indexes = [].obs;
  RxList packages = [].obs;
  Rx<LocationModel> locationModel = LocationModel(
          success: false,
          ip: '',
          type: '',
          country: Country(code: '', name: ''),
          region: '',
          city: '',
          location: Location(lat: '', lon: ''),
          timeZone: '',
          asn: Asn(number: '', name: '', network: ''))
      .obs;
  Rx<LocationModel> locationModel2 = LocationModel(
          success: false,
          ip: '',
          type: '',
          country: Country(code: '', name: ''),
          region: '',
          city: '',
          location: Location(lat: '', lon: ''),
          timeZone: '',
          asn: Asn(number: '', name: '', network: ''))
      .obs;
  WireguardEngine wireguardEngine = WireguardEngine();
  ApiServices apiServices = ApiServices();
  Rx<ServerModel> serverData = ServerModel(status: false, servers: []).obs;
  Rx<ServerModel> recentData = ServerModel(status: false, servers: []).obs;
  Rx<SettingsModel> settingsData =
      SettingsModel(status: false, settings: []).obs;
  Rx<NotificationModel> notifyData =
      NotificationModel(status: false, notifications: []).obs;
  Rx<Timer>? timer;
  Rx<Point> point = Point(coordinates: GlobeCoordinates(0.0, 0.0), id: '').obs;
  Rx<Point> point2 = Point(coordinates: GlobeCoordinates(0.0, 0.0), id: '').obs;
  RxList<Marker> markers = [
    Marker(
      point: LatLng(30, 40),
      width: 80,
      height: 80,
      child: Icon(CupertinoIcons.location_solid),
    ),
  ].obs;
  RxList<Polyline<Object>> polylines = [
    Polyline(
      points: [LatLng(0, 0)],
      color: kSecondaryColor,
    ),
  ].obs;
  RxMap<String, String> speed = {
    'download': "0",
    'upload': "0",
  }.obs;
  Rx<Duration> duration = Duration().obs;
  Rx<FlutterEarthGlobeController> globeController =
      FlutterEarthGlobeController().obs;
  Rx<MapController> mapController = MapController().obs;
  var codeController = TextEditingController().obs;

  getServers() async {
    var data = await apiServices.getAllServers();
    if (data != null) {
      serverData.value = ServerModel.fromJson(data);
      setServer();
    }
  }

  getDeviceID() async {
    var info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var android = await info.androidInfo;
      device_id.value = android.id;
    } else if (Platform.isIOS) {
      var ios = await info.iosInfo;
      device_id.value = ios.identifierForVendor!;
    } else if (Platform.isMacOS) {
      var mac = await info.macOsInfo;
      device_id.value = mac.systemGUID!;
    } else {
      var window = await info.windowsInfo;
      device_id.value = window.productId;
    }
  }

  getInstalledApps() async {
    apps.value = [];
    if (Platform.isIOS || Platform.isAndroid) {
      apps.value = await InstalledApps.getInstalledApps(
        false,
        true,
      );
    }
  }

  redeemCode() async {
    if (codeController.value.text.isNotEmpty) {
      Get.dialog(
        Center(
          child: SpinKitPulse(
            color: kSecondaryColor,
            size: 50.0,
          ),
        ),
      );
      await GetStorage.init();
      var code = codeController.value.text;
      var user_id = GetStorage().read('token');
      var data = await apiServices.userApi(
        url: AppUrls.base_url2,
        body: jsonEncode({
          "method_name": "redeem_code",
          "user_id": user_id,
          "code": code,
        }),
      );
      log(data.toString());

      if (data.length != 8) {
        var res = jsonDecode(data);
        Get.back();
        showCustomSnackBar(Icons.error_outline, 'Redeem Code',
            res['ANDROID_REWARDS_APP']['msg'], Colors.red);
      } else {
        await getPremium();
        Get.back();
        showCustomSnackBar(EvaIcons.checkmarkCircle2Outline, 'Redeem Code',
            "Code successfully redeemed!", Colors.green);
      }
    }
  }

  getRecent() async {
    List<ServerModelServer> servers = [];
    await GetStorage.init();
    if (GetStorage().read('recent') != null) {
      List recent = jsonDecode(GetStorage().read('recent'));
      for (var i = 0; i < serverData.value.servers.length; i++) {
        for (var i1 = 0; i1 < recent.length; i1++) {
          if (serverData.value.servers[i].serverName == recent[i1]) {
            servers.add(serverData.value.servers[i]); // add to servers list
            indexes.add(i);
          }
        }
      }
      recentData.value = ServerModel(
        servers: servers,
        status: true,
      );
    }
  }

  changeLocation(int server, int subServer, bool isSub) async {
    if (isSub) {
      currentSubServer.value = subServer;
      isSubServer.value = true;
      currentServer.value = server;
    } else {
      currentServer.value = server;
      isSubServer.value = false;
    }
    currentIndex.value = 0;
    toggleVPN(true);
  }

  pickRandomServer() async {
    for (var i = 0; i < serverData.value.servers.length; i++) {
      if (protocol.value == Protocol.wireguard) {
        if (serverData.value.servers[i].type == 'wireguard') {
          currentServer.value = i;
          isSubServer.value = false;
          break;
        }
      } else {
        if (serverData.value.servers[i].type != 'wireguard') {
          currentServer.value = i;
          isSubServer.value = false;
          break;
        }
      }
    }
    currentIndex.value = 0;
  }

  setServer() async {
    for (var i = 0; i < serverData.value.servers.length; i++) {
      log(protocol.value.name);
      if (protocol.value == Protocol.wireguard) {
        log(serverData.value.servers[i].type);
        if (serverData.value.servers[i].type == 'wireguard') {
          log(serverData.value.servers[i].type);
          currentServer.value = i;
          break;
        }
      } else {
        if (serverData.value.servers[i].type != 'wireguard') {
          currentServer.value = i;
          break;
        }
      }
    }
  }

  checkLocation() async {
    await GetStorage.init();
    var location = await GetStorage().read('location');
    if (location != null) {
      var locationModels = LocationModel.fromJson(jsonDecode(location));
      locationModel.value = locationModels;
      lat.value = locationModels.location.lat;
      long.value = locationModels.location.lon;
    } else {
      var res = await get(Uri.parse(LOCATION_URL));
      GetStorage().write('location', res.body);
      LocationModel locationModels = LocationModel.fromRawJson(res.body);
      locationModel.value = locationModels;
      lat.value = locationModels.location.lat;
      long.value = locationModels.location.lon;
    }
  }

  checkLocation2() async {
    var res = await get(Uri.parse(LOCATION_URL));
    LocationModel locationModels = LocationModel.fromRawJson(res.body);
    locationModel.value = locationModels;
  }

  getProtocols() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await GetStorage.init();
      if (GetStorage().read('token') != null) {
        await getPremium();
      }
      if (isPremium.value == false) {
        protocol.value = Protocol.openVPN;
        GetStorage().write('protocol', 'ovpn');
      } else {
        if (GetStorage().read('protocol') != null) {
          if (GetStorage().read('protocol') != 'wireguard' ||
              GetStorage().read('protocol') == 'automatic') {
            protocol.value = Protocol.openVPN;
          } else {
            protocol.value = Protocol.wireguard;
          }
        } else {
          protocol.value = Protocol.openVPN;
        }
      }
    } else {
      protocol.value = Protocol.wireguard;
    }
  }

  startWireguard(
      {String userId = '',
      String address = '',
      String ipAddress = '',
      String config = '',
      String password = '',
      String configTemplate = ''}) async {
    await wireguardEngine.startVPN(
      userId: device_id.value,
      address: address,
      ipAddress: ipAddress,
      password: password,
      configs: config,
      configTemplate: configTemplate,
    );
  }

  getStage() async {
    stage.value = await wireguardEngine.getStage().then((value) {
      return value;
    });
  }

  getStages() async {
    stage.value = await wireguardEngine.getStages().then((value) {
      return value;
    });
  }

  initVpns() async {
    await wireguardEngine.initWireguard();
    if (Platform.isIOS) {
      await OVPNEngine.initializeIos();
    }
    startGettingStage();
  }

  disconnectWireguard(
      {String userId = '',
      String address = '',
      String ipAddress = '',
      String password = '',
      String config = '',
      String configTemplate = ''}) async {
    await wireguardEngine.disconnect(
      userId: device_id.value,
      address: address,
      ipAddress: ipAddress,
      configs: config,
      password: password,
      configTemplate: configTemplate,
    );
  }

  listenStage() async {
    OVPNEngine.vpnStageSnapshot().listen((event) {
      stage.value = event == OVPNEngine.vpnPrepare
          ? VpnStage.preparing
          : event == OVPNEngine.vpnWaitConnection
              ? VpnStage.waitingConnection
              : event == OVPNEngine.vpnAuthenticating
                  ? VpnStage.authenticating
                  : event == OVPNEngine.vpnConnecting
                      ? VpnStage.connecting
                      : event == OVPNEngine.vpnConnected
                          ? VpnStage.connected
                          : event == OVPNEngine.vpnDisconnecting
                              ? VpnStage.disconnecting
                              : event == OVPNEngine.vpnDisconnected
                                  ? VpnStage.disconnected
                                  : event == OVPNEngine.vpnExiting
                                      ? VpnStage.exiting
                                      : VpnStage.disconnected;
    });
  }

  startGettingStage() async {
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      if (protocol.value == Protocol.openVPN) {
        listenStage();
      } else {
        getStage();
      }
    }).obs;
  }

  stopTimer() {
    if (timer != null) {
      timer!.value.cancel();
    }
  }

  startOVPN(
      {String config = '',
      String country = '',
      String password = '',
      String username = ''}) async {
    log(username.replaceAll('@namecheap', ''));
    log(packages.toString());
    await OVPNEngine.startVpn(
      config: config,
      country: country,
      password: password,
      bypassPackages: packages,
      username: username.replaceAll('@namecheap', ''),
    );
  }

  stopOVPN() async {
    await OVPNEngine.stopVpn();
  }

  Future determinePosition() async {
    await Future.delayed(Duration(seconds: 1));
    markers.clear();
    polylines.clear();
    markers.add(
      Marker(
        point: LatLng(lat.value, long.value),
        width: 80,
        height: 80,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kSecondaryColor.withOpacity(0.2),
          ),
          child: Center(
            child: CircleAvatar(
              radius: 8,
              backgroundColor: kSecondaryColor,
            ),
          ),
        ),
      ),
    );
    polylines.add(Polyline(points: [
      LatLng(lat.value, long.value),
    ]));
    animatedMapController!.animateTo(
        dest: LatLng(lat.value, long.value),
        zoom: 2,
        duration: Duration(
          milliseconds: 1000,
        ));
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    animatedMapController!.animateTo(
        dest: LatLng(lat.value, long.value),
        zoom: 4,
        duration: Duration(
          milliseconds: 1000,
        ));
    // animatedMapController!.mapController.move(LatLng(lat.value, long.value), 2);
    // mapController.value.m
  }

  routeToPoint() async {
    await Future.delayed(Duration(seconds: 1));
    double serverLat = double.parse(isSubServer.value
        ? serverData.value.servers[currentServer.value]
            .servers[currentSubServer.value].latitude
        : serverData.value.servers[currentServer.value].latitude);
    double serverLong = double.parse(isSubServer.value
        ? serverData.value.servers[currentServer.value]
            .servers[currentSubServer.value].longitude
        : serverData.value.servers[currentServer.value].longitude);
    markers.add(Marker(
        point: LatLng(serverLat, serverLong),
        width: 80,
        height: 80,
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kSecondaryColor.withOpacity(0.2),
            ),
            child: Center(
              child: Image.network(
                serverData.value.servers[currentServer.value].flagUrl,
                height: 25,
              ),
            ))));
    polylines.add(
      Polyline(color: kSecondaryColor, points: [
        LatLng(lat.value, long.value),
        LatLng(serverLat, serverLong),
      ]),
    );
    // animatedMapController!.mapController.move(LatLng(serverLat, serverLong), 2);
    animatedMapController!.animateTo(
        dest: LatLng(serverLat, serverLong),
        zoom: 2,
        duration: Duration(
          milliseconds: 1000,
        ));
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    animatedMapController!.animateTo(
        dest: LatLng(serverLat, serverLong),
        zoom: 4,
        duration: Duration(
          milliseconds: 1000,
        ));
  }

  initGlobe() async {
    globeController.value = FlutterEarthGlobeController(
        rotationSpeed: 0.05,
        zoom: 0.6,
        isZoomEnabled: false,
        sphereStyle: SphereStyle(
            shadowColor:
                Get.theme.scaffoldBackgroundColor != kContentColorDarkTheme
                    ? Color.fromARGB(255, 175, 175, 175)
                    : Color.fromARGB(255, 29, 29, 29),
            shadowBlurSigma:
                Get.theme.scaffoldBackgroundColor != kContentColorDarkTheme
                    ? 10
                    : 1),
        isRotating: false,
        isBackgroundFollowingSphereRotation: true,
        surface: Image.asset(
                Get.theme.scaffoldBackgroundColor != kContentColorDarkTheme
                    ? 'assets/1.1.jpg'
                    : 'assets/1.1.png')
            .image);
  }

  getVPNStage() async {
    await getProtocols();
    if (Platform.isIOS) {
      await OVPNEngine.initializeIos();
    }
    if (protocol == Protocol.openVPN) {
      await listenStage();
    } else {
      await getStages();
    }
    if (stage == VpnStage.connected) {
      await GetStorage.init();
      var box = GetStorage();
      if (box.read('time') != null) {
        DateTime time = DateTime.parse(box.read('time'));
        DateTime date = DateTime.now();
        var durations = date.difference(time);
        duration.value = durations;
      }
    }
  }

  startVPN(
      {String configOVPN = '',
      String country = '',
      String passwordOVPN = '',
      String usernameOVPN = '',
      String userId = '',
      String address = '',
      String ipAddress = '',
      String passwordWG = '',
      String config = '',
      String configTemplate = ''}) async {
    await GetStorage.init();
    var box = GetStorage();
    if (protocol.value == Protocol.openVPN) {
      await startOVPN(
        config: configOVPN,
        username: usernameOVPN,
        password: passwordOVPN,
        country: country,
      );
      GetStorage().write('time', DateTime.now().toString());
      checkLocation2();
      routeToPoint();
    } else if (protocol == Protocol.wireguard) {
      stage.value = VpnStage.connecting;
      await startWireguard(
        userId: userId,
        config: config,
        address: address,
        password: passwordWG,
        configTemplate: configTemplate,
        ipAddress: ipAddress,
      );
      checkLocation2();
      GetStorage().write('time', DateTime.now().toString());
      routeToPoint();
    }
  }

  stopVPN(
      {String configOVPN = '',
      String country = '',
      String passwordOVPN = '',
      String usernameOVPN = '',
      String userId = '',
      String config = '',
      String address = '',
      String ipAddress = '',
      String passwordWG = '',
      String configTemplate = ''}) async {
    await GetStorage.init();
    if (protocol.value == Protocol.openVPN) {
      log('disconnect');
      GetStorage().remove('time');
      log('disconnect');
      duration.value = Duration();
      markers.removeAt(1);
      polylines.clear();
      animatedMapController!.animateTo(
          dest: LatLng(lat.value, long.value),
          zoom: 2,
          duration: Duration(
            milliseconds: 1000,
          ));
      await Future.delayed(
        Duration(milliseconds: 1000),
      );
      animatedMapController!.animateTo(
          dest: LatLng(lat.value, long.value),
          zoom: 4,
          duration: Duration(
            milliseconds: 1000,
          ));
      await stopOVPN();
      checkLocation2();
    } else if (protocol == Protocol.wireguard) {
      GetStorage().remove('time');
      duration.value = Duration();
      markers.removeAt(1);
      polylines.clear();
      animatedMapController!.animateTo(
          dest: LatLng(lat.value, long.value),
          zoom: 2,
          duration: Duration(
            milliseconds: 1000,
          ));
      await Future.delayed(
        Duration(milliseconds: 1000),
      );
      animatedMapController!.animateTo(
          dest: LatLng(lat.value, long.value),
          zoom: 4,
          duration: Duration(
            milliseconds: 1000,
          ));
      await disconnectWireguard(
        userId: userId,
        address: address,
        config: config,
        password: passwordWG,
        configTemplate: configTemplate,
        ipAddress: ipAddress,
      );
      checkLocation2();
    }
  }

  getUserProfile() async {
    await GetStorage.init();
    var storage = GetStorage();
    var id = storage.read('token');
    var res = await apiServices.userApi(
      url: AppUrls.base_url2,
      body: jsonEncode({
        "method_name": "get_user_data",
        "user_id": int.parse(id),
      }),
    );
    log(res);
  }

  getNotifications() async {
    var res = await get(Uri.parse(AppUrls.get_notifications));
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      notifyData.value = NotificationModel.fromJson({
        "status": true,
        "notifications": data,
      }); // notification
    }
  }

  getSettings() async {
    var res = await apiServices.userApi(
      url: AppUrls.base_url2,
      body: jsonEncode({
        "method_name": "app_settings",
      }),
    );
    settingsData.value = SettingsModel.fromRawJson(res);

    if (Platform.isAndroid || Platform.isIOS) {
      bool not = await Permission.notification.isGranted;
      log(not.toString());
      Permission.notification.request();
      initOneSignal();
    }
  }

  initOneSignal() async {
    // if (!await Permission.notification.isGranted) {
    Permission.notification.request();
    // }x
    OneSignal.initialize(settingsData.value.settings.first.onesignalAppId);
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.Debug.setAlertLevel(OSLogLevel.warn);

    OneSignal.LiveActivities.setupDefault();
    OneSignal.Notifications.requestPermission(true);

    OneSignal.User.pushSubscription.addObserver((state) {
      print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());
    });

    OneSignal.User.addObserver((state) {
      var userState = state.jsonRepresentation();
      print('OneSignal user changed: $userState');
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });

    OneSignal.Notifications.addClickListener((event) {
      print('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print(
          'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();
    });

    OneSignal.InAppMessages.addClickListener((event) {});
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
    });
  }

  Future<Map<String, String>> checkNetworkSpeed() async {
    final url = 'https://youtube.com';
    final stopwatch = Stopwatch()..start();
    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        final elapsed = stopwatch.elapsedMilliseconds;
        final speedInKbps =
            ((response.bodyBytes.length / 1024) / (elapsed / 1000)) * 8 / 2.6;
        String download = speedInKbps.toStringAsFixed(1);
        String upload = (speedInKbps + 136.3).toStringAsFixed(1);
        speed.value = {
          'download': download.toString(),
          'upload': upload.toString(),
        };
      }
      return speed;
    } catch (e) {
      log(e.toString());
      return speed;
    }
  }

  toggleVPN(bool isStart) async {
    try {
      if (stage.value == VpnStage.disconnected || isStart) {
        if (stage.value == VpnStage.connected) {
          await stopVPN(
            configOVPN: isSubServer.value
                ? serverData.value.servers[currentServer.value]
                    .servers[currentSubServer.value].ovpnConfiguration!
                : serverData
                        .value.servers[currentServer.value].ovpnConfiguration ??
                    "",
            country: serverData.value.servers[currentServer.value].serverName,
            passwordOVPN: isSubServer.value
                ? serverData.value.servers[currentServer.value]
                    .servers[currentSubServer.value].vpnPassword!
                : serverData.value.servers[currentServer.value].vpnPassword ??
                    "",
            usernameOVPN: isSubServer.value
                ? serverData.value.servers[currentServer.value]
                    .servers[currentSubServer.value].vpnUserName!
                : serverData.value.servers[currentServer.value].vpnUserName ??
                    "",
            address: protocol.value == Protocol.openVPN
                ? ""
                : isSubServer.value
                    ? serverData.value.servers[currentServer.value]
                        .servers[currentSubServer.value].address!
                    : serverData.value.servers[currentServer.value].address ??
                        "",
            config: "",
            passwordWG: protocol.value == Protocol.openVPN
                ? ""
                : isSubServer.value
                    ? serverData.value.servers[currentServer.value]
                        .servers[currentSubServer.value].password!
                    : serverData.value.servers[currentServer.value].password ??
                        "",
          );
        }
        await startVPN(
          configOVPN: isSubServer.value
              ? serverData.value.servers[currentServer.value]
                  .servers[currentSubServer.value].ovpnConfiguration!
              : serverData
                      .value.servers[currentServer.value].ovpnConfiguration ??
                  "",
          country: serverData.value.servers[currentServer.value].serverName,
          passwordOVPN: isSubServer.value
              ? serverData.value.servers[currentServer.value]
                  .servers[currentSubServer.value].vpnPassword!
              : serverData.value.servers[currentServer.value].vpnPassword ?? "",
          usernameOVPN: isSubServer.value
              ? serverData.value.servers[currentServer.value]
                  .servers[currentSubServer.value].vpnUserName!
              : serverData.value.servers[currentServer.value].vpnUserName ?? "",
          address: protocol.value == Protocol.openVPN
              ? ""
              : isSubServer.value
                  ? serverData.value.servers[currentServer.value]
                      .servers[currentSubServer.value].address!
                  : serverData.value.servers[currentServer.value].address ?? "",
          config: "",
          passwordWG: protocol.value == Protocol.openVPN
              ? ""
              : isSubServer.value
                  ? serverData.value.servers[currentServer.value]
                      .servers[currentSubServer.value].password!
                  : serverData.value.servers[currentServer.value].password ??
                      "",
        );
        await GetStorage.init();
        if (GetStorage().read('recent') != null) {
          List recent = jsonDecode(GetStorage().read('recent'));
          if (recent.contains(
              serverData.value.servers[currentServer.value].serverName)) {
            recent.remove(
                serverData.value.servers[currentServer.value].serverName);
          }
          recent.add(serverData.value.servers[currentServer.value].serverName);
          GetStorage().write('recent', jsonEncode(recent));
        } else {
          List recent = [
            serverData.value.servers[currentServer.value].serverName
          ];
          GetStorage().write('recent', jsonEncode(recent));
        }
        log(GetStorage().read('recent'));
        getRecent();
      } else {
        await stopVPN(
          configOVPN: isSubServer.value
              ? serverData.value.servers[currentServer.value]
                  .servers[currentSubServer.value].ovpnConfiguration!
              : serverData
                      .value.servers[currentServer.value].ovpnConfiguration ??
                  "",
          country: serverData.value.servers[currentServer.value].serverName,
          passwordOVPN: isSubServer.value
              ? serverData.value.servers[currentServer.value]
                  .servers[currentSubServer.value].vpnPassword!
              : serverData.value.servers[currentServer.value].vpnPassword ?? "",
          usernameOVPN: isSubServer.value
              ? serverData.value.servers[currentServer.value]
                  .servers[currentSubServer.value].vpnUserName!
              : serverData.value.servers[currentServer.value].vpnUserName ?? "",
          address: protocol.value == Protocol.openVPN
              ? ""
              : isSubServer.value
                  ? serverData.value.servers[currentServer.value]
                      .servers[currentSubServer.value].address!
                  : serverData.value.servers[currentServer.value].address ?? "",
          config: "",
          passwordWG: protocol.value == Protocol.openVPN
              ? ""
              : isSubServer.value
                  ? serverData.value.servers[currentServer.value]
                      .servers[currentSubServer.value].password!
                  : serverData.value.servers[currentServer.value].password ??
                      "",
        );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getPremium() async {
    try {
      await GetStorage.init();
      var box = GetStorage();
      var response = {};
      if (box.read('token') != null) {
        if (box.read('isSocial') == 'true') {
          final deviceInfoPlugin = DeviceInfoPlugin();
          String id = '';
          if (Platform.isIOS) {
            IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
            id = iosInfo.identifierForVendor!;
          } else {
            AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
            id = androidInfo.id;
          }

          var res = await ApiServices().userApi(
            url: AppUrls.base_url2,
            body: jsonEncode({
              "method_name": "user_register",
              "email": box.read('email'),
              "name": box.read('name'),
              "auth_id": box.read('auth'),
              "type": "google",
              "device_id": id,
            }),
          );
          response = jsonDecode(res);
          log("premium is" + response.toString());
          if (response['ANDROID_REWARDS_APP']['is_premium'] == '1') {
            log('premium true');
            isPremium.value = true;
            premiumDate.value = response['ANDROID_REWARDS_APP']['exp'];
          } else {
            isPremium.value = false;
            protocol.value = Protocol.openVPN;
          }
        } else {
          var res = await ApiServices().userApi(
            url: AppUrls.base_url2,
            body: jsonEncode({
              "method_name": "user_login",
              "email": box.read('email'),
              "password": box.read('password'),
              "player_id": "223",
            }),
          );
          response = jsonDecode(res);
          log("premium is" + response.toString());
          if (response['ANDROID_REWARDS_APP']['is_premium'] == '1') {
            log('premium true');
            isPremium.value = true;
            premiumDate.value = response['ANDROID_REWARDS_APP']['exp'];
          } else {
            isPremium.value = false;

            protocol.value = Protocol.openVPN;
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
