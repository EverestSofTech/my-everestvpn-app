import 'dart:ffi';

import 'package:everestvpn/controllers/AuthController.dart';
import 'package:everestvpn/controllers/VpnController.dart';
import 'package:everestvpn/screens/Login_screen/Login.dart';
import 'package:everestvpn/screens/Profile_screen/edit_profile.dart';
import 'package:everestvpn/screens/subscription/subscription_screen.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController textEditingController = TextEditingController(
    text: 'demo user',
  );
  TextEditingController textController = TextEditingController(
    text: 'demo@gmail.com',
  );
  TextEditingController expiryDATE = TextEditingController(
    text: 'demo@gmail.com',
  );
  bool isSocial = false;
  var controller = Get.put(VpnController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNameOrEmail();
  }

  getNameOrEmail() async {
    await GetStorage.init();
    final storage = GetStorage();
    textEditingController.text = storage.read('name');
    textController.text = storage.read('email');
    isSocial = storage.read('isSocial') == 'true' ? true : false;
    expiryDATE.text = controller.premiumDate.value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).scaffoldBackgroundColor !=
                    kContentColorDarkTheme
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 136,
                width: 136,
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor !=
                                  kContentColorDarkTheme
                              ? Colors.white
                              : Colors.black,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: AssetImage('assets/user_profile.png'),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 4,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: !isSocial
                            ? Icon(
                                Icons.email,
                                size: 30,
                                color: Colors.grey,
                              )
                            : Image.asset('assets/google_ic.png'),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(EditProfileScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Container(
                    width: 165,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: kSecondaryColor,
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
                          'EDIT PROFILE',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).scaffoldBackgroundColor ==
                                    kContentColorDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 23),
            height: 55,
            decoration: ShapeDecoration(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                // side: BorderSide(),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: TextField(
              controller: textEditingController,
              readOnly: true,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(left: 10),
                labelText: 'Name',
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
                        : kwhite, //
                  ),
                  // borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : kwhite, // Focused border color
                  ),
                  // borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 23),
            height: 55,
            decoration: ShapeDecoration(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                // side: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: TextField(
              controller: textController,
              readOnly: true,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(left: 10),
                labelText: 'Email Addrees',
                labelStyle: GoogleFonts.poppins(
                  // fontWeight: FontWeight.bold,
                  color: Theme.of(context).scaffoldBackgroundColor !=
                          kContentColorDarkTheme
                      ? Colors.white
                      : Colors.black, //
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                  // borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : Colors.black, //
                  ),
                  // borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Obx(() {
            return controller.isPremium.value
                ? Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    height: 55,
                    decoration: ShapeDecoration(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        // side: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: TextField(
                      controller: expiryDATE,
                      readOnly: true,
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.only(left: 10),
                        labelText: 'Expiry Date',
                        labelStyle: GoogleFonts.poppins(
                          // fontWeight: FontWeight.bold,
                          color: Theme.of(context).scaffoldBackgroundColor !=
                                  kContentColorDarkTheme
                              ? Colors.white
                              : Colors.black, //
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).scaffoldBackgroundColor !=
                                    kContentColorDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          // borderRadius: BorderRadius.circular(10)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).scaffoldBackgroundColor !=
                                    kContentColorDarkTheme
                                ? Colors.white
                                : Colors.black, //
                          ),
                          // borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(SubscriptionScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA9DFD8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/premium.png',
                            width: 40,
                            height: 40,
                          ),
                          Text(
                            'PURCHASE SUBSCRIPTION',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  );
          }),
          SizedBox(
            height: 22,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 23),
            child: ElevatedButton(
              onPressed: () async {
                await GetStorage.init();
                GetStorage().remove('token');
                GetStorage().remove('name');
                GetStorage().remove('email');
                controller.premiumDate.value = '';
                controller.isPremium.value = false;
                AuthController().googleSignIn.signOut();
                AuthController().googleSignIn.disconnect();
                Get.offAll(Login());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'LOGOUT',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 23),
            child: ElevatedButton(
              onPressed: () {
                AuthController().deleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 235, 57, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'DELETE ACCOUNT',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
