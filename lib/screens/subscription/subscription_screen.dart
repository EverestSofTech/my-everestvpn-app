import 'dart:io';

import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex = 0;
  String price1 = "7.99";
  String price2 = "17.97";
  String price3 = "29.94";
  String price4 = "35.88";
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
        centerTitle: true,
        title: Text(
          'Subscription',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Premium Plan',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).scaffoldBackgroundColor ==
                                kContentColorDarkTheme
                            ? const Color.fromARGB(255, 21, 21, 21)
                            : kSecondaryColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Benifits Includes:',
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            FeatureTile(
              image: 'assets/unlock.png',
              title: 'Unlock all',
              subtitle: 'Access all premium servers & wireguard protocol',
            ),
            SizedBox(
              height: 14,
            ),
            FeatureTile(
              image: 'assets/top.png',
              title: 'Top speed',
              subtitle: 'Get upto 40 mbps plus speed',
            ),
            SizedBox(
              height: 14,
            ),
            FeatureTile(
              image: 'assets/notice.png',
              title: 'No ads',
              subtitle: 'Get rid of all banner & video ads',
            ),
            SizedBox(
              height: 14,
            ),
            FeatureTile(
              image: 'assets/secure.png',
              title: 'Secure your device',
              subtitle: 'Hide yourself, unlock any websites & apps',
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PriceWidget(
                  isSelected: selectedIndex == 0,
                  price: '\$$price1',
                  title: '1 Month',
                  istrail: true,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                PriceWidget(
                  isSelected: selectedIndex == 1,
                  price: '\$$price2',
                  title: '3 Month',
                  istrail: false,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PriceWidget(
                  isSelected: selectedIndex == 2,
                  price: '\$$price3',
                  title: '6 Month',
                  istrail: false,
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
                PriceWidget(
                  isSelected: selectedIndex == 3,
                  price: '\$$price4',
                  title: 'Yearly',
                  istrail: false,
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 22,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Center(
                child: Text(
                  selectedIndex == 0
                      ? "You'll be charged when the 7-day trail ends, and the subscription will begin at that time."
                      : "You will be billed every ${selectedIndex == 1 ? "3 Month" : selectedIndex == 2 ? "6 Month" : "Yearly"} upon the completion of your subscription.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: 55,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    rewardSection,
                    exitApp,
                  ])),
              child: Center(
                child: Text(
                  selectedIndex == 0
                      ? "Get a 7-Day Free Trail $price1\$"
                      : "Go with Premium only ${selectedIndex == 1 ? price2 : selectedIndex == 2 ? price3 : price4}\$",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                launchUrl(
                    Uri.parse('https://everestvpn.org/subscription-policy/'));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Cancel your subscription at any time. Please refer to our privacy policy for more information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PriceWidget extends StatelessWidget {
  PriceWidget({
    super.key,
    required this.isSelected,
    required this.istrail,
    required this.price,
    required this.title,
    required this.onTap,
  });
  bool isSelected;
  String title;
  String price;
  bool istrail;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: 150,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(isSelected
                    ? 'assets/pplann.png'
                    : 'assets/pricebplan.png'))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              price,
              style: GoogleFonts.poppins(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: kSecondaryColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            !istrail
                ? Container()
                : Text(
                    '7 days free trail',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  FeatureTile({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });
  String image;
  String title;
  String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 40,
            child: Column(
              children: [
                Image.asset(
                  image,
                  height: 27,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
