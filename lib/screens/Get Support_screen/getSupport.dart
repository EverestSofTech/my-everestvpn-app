import 'package:everestvpn/screens/Get%20Support_screen/About.dart';
import 'package:everestvpn/screens/Get%20Support_screen/Contact.dart';
import 'package:everestvpn/screens/Get%20Support_screen/FAQ.dart';
import 'package:everestvpn/screens/Get%20Support_screen/chat_screen.dart';
import 'package:everestvpn/screens/Get%20Support_screen/privacy%20policy.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Getsupport extends StatefulWidget {
  const Getsupport({super.key});

  @override
  State<Getsupport> createState() => _GetsupportState();
}

class _GetsupportState extends State<Getsupport> {
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
          'Get Support',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).scaffoldBackgroundColor !=
                    kContentColorDarkTheme
                ? Colors.white
                : Colors.black,
          ),
        ),
        // backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.help_outline,
            ),
            title: Text('FAQs', style: TextStyle()),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Get.to(FaqScreen());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.policy,
            ),
            title: Text('Privacy Policy', style: TextStyle()),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Get.to(Privacy());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.contact_phone,
            ),
            title: Text('Contact Us', style: TextStyle()),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Get.to(Contact());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.chat,
            ),
            title: Text('Live Chat', style: TextStyle()),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              // Navigate to Live Chat screen
              Get.to(BotScreen());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
            ),
            title: Text('About Us', style: TextStyle()),
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () {
              Get.to(AboutUsScreen());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).scaffoldBackgroundColor ==
                      kContentColorDarkTheme
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
