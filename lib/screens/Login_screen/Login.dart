import 'dart:io';

import 'package:everestvpn/controllers/AuthController.dart';
import 'package:everestvpn/screens/Forget_screen/Forget.dart';
import 'package:everestvpn/screens/Register_screen/Register.dart';
import 'package:everestvpn/screens/Home/home.dart';
import 'package:everestvpn/screens/bottomnavbar/bottombar.dart';
import 'package:everestvpn/screens/desktopTabBar/desktopTabBar.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:everestvpn/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String title = '   Email Address';
  var textcontroller = TextEditingController();
  IconData iconData = Icons.person;
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Platform.isMacOS || Platform.isWindows
                ? 450
                : MediaQuery.sizeOf(context).width,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: Image.asset('assets/evedesign.png'),
                ),
                CustomTextField(
                    textcontroller: controller.emailController.value,
                    iconData: iconData,
                    title: title),
                SizedBox(
                  height: 16,
                ),
                CustomTextFieldP(
                    textcontroller: controller.pass2Controller.value),
                SizedBox(
                  height: 16,
                ),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: controller.isloading.value
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.loginUser();
                                },
                                child: Container(
                                  width: Platform.isMacOS || Platform.isWindows
                                      ? 190
                                      : MediaQuery.sizeOf(context).width * 0.43,
                                  height: 45,
                                  padding: const EdgeInsets.all(8),
                                  decoration: ShapeDecoration(
                                    color: Theme.of(context)
                                                .scaffoldBackgroundColor !=
                                            kContentColorDarkTheme
                                        ? Color.fromARGB(255, 84, 202, 92)
                                        : Color.fromARGB(255, 1, 68, 254),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 2, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'LOGIN',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (Platform.isMacOS || Platform.isWindows) {
                                    Get.to(DesktopTabBar());
                                  } else {
                                    Get.to(BottomNavScreen());
                                  }
                                },
                                child: Container(
                                  width: Platform.isMacOS || Platform.isWindows
                                      ? 190
                                      : MediaQuery.sizeOf(context).width * 0.43,
                                  height: 45,
                                  padding: const EdgeInsets.all(8),
                                  decoration: ShapeDecoration(
                                    color: Color.fromARGB(255, 135, 133, 133),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 2, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SKIP',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                  );
                }),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 25.0),
                      child: GestureDetector(
                          onTap: () {
                            Get.to(Forget());
                          },
                          child: Text(
                            'Forgot Your Password?',
                            style: TextStyle(
                              // color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.30,
                            ),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Platform.isWindows
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          controller.signInWithGoogle(context);
                        },
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          height: 48,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: ShapeDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor !=
                                    kContentColorDarkTheme
                                ? Colors.transparent
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor !=
                                            kContentColorDarkTheme
                                        ? Colors.grey
                                        : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/google_ic.png',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Sign in with Google',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    // color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    // height: 0.09,
                                    letterSpacing: 0.20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account? ',
                      style: TextStyle(
                        // color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(Register());
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          // color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.20,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
