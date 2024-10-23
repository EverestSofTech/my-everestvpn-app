import 'package:everestvpn/screens/Register_screen/Register.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controllers/AuthController.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 120,
            ),
            Center(
              child: Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.20,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.15,
            ),
            Image.asset(
              'assets/otp_icon.png',
              height: 130,
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Enter Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.20,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'We have sent OTP to your email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 40),
              child: PinCodeTextField(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                appContext: context,
                length: 4,
                animationType: AnimationType.fade,
                controller: controller.codeController.value,
                enableActiveFill: true,
                hapticFeedbackTypes: HapticFeedbackTypes.light,
                useHapticFeedback: true,
                onCompleted: (value) {
                  controller.codeController.value.text = value;
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  fieldHeight: 55,
                  fieldWidth: 55,
                  selectedBorderWidth: 4,
                  borderWidth: 4,
                  activeFillColor: colorAccent,
                  inactiveFillColor: colorAccent,
                  selectedFillColor: colorAccent,
                  activeColor: colorAccent,
                  inactiveColor: colorAccent,
                  selectedColor: colorAccent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 110,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.registerUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 29, 92, 209),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'VERIFY',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width - 165,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.emailController.value.clear();
                        controller.usernameController.value.clear();
                        controller.passwordController.value.clear();
                        Get.offAll(Register());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'AGAIN REGISTER',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not Received?',
                  style: TextStyle(
                    // color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.resendVerifyLink();
                  },
                  child: Text(
                    ' Resend Code',
                    style: GoogleFonts.poppins(
                      color: kSecondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.20,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
