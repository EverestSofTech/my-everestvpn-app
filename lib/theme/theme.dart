// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryColor = Color(0XFFF2F2F2);
// const kPrimaryColor = Color.fromARGB(255, 226, 111, 146);
const kSecondaryColor = Color(0xFFA4DDED);
const kContentColorLightTheme = Color.fromARGB(255, 37, 43, 46);
const kContainerColor = Color.fromARGB(255, 28, 31, 34);
const kContainerLightColor = Color.fromARGB(255, 242, 242, 242);
const kContentColorDarkTheme = Color.fromARGB(255, 255, 255, 255);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);
const kback = Colors.white;
const kblack = Color(0xEDEDED);
const kwhite = Color(0xff5E5B5B);
const kDefaultPadding = 20.0;
////
const colorPrimary = Color(0xFFF2F2F2);
const colorPrimaryDark = Color(0xFFEDEDED);
const colorAccent = Color(0xFF684FFF);
const white = Color(0xFF373737);
const offwhite = Color(0xFF5E5B5B);
const offfwhite = Color(0xFF717171);
const buttonBg = Color(0xFF5E5B5B);
const green = Color(0xFF2962FF);
const red = Color(0xFF474C00);
const textViewUpload = Color(0xFF424242);
const textViewAppColor = Color(0xFF684FFF);
const premiumPlan = Color(0xFFA9DFD8);
const borderRadius = Color(0xFFECECEC);
// Private Browser Color
const switchOnOff = Color(0xFFFFFFFF);
const switchOnChecked = Color(0xFF2DD3BD);
const switchTrackOnOff = Color(0xFFAFAFAF);
// Private Browser Color
const browserColor1 = Color(0xFF373737);
const browserBorder1 = Color(0xFFEDEDED);
// Reward Section Color
const rewardSection = Color(0xFF0091EA);
const redeemStatus = Color(0xFF00C853);
const selectedColor = Color(0xFF575757);
// IP Lookup Section Color
const lookup = Color(0xFF575757);
const fullInfo = Color(0xFF575757);
// App Update Section Color
const appUpdateBorder = Color(0xFFACACAC);
const appUpdateTitle = Color(0xFF304FFE);
const appUpdateDesc = Color(0xFF0E0E0E);
const appUpdateButton = Color(0xFF304FFE);
const appLaterButton = Color(0xFF686868);
// Exit Private Browser Section Color
const exitApp = Color(0xFF7306AA);
// Notification Text Section Color
const notificationText = Color(0xFF0C0C0C);
const notificationDesc = Color(0xFF474747);
const notiPrimaryDark = Color(0xFFE1E1E1);
// Before Splash Screen WindowBackground
const beforeSplash = Color(0xFFFFFFFF);
// Bottom Navigation Icon and Text
const iconTextActive = Color(0xFF000000);
const iconTextInactive = Color(0xFF4E4E4E);
const iconTextHover = Color(0xFFDCDCDC);
ThemeData lightThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorDarkTheme,
    appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: kContainerLightColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        titleTextStyle: TextStyle(color: iconTextInactive)),
    iconTheme: IconThemeData(color: kContentColorLightTheme),
    textTheme: GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ).apply(
      bodyColor: iconTextInactive,
    ),
    colorScheme: ColorScheme.dark(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    useMaterial3: false,
    primaryColorLight: kPrimaryColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kback,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData(BuildContext context) {
  // Bydefault flutter provie us light and dark theme
  // we just modify it as our need
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: kContainerColor,
    ),
    iconTheme: IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    useMaterial3: false,
    hoverColor: kPrimaryColor.withOpacity(0.4),
    highlightColor: kPrimaryColor.withOpacity(0.4),
    focusColor: kPrimaryColor.withOpacity(0.4),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(141, 4, 13, 42),
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
