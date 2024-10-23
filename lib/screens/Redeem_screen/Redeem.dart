import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Redeem extends StatefulWidget {
  const Redeem({super.key});

  @override
  State<Redeem> createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  var controller = Get.put(VpnController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Redeem',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 22,
          ),
          Image.asset(''),
          Text(
            'Enter Redeem Code',
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 23),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23.0, right: 23),
            child: Text(
              'Enter your redeem code to get premium subscription & remove ads',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 55,
            decoration: ShapeDecoration(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                // side: BorderSide(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: TextField(
              controller: controller.codeController.value,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(left: 10),
                labelText: 'Enter Code',
                labelStyle: GoogleFonts.poppins(
                  // fontWeight: FontWeight.bold,
                  color: Theme.of(context).scaffoldBackgroundColor !=
                          kContentColorDarkTheme
                      ? Colors.white
                      : Colors.black,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor !=
                              kContentColorDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : Colors.black, // Focused border color
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          GestureDetector(
            onTap: () {
              controller.redeemCode();
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 55,
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: Theme.of(context).scaffoldBackgroundColor !=
                        kContentColorDarkTheme
                    ? Color.fromARGB(255, 84, 202, 92)
                    : Color.fromARGB(255, 1, 68, 254),
                shadows: [
                  BoxShadow(
                    blurRadius: 4.0, // Set your desired blur radius
                    color:
                        Colors.black.withOpacity(0.5), // Example shadow color
                    offset: Offset(0, 2), // Example offset
                  ),
                ],
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'REDEEM',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 55,
              padding: const EdgeInsets.all(8),
              decoration: ShapeDecoration(
                color: kback,
                shadows: [
                  BoxShadow(
                    blurRadius: 4.0, // Set your desired blur radius
                    color:
                        Colors.black.withOpacity(0.5), // Example shadow color
                    offset: Offset(0, 2), // Example offset
                  ),
                ],
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'BACK',
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
