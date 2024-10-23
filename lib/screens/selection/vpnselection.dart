// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/models/protocol_model.dart';
import 'package:everestvpn/models/serverModel.dart';
import 'package:everestvpn/screens/Login_screen/Login.dart';
import 'package:everestvpn/screens/subscription/subscription_screen.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectVpn extends StatefulWidget {
  @override
  State<SelectVpn> createState() => _SelectVpnState();
}

class _SelectVpnState extends State<SelectVpn>
    with SingleTickerProviderStateMixin {
  bool istapped = false;
  var controller = Get.put(VpnController());
  String search = '';
  RewardedAd? rewardedAd;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid | Platform.isIOS) {
      loadAd();
    }
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  loadAd() async {
    await Future.delayed(Duration(milliseconds: 500));
    showDialog(
      context: context,
      builder: (context) => Center(
        child: SpinKitPulse(
          color: kSecondaryColor,
          size: 50.0,
        ),
      ),
    );
    await RewardedAd.load(
        adUnitId:
            controller.settingsData.value.settings.first.rewardedVideoAdsId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});
            log('$ad loaded.');
            // Keep a reference to the ad so you can show it later.

            rewardedAd = ad;
            setState(() {});
            Get.back();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
            Get.back();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Platform.isMacOS || Platform.isWindows
            ? Colors.transparent
            : Theme.of(context).scaffoldBackgroundColor ==
                    kContentColorDarkTheme
                ? kContainerLightColor
                : kContainerColor,
        automaticallyImplyLeading:
            Platform.isMacOS || Platform.isWindows ? false : false,
        title: Text(
          Platform.isMacOS || Platform.isWindows
              ? 'Select Server'
              : tabController.index == 1
                  ? "Premium Servers"
                  : 'Watch ads to connect',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              Get.dialog(
                Center(
                  child: SpinKitPulse(
                    color: kSecondaryColor,
                    size: 50.0,
                  ),
                ),
              );
              await controller.getServers();
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.replay_rounded,
                color: Theme.of(context).scaffoldBackgroundColor ==
                        kContentColorDarkTheme
                    ? Colors.grey
                    : kSecondaryColor,
              ),
            ),
          )
        ],
        bottom: TabBar(
          controller: tabController,
          labelStyle: TextStyle(
              fontSize: 15,
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? const Color.fromARGB(255, 69, 69, 69)
                  : Colors.white),
          indicatorColor: Theme.of(context).scaffoldBackgroundColor ==
                  kContentColorDarkTheme
              ? const Color.fromARGB(255, 69, 69, 69)
              : kSecondaryColor,
          indicatorWeight: 4,
          onTap: (value) {
            setState(() {});
          },
          tabs: [
            Tab(
                text: Platform.isMacOS || Platform.isWindows
                    ? "FREE SERVERS"
                    : "REWARD SERVERS"),
            Tab(text: "PREMIUM SERVERS "),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.pickRandomServer();
                    },
                    child: Container(
                      width: Platform.isMacOS || Platform.isWindows
                          ? double.infinity
                          : MediaQuery.sizeOf(context).width - 25,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              Platform.isMacOS || Platform.isWindows ? 8 : 0),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor ==
                                kContentColorDarkTheme
                            ? kContainerLightColor
                            : kContainerColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/autoselect.png',
                                  width: 35,
                                ),
                                SizedBox(
                                    width: 67), // Space between image and text
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Random Server',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Obx(() {
                    return ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: controller.serverData.value.servers.length,
                      itemBuilder: (context, index) {
                        var snap = controller.serverData.value.servers[index];
                        return snap.isFree == false
                            ? Container()
                            : controller.protocol.value == Protocol.openVPN
                                ? snap.type != 'ovpn'
                                    ? Container()
                                    : FreeServerTile(
                                        rewardedAd: rewardedAd,
                                        index: index,
                                        snap: snap,
                                      )
                                : snap.type != 'wireguard'
                                    ? Container()
                                    : FreeServerTile(
                                        rewardedAd: rewardedAd,
                                        index: index,
                                        snap: snap,
                                      );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          Center(
              child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width - 25,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Color.fromARGB(255, 202, 202, 202), width: 1),
                    color: Theme.of(context).scaffoldBackgroundColor ==
                            kContentColorDarkTheme
                        ? kContainerLightColor
                        : kContainerColor,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          search = value;
                        });
                      } else {
                        setState(() {
                          search = '';
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, bottom: 10),
                      hintText: 'Search Country',
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 212, 211, 211),
                          fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: ListView.builder(
                        itemCount: controller.serverData.value.servers.length,
                        itemBuilder: (context, index) {
                          var snap = controller.serverData.value.servers[index];
                          return snap.isFree == true
                              ? Container()
                              : controller.protocol.value == Protocol.openVPN
                                  ? snap.type != 'ovpn'
                                      ? Container()
                                      : search.isNotEmpty
                                          ? snap.serverName
                                                  .toLowerCase()
                                                  .contains(
                                                      search.toLowerCase())
                                              ? ProServerTile(
                                                  index: index,
                                                  snap: snap,
                                                )
                                              : Container()
                                          : ProServerTile(
                                              index: index,
                                              snap: snap,
                                            )
                                  : snap.type != 'wireguard'
                                      ? Container()
                                      : search.isNotEmpty
                                          ? snap.serverName
                                                  .toLowerCase()
                                                  .contains(
                                                      search.toLowerCase())
                                              ? ProServerTile(
                                                  index: index,
                                                  snap: snap,
                                                )
                                              : Container()
                                          : ProServerTile(
                                              index: index,
                                              snap: snap,
                                            );
                        }),
                  );
                }),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class FreeServerTile extends StatefulWidget {
  ServerModelServer snap;
  int index;
  RewardedAd? rewardedAd;
  FreeServerTile({
    super.key,
    required this.index,
    this.rewardedAd,
    required this.snap,
  });

  @override
  State<FreeServerTile> createState() => _FreeServerTileState();
}

