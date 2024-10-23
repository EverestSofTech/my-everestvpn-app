import 'dart:io';

import 'package:everestvpn/controllers/AuthController.dart';
import 'package:everestvpn/screens/Login_screen/Login.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Forget Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Platform.isMacOS || Platform.isWindows
                ? 450
                : MediaQuery.sizeOf(context).width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Image.asset(
                    'assets/everestlog.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Forget password',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25),
                    child: Text(
                      "Enter your email address below and We'll send you email with instructions on how to change your password",
                      style: TextStyle(
                        // color: Colors.black,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: 55,
                    decoration: ShapeDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor !=
                              kContentColorDarkTheme
                          ? Colors.transparent
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).scaffoldBackgroundColor ==
                                  kContentColorDarkTheme
                              ? Colors.black
                              : Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: TextField(
                      controller: controller.emailController.value,
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.only(left: 10),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Theme.of(context).scaffoldBackgroundColor ==
                                  kContentColorDarkTheme
                              ? Colors.black
                              : Colors.white,
                          size: 30,
                        ),
                        hintText: '   Email Address',
                        hintStyle: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor ==
                                  kContentColorDarkTheme
                              ? Colors.black
                              : Colors.white,
                          fontSize: 15,
                          // fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).scaffoldBackgroundColor ==
                                          kContentColorDarkTheme
                                      ? Colors.black
                                      : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).scaffoldBackgroundColor !=
                                    kContentColorDarkTheme
                                ? Colors.black
                                : Colors.white, // Focused border color
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Obx(() {
                    return controller.isloading.value
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () {
                              controller.sendResetPassword();
                            },
                            child: Container(
                              width: 165,
                              height: 50,
                              padding: const EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor !=
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'SUBMIT',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
