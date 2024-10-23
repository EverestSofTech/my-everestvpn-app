import 'dart:typed_data';

import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SplitTunnelScreen extends StatefulWidget {
  const SplitTunnelScreen({super.key});

  @override
  State<SplitTunnelScreen> createState() => _SplitTunnelScreenState();
}

class _SplitTunnelScreenState extends State<SplitTunnelScreen> {
  var controller = Get.put(VpnController());
  bool isInstalled = true;
  String search = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Split Tunneling'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  'Choose which apps can be trusted to bypass\nVPN protection and access the internet directly.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 40,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(68, 181, 179, 179),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  style: TextStyle(
                    fontSize: 13,
                  ),
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
                    border: InputBorder.none,
                    hintText: 'Search apps',
                    hintStyle: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).scaffoldBackgroundColor ==
                                kContentColorLightTheme
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isInstalled = true;
                      });
                    },
                    child: Container(
                      height: 35,
                      width: 90,
                      decoration: BoxDecoration(
                          color: isInstalled
                              ? kSecondaryColor
                              : Theme.of(context).scaffoldBackgroundColor !=
                                      kContentColorLightTheme
                                  ? Color.fromARGB(107, 54, 54, 54)
                                  : const Color.fromARGB(255, 217, 216, 216),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(child: Text('Installed')),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isInstalled = false;
                      });
                    },
                    child: Container(
                      height: 35,
                      width: 90,
                      decoration: BoxDecoration(
                          color: !isInstalled
                              ? kSecondaryColor
                              : Theme.of(context).scaffoldBackgroundColor !=
                                      kContentColorLightTheme
                                  ? Color.fromARGB(107, 54, 54, 54)
                                  : Color.fromARGB(147, 240, 240, 240),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(child: Text('System')),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Obx(() {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.apps.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var snap = controller.apps[index];
                      return search != ''
                          ? !snap.name
                                  .toLowerCase()
                                  .contains(search.toLowerCase())
                              ? Container()
                              : !isInstalled
                                  ? snap.packageName.contains('.')
                                      ? snap.packageName.split('.')[1] ==
                                              'android'
                                          ? AppTile(
                                              name: snap.name,
                                              image: snap.icon,
                                              onSwitchChanged: (value) {
                                                if (controller.packages
                                                    .contains(
                                                        snap.packageName)) {
                                                  controller.packages
                                                      .remove(snap.packageName);
                                                } else {
                                                  controller.packages
                                                      .add(snap.packageName);
                                                }
                                                setState(() {});
                                              },
                                              value: controller.packages
                                                  .contains(snap.packageName),
                                            )
                                          : Container()
                                      : AppTile(
                                          name: snap.name,
                                          image: snap.icon,
                                          onSwitchChanged: (value) {
                                            if (controller.packages
                                                .contains(snap.packageName)) {
                                              controller.packages
                                                  .remove(snap.packageName);
                                            } else {
                                              controller.packages
                                                  .add(snap.packageName);
                                            }
                                            setState(() {});
                                          },
                                          value: controller.packages
                                              .contains(snap.packageName),
                                        )
                                  : AppTile(
                                      name: snap.name,
                                      image: snap.icon,
                                      onSwitchChanged: (value) {
                                        if (controller.packages
                                            .contains(snap.packageName)) {
                                          controller.packages
                                              .remove(snap.packageName);
                                        } else {
                                          controller.packages
                                              .add(snap.packageName);
                                        }
                                        setState(() {});
                                      },
                                      value: controller.packages
                                          .contains(snap.packageName),
                                    )
                          : !isInstalled
                              ? snap.packageName.contains('.')
                                  ? snap.packageName.split('.')[1] == 'android'
                                      ? AppTile(
                                          name: snap.name,
                                          image: snap.icon,
                                          onSwitchChanged: (value) {
                                            if (controller.packages
                                                .contains(snap.packageName)) {
                                              controller.packages
                                                  .remove(snap.packageName);
                                            } else {
                                              controller.packages
                                                  .add(snap.packageName);
                                            }
                                            setState(() {});
                                          },
                                          value: controller.packages
                                              .contains(snap.packageName),
                                        )
                                      : Container()
                                  : AppTile(
                                      name: snap.name,
                                      image: snap.icon,
                                      onSwitchChanged: (value) {
                                        if (controller.packages
                                            .contains(snap.packageName)) {
                                          controller.packages
                                              .remove(snap.packageName);
                                        } else {
                                          controller.packages
                                              .add(snap.packageName);
                                        }
                                        setState(() {});
                                      },
                                      value: controller.packages
                                          .contains(snap.packageName),
                                    )
                              : AppTile(
                                  name: snap.name,
                                  image: snap.icon,
                                  onSwitchChanged: (value) {
                                    if (controller.packages
                                        .contains(snap.packageName)) {
                                      controller.packages
                                          .remove(snap.packageName);
                                    } else {
                                      controller.packages.add(snap.packageName);
                                    }
                                    setState(() {});
                                  },
                                  value: controller.packages
                                      .contains(snap.packageName),
                                );
                    });
              })
            ],
          ),
        ));
  }
}

class AppTile extends StatelessWidget {
  AppTile({
    super.key,
    this.image,
    required this.name,
    required this.onSwitchChanged,
    required this.value,
  });

  Uint8List? image;
  String name;
  bool value;
  final ValueChanged<bool>? onSwitchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor !=
                  kContentColorLightTheme
              ? kContainerLightColor
              : kContainerColor),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: MemoryImage(image!),
              ),
              SizedBox(
                width: 12,
              ),
              Text(
                name.length > 20
                    ? name.replaceRange(17, name.length, '...')
                    : name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onSwitchChanged,
          )
        ],
      ),
    );
  }
}