class _FreeServerTileState extends State<FreeServerTile> {
  bool isExpand = false;
  var controller = Get.put(VpnController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (widget.snap.servers.isNotEmpty) {
              setState(() {
                isExpand = !isExpand;
              });
            } else {
              if (controller.isPremium.value) {
                controller.changeLocation(widget.index, 0, false);
              } else {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        content: Text(
                          'Watch ad to connect server',
                        ),
                        title: Text(
                          "Rewarded Server",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    color: Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    widget.rewardedAd!.show(
                                        onUserEarnedReward: (ad, v) {
                                      controller.changeLocation(
                                          widget.index, 0, false);
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Watch Ad',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    });
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor ==
                        kContentColorDarkTheme
                    ? kContainerLightColor
                    : kContainerColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          widget.snap.flagUrl,
                          width: 30,
                        ),
                        SizedBox(width: 70), // Space between image and text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.snap.serverName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                widget.snap.servers.isNotEmpty
                                    ? Text(
                                        " (${widget.snap.servers.length.toString()})",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300),
                                      )
                                    : Container(),
                              ],
                            ),
                            widget.snap.servers.isNotEmpty
                                ? Container()
                                : Text(widget.snap.stateName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        widget.snap.servers.isNotEmpty
                            ? Icon(
                                CupertinoIcons.chevron_down,
                                color: Colors.grey,
                                size: 16,
                              )
                            : Container(),
                        SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: Platform.isMacOS || Platform.isWindows
                              ? Container()
                              : Image.asset(
                                  'assets/rewardcircle.png',
                                  scale: 5,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        widget.snap.servers.isEmpty
            ? Container()
            : !isExpand
                ? Container()
                : ListView.builder(
                    itemCount: widget.snap.servers.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var snap = widget.snap.servers[index];
                      return GestureDetector(
                        onTap: () async {
                          if (controller.isPremium.value) {
                            controller.changeLocation(
                                widget.index, index, true);
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    content: Text(
                                      'Watch ad to connect server',
                                    ),
                                    title: Text(
                                      "Rewarded Server",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 100,
                                                color: Colors.transparent,
                                                child: Center(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                                widget.rewardedAd!.show(
                                                    onUserEarnedReward:
                                                        (ad, v) {
                                                  controller.changeLocation(
                                                      widget.index, 0, false);
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: green,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Watch Ad',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 20, right: 20),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width - 40,
                            height: 60,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).scaffoldBackgroundColor ==
                                          kContentColorDarkTheme
                                      ? kContainerLightColor
                                      : kContainerColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    widget.snap.flagUrl,
                                    width: 30,
                                  ),
                                  Text(
                                    snap.stateName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
      ],
    );
  }
}

class ProServerTile extends StatefulWidget {
  ServerModelServer snap;
  int index;
  ProServerTile({
    super.key,
    required this.index,
    required this.snap,
  });

  @override
  State<ProServerTile> createState() => _ProServerTileState();
}

class _ProServerTileState extends State<ProServerTile> {
  bool isExpand = false;
  var controller = Get.put(VpnController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if (widget.snap.servers.isNotEmpty) {
              setState(() {
                isExpand = !isExpand;
              });
            } else {
              if (controller.isPremium.value) {
                controller.changeLocation(widget.index, 0, false);
              } else {
                await GetStorage.init();
                GetStorage box = GetStorage();
                if (box.read('token') != null) {
                  if (Platform.isMacOS || Platform.isWindows) {
                    launchUrl(Uri.parse('https://everestvpn.org/'));
                  } else {
                    Get.to(SubscriptionScreen());
                  }
                } else {
                  Get.offAll(Login());
                }
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: MediaQuery.sizeOf(context).width - 25,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor ==
                        kContentColorDarkTheme
                    ? kContainerLightColor
                    : kContainerColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          widget.snap.flagUrl,
                          width: 30,
                        ),
                        SizedBox(width: 70), // Space between image and text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.snap.serverName,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                                widget.snap.servers.isNotEmpty
                                    ? Text(
                                        " (${widget.snap.servers.length.toString()})",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300),
                                      )
                                    : Container(),
                              ],
                            ),
                            widget.snap.servers.isNotEmpty
                                ? Container()
                                : Text(widget.snap.stateName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        widget.snap.servers.isNotEmpty
                            ? Icon(
                                CupertinoIcons.chevron_down,
                                color: Colors.grey,
                                size: 16,
                              )
                            : Container(),
                        SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            'assets/locked.png',
                            scale: 4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        widget.snap.servers.isEmpty
            ? Container()
            : !isExpand
                ? Container()
                : ListView.builder(
                    itemCount: widget.snap.servers.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var snap = widget.snap.servers[index];
                      return GestureDetector(
                        onTap: () async {
                          if (controller.isPremium.value) {
                            controller.changeLocation(
                                widget.index, index, true);
                          } else {
                            await GetStorage.init();
                            GetStorage box = GetStorage();
                            if (box.read('token') != null) {
                              if (Platform.isMacOS || Platform.isWindows) {
                                launchUrl(Uri.parse('https://everestvpn.org/'));
                              } else {
                                Get.to(SubscriptionScreen());
                              }
                            } else {
                              Get.offAll(Login());
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 20, right: 20),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width - 40,
                            height: 60,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).scaffoldBackgroundColor ==
                                          kContentColorDarkTheme
                                      ? kContainerLightColor
                                      : kContainerColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    widget.snap.flagUrl,
                                    width: 30,
                                  ),
                                  Text(
                                    snap.stateName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: Image.asset(
                                      'assets/locked.png',
                                      scale: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
      ],
    );
  }
}

class Country {
  final String flag;
  final String name;
  final String city;
  final bool isLocked;
  final int? count;
  final String? extraInfo;
  final List<String>? states; // New field to store state names

  Country({
    required this.flag,
    required this.name,
    required this.city,
    required this.isLocked,
    this.count,
    this.extraInfo,
    this.states, // Initialize the states list
  });
}
