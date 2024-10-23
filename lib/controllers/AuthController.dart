import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:everestvpn/screens/Login_screen/Login.dart';
import 'package:everestvpn/screens/bottomnavbar/bottombar.dart';
import 'package:everestvpn/screens/desktopTabBar/desktopTabBar.dart';
import 'package:everestvpn/screens/verify/verify_screen.dart';
import 'package:everestvpn/services/api_services.dart';
import 'package:everestvpn/theme/theme.dart';
import 'package:everestvpn/utils/constants.dart';
import 'package:everestvpn/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  var emailController = TextEditingController().obs;
  var enameController = TextEditingController().obs;
  var eemailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var usernameController = TextEditingController().obs;
  var user2Controller = TextEditingController().obs;
  var pass2Controller = TextEditingController().obs;
  var codeController = TextEditingController().obs;
  RxInt otpCode = 0.obs;
  RxBool isloading = false.obs;
  RxBool isSocial = false.obs;
  ApiServices api = ApiServices();

  loginUser() async {
    try {
      isloading.value = true;
      var res = await api.userApi(
        url: AppUrls.base_url2,
        body: jsonEncode({
          "method_name": "user_login",
          "email": emailController.value.text,
          "password": pass2Controller.value.text,
          "player_id": "223",
        }),
      );
      log(res.toString());
      isloading.value = false;
      var data = jsonDecode(res);
      var msg = data['ANDROID_REWARDS_APP']['msg'];
      if (data['ANDROID_REWARDS_APP']['success'] == "1") {
        await GetStorage.init();
        var box = await GetStorage();
        box.write('token', data['ANDROID_REWARDS_APP']['user_id']);
        box.write('name', data['ANDROID_REWARDS_APP']['name']);
        box.write('email', data['ANDROID_REWARDS_APP']['email']);
        box.write('isPremium', data['ANDROID_REWARDS_APP']['is_premium']);
        box.write('noAds', data['ANDROID_REWARDS_APP']['no_ads'].toString());
        box.write('password', pass2Controller.value.text);
        box.write('isSocial', 'false');
        showCustomSnackBar(EvaIcons.checkmarkCircle2Outline, "Logging Account",
            msg.toString(), Colors.green);
        if (Platform.isMacOS || Platform.isWindows) {
          Get.offAll(DesktopTabBar(), transition: Transition.rightToLeft);
        } else {
          Get.offAll(BottomNavScreen(), transition: Transition.rightToLeft);
        }
      } else {
        showCustomSnackBar(EvaIcons.alertCircle, "Logging Account Error",
            msg.toString(), Colors.red);
      }
      print("Login done");
    } catch (e) {
      isloading.value = false;
      showCustomSnackBar(EvaIcons.alertCircle, "Logging Account Error",
          e.toString(), Colors.red);
    }
  }

  registerUser() async {
    try {
      isloading.value = true;
      if (codeController.value.text != otpCode.value.toString()) {
        showCustomSnackBar(EvaIcons.alertCircle, "Register Account Error",
            'Invalid Verification Code'.toString(), Colors.red);
      } else {
        final deviceInfoPlugin = DeviceInfoPlugin();
        String id = '';
        if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
          id = iosInfo.identifierForVendor!;
        } else {
          AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
          id = androidInfo.id;
        }

        var res = await api.userApi(
          url: AppUrls.base_url2,
          body: jsonEncode({
            "method_name": "user_register",
            "email": emailController.value.text,
            "password": pass2Controller.value.text,
            "phone": "22382727",
            "type": "normal",
            "user_refrence_code": "",
            "device_id": id,
          }),
        );
        log(res);
        isloading.value = false;
        var data = jsonDecode(res);
        var msg = data['ANDROID_REWARDS_APP']['msg'];
        if (data['ANDROID_REWARDS_APP']['success'] == "1") {
          showCustomSnackBar(EvaIcons.checkmarkCircle2Outline,
              "Register Account", msg.toString(), Colors.green);
          Get.offAll(Login());
        } else {
          showCustomSnackBar(EvaIcons.alertCircle, "Register Account Error",
              msg.toString(), Colors.red);
        }
      }
    } catch (e) {
      isloading.value = false;
      showCustomSnackBar(EvaIcons.alertCircle, "Register Account Error",
          e.toString(), Colors.red);
    }
  }

  GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithGoogle(BuildContext context) async {
    bool res1 = false;
    try {
      final GoogleSignInAccount? googleUser = await this.googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      print(googleAuth!.accessToken.toString());
      final deviceInfoPlugin = DeviceInfoPlugin();
      String id = '';
      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        id = iosInfo.identifierForVendor!;
      } else {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        id = androidInfo.id;
      }

      var res = await api.userApi(
        url: AppUrls.base_url2,
        body: jsonEncode({
          "method_name": "user_register",
          "email": user!.email,
          "name": user.displayName,
          "auth_id": user.uid,
          "type": "google",
          "device_id": id,
        }),
      );
      log(res);
      isloading.value = false;
      var data = jsonDecode(res);
      var msg = data['ANDROID_REWARDS_APP']['msg'];
      if (data['ANDROID_REWARDS_APP']['success'] == "1") {
        await GetStorage.init();
        var box = await GetStorage();
        box.write('token', data['ANDROID_REWARDS_APP']['user_id']);
        box.write('auth', user.uid);
        box.write('name', data['ANDROID_REWARDS_APP']['name']);
        box.write('email', data['ANDROID_REWARDS_APP']['email']);
        box.write('isSocial', 'true');

        box.write(
            'isPremium', data['ANDROID_REWARDS_APP']['is_premium'].toString());
        box.write('noAds', data['ANDROID_REWARDS_APP']['no_ads'].toString());
        showCustomSnackBar(EvaIcons.checkmarkCircle2Outline, "Google Login",
            'Successfully Login'.toString(), Colors.green);
        if (Platform.isMacOS || Platform.isWindows) {
          Get.offAll(DesktopTabBar(), transition: Transition.rightToLeft);
        } else {
          Get.offAll(BottomNavScreen(), transition: Transition.rightToLeft);
        }
      } else {
        showCustomSnackBar(EvaIcons.alertCircle, "Google Login Error",
            msg.toString(), Colors.red);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getOTPStatus() async {
    try {
      var res = await api.userApi(
        url: AppUrls.base_url2,
        body: jsonEncode({
          "method_name": "otp_status",
        }),
      );
      log(res);
    } catch (e) {
      log(e.toString());
    }
  }

  sendOTPandRedirect() async {
    try {
      if (usernameController.value.text.isEmpty ||
          emailController.value.text.isEmpty ||
          passwordController.value.text.isEmpty) {
        showCustomSnackBar(EvaIcons.alertCircle, "Register Account Error",
            'Please Fill All Fields'.toString(), Colors.red);
      } else {
        isloading.value = true;
        int code = math.Random().nextInt(9999);
        log(code.toString());
        otpCode.value = code;
        var res = await api.userApi(
            url: AppUrls.base_url2,
            body: jsonEncode({
              "method_name": "user_register_verify_email",
              "email": emailController.value.text,
              "otp_code": code,
            }));
        log(res);
        isloading.value = false;
        var data = jsonDecode(res);
        var msg = data['ANDROID_REWARDS_APP']['msg'];
        if (data['ANDROID_REWARDS_APP']['success'] == "1") {
          showCustomSnackBar(EvaIcons.checkmarkCircle2Outline,
              "Register Account", msg.toString(), Colors.green);
          Get.to(VerifyScreen());
        } else {
          showCustomSnackBar(EvaIcons.alertCircle, "Register Account Error",
              msg.toString(), Colors.red);
        }
      }
    } catch (e) {
      isloading.value = false;
      showCustomSnackBar(EvaIcons.alertCircle, "Register Account Error",
          e.toString(), Colors.red);
    }
  }

  resendVerifyLink() async {
    try {
      isloading.value = true;
      int code = math.Random().nextInt(9999);
      log(code.toString());
      otpCode.value = code;
      var res = await api.userApi(
          url: AppUrls.base_url2,
          body: jsonEncode({
            "method_name": "user_register_verify_email",
            "email": emailController.value.text,
            "otp_code": code,
          }));
      isloading.value = false;
      var data = jsonDecode(res);
      var msg = data['ANDROID_REWARDS_APP']['msg'];
      if (data['ANDROID_REWARDS_APP']['success'] == "1") {
        showCustomSnackBar(EvaIcons.checkmarkCircle2Outline, "Register Account",
            msg.toString(), Colors.green);
      } else {
        showCustomSnackBar(EvaIcons.alertCircle, "Register Account Error",
            msg.toString(), Colors.red);
      }
    } catch (e) {
      isloading.value = false;
      showCustomSnackBar(EvaIcons.alertCircle, "Register Account Error",
          e.toString(), Colors.red);
    }
  }

  sendResetPassword() async {
    try {
      isloading.value = true;
      var res = await api.userApi(
          url: AppUrls.base_url2,
          body: jsonEncode({
            "method_name": "forgot_pass",
            "email": emailController.value.text,
          }));
      isloading.value = false;
      var data = jsonDecode(res);
      var msg = data['ANDROID_REWARDS_APP']['msg'];
      if (data['ANDROID_REWARDS_APP']['success'] == "1") {
        showCustomSnackBar(EvaIcons.checkmarkCircle2Outline, "Password Reset",
            msg.toString(), Colors.green);
      } else {
        showCustomSnackBar(EvaIcons.alertCircle, "Password Reset Error",
            msg.toString(), Colors.red);
      }
    } catch (e) {
      isloading.value = false;
      showCustomSnackBar(EvaIcons.alertCircle, "Password Reset Error",
          e.toString(), Colors.red);
    }
  }

  deleteAccount() async {
    // delete_user_account
    Get.dialog(
      Center(
        child: SpinKitPulse(
          color: kSecondaryColor,
          size: 50.0,
        ),
      ),
    );
    await GetStorage.init();
    var box = await GetStorage();
    var res = await api.userApi(
        url: AppUrls.base_url2,
        body: jsonEncode({
          "method_name": "delete_user_account",
          "email": box.read('email'),
          "user_id": box.read('token'),
        }));
    GetStorage().remove('token');
    GetStorage().remove('name');
    GetStorage().remove('email');
    googleSignIn.signOut();
    googleSignIn.disconnect();
    Get.back();
    Get.offAll(Login());
  }
}
