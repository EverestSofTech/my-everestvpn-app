import 'dart:io';

import 'package:everestvpn/controllers/AuthController.dart';
import 'package:everestvpn/screens/Login_screen/Login.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:everestvpn/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthController controller = Get.put(AuthController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getOTPStatus();
  }

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
            child: SingleChildScrollView(
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
                      textcontroller: controller.usernameController.value,
                      iconData: Icons.person,
                      title: 'Name'),
                  SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                      textcontroller: controller.emailController.value,
                      iconData: Icons.email_outlined,
                      title: 'Email Address'),
                  SizedBox(
                    height: 16,
                  ),
                  CustomTextFieldP(
                      textcontroller: controller.passwordController.value),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aready Have an account?',
                        style: TextStyle(
                          // color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.20,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(Login());
                        },
                        child: Text(
                          ' Login',
                          style: GoogleFonts.poppins(
                            // color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.20,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Obx(() {
                    return controller.isloading.value
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () {
                              controller.sendOTPandRedirect();
                            },
                            child: Container(
                              width: 165,
                              height: 45,
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
