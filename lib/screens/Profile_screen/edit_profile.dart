import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController textEditingController = TextEditingController(
    text: 'demo user',
  );
  TextEditingController textController = TextEditingController(
    text: 'demo@gmail.com',
  );
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  bool isSocial = false;

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                margin: EdgeInsets.symmetric(horizontal: 0),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor !=
                                  kContentColorDarkTheme
                              ? Colors.white
                              : Colors.black,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage('assets/user_profile.png'),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 4,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Account Info',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
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
              readOnly: isSocial,
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
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Change Password',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          isSocial
              ? Container()
              : Column(
                  children: [
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
                        controller: passwordController,
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(left: 10),
                          labelText: 'Password',
                          labelStyle: GoogleFonts.poppins(
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).scaffoldBackgroundColor !=
                                    kContentColorDarkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).scaffoldBackgroundColor !=
                                          kContentColorDarkTheme
                                      ? Colors.white
                                      : kwhite, //
                            ),
                            // borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).scaffoldBackgroundColor !=
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
                        controller: passwordConfirm,
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(left: 10),
                          labelText: 'Confirm Password',
                          labelStyle: GoogleFonts.poppins(
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).scaffoldBackgroundColor !=
                                    kContentColorDarkTheme
                                ? Colors.white
                                : Colors.black, //
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).scaffoldBackgroundColor !=
                                          kContentColorDarkTheme
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            // borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).scaffoldBackgroundColor !=
                                          kContentColorDarkTheme
                                      ? Colors.white
                                      : Colors.black, //
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 50,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  'SAVE',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).scaffoldBackgroundColor !=
                            kContentColorDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
