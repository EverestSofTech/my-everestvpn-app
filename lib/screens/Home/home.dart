import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/models/protocol_model.dart';
import 'package:everestvpn/models/serverModel.dart';
import 'package:everestvpn/screens/Home/Notification/notification.dart';
import 'package:everestvpn/screens/selection/vpnselection.dart';
import 'package:everestvpn/screens/subscription/subscription_screen.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:everestvpn/widgets/count_down_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool isLoading = false;
  String isConnected = 'disconnected';
  bool isDedicated = false;
  bool serverSelected = false;

  var controller = Get.put(VpnController());

  @override
  void initState() {
    super.initState();
    setTimer();
    controller.initVpns();
    controller.animatedMapController = AnimatedMapController(
        vsync: this,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 3000));
    controller.getVPNStage();
  }

  setTimer() async {
    Timer.periodic(Duration(milliseconds: 500), (v) {
      setState(() {});
    });
  }

  void toggleConnection() async {
    controller.toggleVPN(false);
  }

  Stream chatStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 400));

      var someProduct = controller.stage.value != VpnStage.connected
          ? {"up", ""}
          : await controller.checkNetworkSpeed();
      yield someProduct;
    }
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width < 500
        ? ((MediaQuery.of(context).size.width / 2.8) - 50)
        : 100;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          StreamBuilder(
              stream: chatStream(),
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: () {
                    return _showCustomHeightModalBottomSheet2(context);
                  },
                  icon: Icon(
                    Icons.info_outline,
                    size: 25,
                  ),
                );
              }),
          IconButton(
            onPressed: () {
              controller.checkLocation2();
              return _showCustomHeightModalBottomSheet(context);
            },
            icon: Icon(
              Icons.location_on_outlined,
              size: 25,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(children: [
                IconButton(
                  onPressed: () {
                    Get.to(Noti_Screen());
                  },
                  icon: Icon(
                    CupertinoIcons.bell,
                    size: 25,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 8,
                  child: Obx(() {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),
                      width: 10,
                      height: 10,
                      child: Center(
                          child: Text(
                        controller.notifyData.value.notifications.length
                            .toString(),
                        style: TextStyle(fontSize: 5),
                      )),
                    );
                  }),
                )
              ]),
            ],
          ),
          SizedBox(width: 7),
          GestureDetector(
            onTap: () {
              if (Platform.isMacOS || Platform.isWindows) {
                launchUrl(Uri.parse('https://everestvpn.org/'));
              } else {
                Get.to(SubscriptionScreen());
              }
            },
            child: Image.asset(
              'assets/premium.png',
              width: 35,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height:
                            Platform.isMacOS || Platform.isWindows ? 60 : 95,
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.42,
                    child: FlutterMap(
                      mapController:
                          controller.animatedMapController!.mapController,
                      options: MapOptions(
                          backgroundColor: Color.fromARGB(255, 42, 42, 42),
                          initialZoom: 2,
                          maxZoom: 7,
                          minZoom: 2),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://api.maptiler.com/maps/ch-swisstopo-lbm-dark/{z}/{x}/{y}.png?key=mhOHPVUMeA08VjXdg3Qd',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: controller.markers,
                        ),
                        PolylineLayer(
                          polylines: controller.polylines,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Column(
                        children: [
                          Obx(() {
                            return Text(
                              controller.stage.value.name.capitalizeFirst!,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                          SizedBox(
                            height: 20,
                          ),
                          Obx(() {
                            return CupertinoButton(
                              onPressed: toggleConnection,
                              padding: EdgeInsets.zero,
                              child: vpnButton(controller.stage.value ==
                                          VpnStage.connecting ||
                                      controller.stage.value ==
                                          VpnStage.preparing ||
                                      controller.stage.value ==
                                          VpnStage.authenticating ||
                                      controller.stage.value ==
                                          VpnStage.waitingConnection ||
                                      controller.stage.value ==
                                          VpnStage.disconnecting
                                  ? 'connecting'
                                  : controller.stage.value == VpnStage.connected
                                      ? 'connected'
                                      : 'disconnected'),
                            );
                          }),
                          SizedBox(height: 18),
                          Obx(() {
                            return GestureDetector(
                              onTap: () {
                                controller.currentIndex.value = 1;
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width - 30,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: kContainerColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        controller
                                            .serverData
                                            .value
                                            .servers[
                                                controller.currentServer.value]
                                            .flagUrl,
                                        width: 30),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller
                                              .serverData
                                              .value
                                              .servers[controller
                                                  .currentServer.value]
                                              .serverName,
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 218, 218, 218),
                                          ),
                                        ),
                                        Text(
                                          controller.isSubServer.value
                                              ? controller
                                                  .serverData
                                                  .value
                                                  .servers[controller
                                                      .currentServer.value]
                                                  .servers[controller
                                                      .currentSubServer.value]
                                                  .stateName
                                              : controller
                                                  .serverData
                                                  .value
                                                  .servers[controller
                                                      .currentServer.value]
                                                  .stateName,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Color.fromARGB(
                                                255, 205, 205, 205),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Image.asset(
                                    //   'assets/buttonarrow.png',
                                    //   height: 30,
                                    // ),
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                "Recent Connection",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Obx(() {
                            return Container(
                              height: 46,
                              width: double.infinity,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                removeBottom: true,
                                removeLeft: true,
                                removeRight: true,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: controller
                                        .recentData.value.servers.length,
                                    itemBuilder: (context, index) {
                                      return controller.protocol.value ==
                                              Protocol.wireguard
                                          ? controller.recentData.value
                                                      .servers[index].type ==
                                                  'wireguard'
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      for (var i = 0;
                                                          i <
                                                              controller
                                                                  .serverData
                                                                  .value
                                                                  .servers
                                                                  .length;
                                                          i++) {
                                                        if (controller
                                                                .serverData
                                                                .value
                                                                .servers[i]
                                                                .serverName ==
                                                            controller
                                                                .recentData
                                                                .value
                                                                .servers[index]
                                                                .serverName) {
                                                          controller.changeLocation(
                                                              i,
                                                              0,
                                                              controller
                                                                  .recentData
                                                                  .value
                                                                  .servers[
                                                                      index]
                                                                  .servers
                                                                  .isNotEmpty);
                                                          break;
                                                        }
                                                      }
                                                    },
                                                    child: RecentWidget(
                                                      snap: controller
                                                          .recentData
                                                          .value
                                                          .servers[index],
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                          : controller.recentData.value
                                                      .servers[index].type !=
                                                  'wireguard'
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      for (var i = 0;
                                                          i <
                                                              controller
                                                                  .serverData
                                                                  .value
                                                                  .servers
                                                                  .length;
                                                          i++) {
                                                        if (controller
                                                                .serverData
                                                                .value
                                                                .servers[i]
                                                                .serverName ==
                                                            controller
                                                                .recentData
                                                                .value
                                                                .servers[index]
                                                                .serverName) {
                                                          controller.changeLocation(
                                                              i,
                                                              0,
                                                              controller
                                                                  .recentData
                                                                  .value
                                                                  .servers[
                                                                      index]
                                                                  .servers
                                                                  .isNotEmpty);
                                                          break;
                                                        }
                                                      }
                                                    },
                                                    child: RecentWidget(
                                                      snap: controller
                                                          .recentData
                                                          .value
                                                          .servers[index],
                                                    ),
                                                  ),
                                                )
                                              : Container();
                                    }),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget vpnButton(String stage) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        color: stage == 'connecting'
            ? Color.fromARGB(255, 68, 53, 29)
            : stage != 'connected'
                ? Theme.of(context).scaffoldBackgroundColor ==
                        kContentColorDarkTheme
                    ? Color.fromARGB(255, 184, 184, 184)
                    : Color.fromARGB(255, 25, 27, 29)
                : Color.fromARGB(255, 59, 98, 45),
        borderRadius: BorderRadius.circular(80),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            left: stage == 'connecting'
                ? 60
                : stage == 'connected'
                    ? 60
                    : 0,
            top: 0,
            child: GestureDetector(
              child: Container(
                width: 60,
                height: 60,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: stage == 'connecting'
                      ? const Color.fromARGB(255, 255, 163, 26)
                      : stage == 'connected'
                          ? Colors.green
                          : Theme.of(context).scaffoldBackgroundColor ==
                                  kContentColorDarkTheme
                              ? Color.fromARGB(255, 255, 255, 255)
                              : Color.fromARGB(255, 51, 54, 56),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.67,
                        color: stage == 'connecting'
                            ? Colors.orange
                            : stage == 'connected'
                                ? Colors.green
                                : Theme.of(context).scaffoldBackgroundColor ==
                                        kContentColorDarkTheme
                                    ? Color.fromARGB(255, 218, 217, 217)
                                    : Color.fromARGB(255, 43, 46, 48)),
                    borderRadius: BorderRadius.circular(833.33),
                  ),
                ),
                child: Center(
                    child: stage == 'connecting'
                        ? CircularProgressIndicator()
                        : Icon(
                            stage == 'connected'
                                ? Icons.stop_rounded
                                : Icons.power_settings_new_outlined,
                            color: stage == 'connecting'
                                ? Colors.white
                                : stage == 'connected'
                                    ? Colors.white
                                    : Theme.of(context)
                                                .scaffoldBackgroundColor ==
                                            kContentColorDarkTheme
                                        ? Color.fromARGB(255, 0, 0, 0)
                                        : Colors.white,
                            size: 35,
                          )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(VpnController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Row(
            children: [
              Image.asset(
                'assets/serverip.png',
                width: 30,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  Text(
                    'IP Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 117, 117, 117),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    controller.locationModel.value.ip,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 117, 117, 117),
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        Container(
          height: 30,
          width: 2,
          color: Colors.grey,
        ),
        SizedBox(
          child: Row(
            children: [
              Image.asset(
                'assets/downloads.png',
                width: 25,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Download',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 117, 117, 117),
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        color: const Color.fromARGB(255, 117, 117, 117),
                        size: 10,
                      ),
                      Text(
                        controller.stage.value == VpnStage.connected
                            ? controller.speed['download'].toString() + " KB"
                            : '0 KB',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 117, 117, 117),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        Container(
          height: 30,
          width: 2,
          color: Colors.grey,
        ),
        SizedBox(
          child: Row(
            children: [
              Image.asset(
                'assets/upload.png',
                width: 25,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload',
                    style: TextStyle(
                      fontSize: 10,
                      color: const Color.fromARGB(255, 117, 117, 117),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: const Color.fromARGB(255, 117, 117, 117),
                        size: 10,
                      ),
                      Text(
                        controller.stage.value == VpnStage.connected
                            ? controller.speed['upload'].toString() + " KB"
                            : '0 KB',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 117, 117, 117),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RecentWidget extends StatelessWidget {
  ServerModelServer snap;
  RecentWidget({
    super.key,
    required this.snap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor ==
                    kContentColorDarkTheme
                ? Color.fromARGB(255, 246, 246, 246)
                : kContainerColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                width: 0.5,
                color: Theme.of(context).scaffoldBackgroundColor ==
                        kContentColorDarkTheme
                    ? Color.fromARGB(255, 172, 172, 172)
                    : Colors.white)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(snap.flagUrl, width: 30),
                SizedBox(
                  width: 5,
                ),
                Text(
                  snap.serverName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ));
  }
}

void _showAlertDialog(BuildContext context) {
  // set up the buttons

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: SizedBox(
      height: 200,
      child: Column(
        children: [
          Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          _buildPaymentOption(context, 'assets/paypal.png', Colors.white, 40),
          SizedBox(height: 20),
          _buildPaymentOption(
              context, 'assets/google_play_logo.png', Colors.white, 40),
        ],
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget _buildPaymentOption(
    BuildContext context, String imagePath, Color bgColor, double height) {
  return Container(
    width: MediaQuery.of(context).size.width - 100,
    height: 50,
    // Subtracting padding
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(30),
    ),

    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        imagePath,
        height: height,
        fit: BoxFit.contain,
        scale: 4,
      ),
    ),
  );
}

void _showCustomHeightModalBottomSheet(BuildContext context) {
  var controller = Get.put(VpnController());
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor:
        Colors.transparent, // Allows the bottom sheet to take more height
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5, // Initial height (50% of the screen height)
        minChildSize: 0.3, // Minimum height when dragged down (30%)
        maxChildSize: 0.9, // Maximum height when dragged up (90%)
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor ==
                    kContentColorDarkTheme
                ? kContainerLightColor
                : kContainerColor,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Full Location Information',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TimeZoneTile(
                        imagePath: 'assets/9746676.png', // Path to your image
                        title: 'Country',
                        subtitle:
                            '${controller.locationModel.value.country.name.toString()}'
                                .replaceAll('null', ''),
                      ),
                      TimeZoneTile(
                        imagePath: 'assets/earth.png', // Path to your image
                        title: 'Shortcut',
                        subtitle:
                            '${controller.locationModel.value.country.code.toString()}'
                                .replaceAll('null', ''),
                      ),
                      TimeZoneTile(
                        imagePath: 'assets/state.png', // Path to your image
                        title: 'State',
                        subtitle:
                            '${controller.locationModel.value.region.toString()}'
                                .replaceAll('null', ''),
                      ),
                      TimeZoneTile(
                        imagePath: 'assets/city.png', // Path to your image
                        title: 'City',
                        subtitle: '${controller.locationModel.value.city}'
                            .replaceAll('null', ''),
                      ),
                      TimeZoneTile(
                        imagePath: 'assets/isp.png', // Path to your image
                        title: 'ISP',
                        subtitle:
                            '${controller.locationModel.value.asn.network}'
                                .replaceAll('null', ''),
                      ),
                      TimeZoneTile(
                        imagePath: 'assets/ipaddress.png', // Path to your image
                        title: 'IP Address',
                        subtitle: '${controller.locationModel.value.ip}'
                            .replaceAll('null', ''),
                      ),
                      TimeZoneTile(
                        imagePath: 'assets/timezone.png', // Path to your image
                        title: 'Time Zone',
                        subtitle: '${controller.locationModel.value.timeZone}'
                            .replaceAll('null', ''),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void _showCustomHeightModalBottomSheet2(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor:
        Colors.transparent, // Allows the bottom sheet to take more height
    builder: (BuildContext context) {
      return Container(
        height: 150,
        color:
            Theme.of(context).scaffoldBackgroundColor == kContentColorDarkTheme
                ? kContainerLightColor
                : kContainerColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Connection Information',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 20,
                ),
                DetailWidget(),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class TimeZoneTile extends StatelessWidget {
  final String imagePath; // Path to the image
  final String title;
  final String subtitle;

  const TimeZoneTile({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          // minTileHeight: 20,
          leading: Image.asset(
            imagePath,
            width: 30,
            height: 30,
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: switchOnChecked),
          ),
        ),
        Divider(
          color: Colors.white,
        )
      ],
    );
  }
}
