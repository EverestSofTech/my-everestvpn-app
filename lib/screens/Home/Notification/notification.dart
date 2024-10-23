import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Noti_Screen extends StatefulWidget {
  const Noti_Screen({super.key});

  @override
  State<Noti_Screen> createState() => _Noti_ScreenState();
}

class _Noti_ScreenState extends State<Noti_Screen> {
  var controller = Get.put(VpnController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        // backgroundColor: Color(0xFF373737), // Custom dark color
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: controller.notifyData.value.notifications.length,
                    itemBuilder: (context, index) {
                      var snap =
                          controller.notifyData.value.notifications[index];
                      return Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          CustomListTile(
                            imagePath: snap.image,
                            title: snap.title,
                            subtitle: snap.body,
                            onTap: () async {
                              // Handle the tap event here
                              if (await canLaunchUrl(Uri.parse(snap.link))) {
                                await launchUrl(Uri.parse(snap.link));
                              }
                              print('ListTile tapped');
                            },
                          ),
                        ],
                      );
                    });
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  CustomListTile({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, right: 1),
      child: Container(
        width: MediaQuery.sizeOf(context).width - 8,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor ==
                  kContentColorDarkTheme
              ? kContainerLightColor
              : kContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        child: ListTile(
          leading: CachedNetworkImage(
            imageUrl: imagePath,
            errorWidget: (context, url, error) => Icon(Icons.error),
            placeholder: (context, url) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: SpinKitPulse(
                color: kSecondaryColor,
                size: 50.0,
              ),
            ),
            width: 80,
            height: 60,
          ),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.grey),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
