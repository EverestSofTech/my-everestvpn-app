import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatelessWidget {
  var controller = Get.put(VpnController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Handle back button press
        //   },
        // ),
        title: Text(
          'About Us',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        // backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  height: 65,
                  color: Theme.of(context).scaffoldBackgroundColor ==
                          kContentColorDarkTheme
                      ? Colors.white
                      : kwhite,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        'assets/everestlog.png', // Replace with your logo path
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 16),
                      Text(
                        controller.settingsData.value.settings.first.appName,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          // color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 3),
              buildInfoTile(Icons.info_outline, 'Version', '1.0.8', context),
              buildInfoTile(
                  Icons.business, 'Company', 'Everest Soft Tech', context),
              buildInfoTile(
                  Icons.email, 'Email', 'support@everestvpn.org', context),
              buildInfoTile(
                  Icons.web, 'Website', 'www.everestvpn.org', context),
              SizedBox(height: 10),
              Card(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor ==
                          kContentColorDarkTheme
                      ? Colors.white
                      : kwhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 16),
                        child: Text(
                          'About',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Everest VPN is your key to a secure and private online journey. '
                          'With robust encryption and user-friendly features, Everest VPN ensures your data remains confidential '
                          'while offering seamless access to geo-restricted content. Whether you\'re safeguarding your connection '
                          'on public Wi-Fi or unlocking new online horizons, Everest VPN is your trusted companion for a reliable '
                          'and protected digital experience. In this app you can watch Reward Video Ads to Unlock Premium Servers. '
                          'Our Lucky Wheel Game adds a touch of fun to your online experience, allowing you to convert your wins into '
                          'real rewards effortlessly. It\'s the perfect blend of entertainment and convenience, making your digital journey '
                          'both enjoyable and rewarding.',
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // backgroundColor: Colors.black,
    );
  }

  Widget buildInfoTile(IconData icon, String title, String subtitle, context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Card(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 0),
          height: 65,
          color: Theme.of(context).scaffoldBackgroundColor ==
                  kContentColorDarkTheme
              ? Colors.white
              : kwhite,
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Icon(
                icon,
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      // color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
