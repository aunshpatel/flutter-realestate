import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

String apiLinkConstant = 'https://realestate-vgcw.onrender.com/api';

String currentUserID = '', token = '', JWT_SECRET = 'realestate-project', newUsername='',newEmail='',newPassword='',newProfilePic='';

var listingWithDiscount = [], listingForRent = [], listingForSale = [];

const kWhiteColor = Colors.white;

const kBlackColor = Colors.black;

const kThemeBlueColor = Color(0XFF003366);

const kDarkTextColor = Color(0XFF191D2E);

const kSilverTextColor = Color(0XFF97A2B6);

const kLightTitleColor = Color(0XFF697489);

const kDarkTitleColor = Color(0XFF3A4355);

const kContinueWithGoogleButton = Color(0XFF9E2121);

const kBackgroundColor = Color(0XFFE3E6EF);

const kBlueAccent = Colors.blueAccent;

const kHomePagePropertyTitle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
);

const kRegularText = TextStyle(
  fontWeight: FontWeight.normal,
  fontSize: 15,
);

const kWhiteBoldRegularText = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15,
  color: Colors.white
);

const kRegularTextStrike = TextStyle(
  fontWeight: FontWeight.normal,
  decoration: TextDecoration.lineThrough,
  fontSize: 15,
);

const kSideMenuLightTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: kLightTitleColor,
);

const kSideMenuDarkTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: kDarkTitleColor,
);

const kLightBoldTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: kLightTitleColor,
);

const kWhiteBoldTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: kWhiteColor,
);

const kDarkBoldTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: kDarkTitleColor,
);

const kLightSemiBoldTextStyle = TextStyle(
    color: kLightTitleColor,
    fontSize: 16,
    fontWeight:FontWeight.w500
);

const kSemiBoldRegularStyle = TextStyle(
    fontSize: 16,
    fontWeight:FontWeight.w500
);

const kDarkSemiBoldTextStyle = TextStyle(
    color: kDarkTitleColor,
    fontSize: 16,
    fontWeight:FontWeight.w500
);

const kUnderlineDarkSemiBoldTextStyle = TextStyle(
    color: kDarkTitleColor,
    decoration: TextDecoration.underline,
    fontSize: 16,
    fontWeight:FontWeight.w500
);

const kBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
);

var kEnabledBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: kLightTitleColor, width: 1.0),
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
);

var kFocusedBorder = const OutlineInputBorder(
  borderSide: BorderSide(color: kDarkTitleColor, width: 2.0),
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
);

bool automaticLogin = false;

bool isRememberMeDisabled = false;

bool isLoggedIn = false;

class HeroLogo extends StatelessWidget {
  HeroLogo({required this.height,required this.image, required this.tag});

  final double height;
  final String image, tag;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:tag,
      child: Container(
        height: height,
        child: Image.asset(image),
      ),
    );
  }
}

InputDecoration emailInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: kThemeBlueColor),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: kBorder,
    enabledBorder: kEnabledBorder,
    focusedBorder: kFocusedBorder,
  );
}

InputDecoration passwordInputDecoration(String hintText, bool _passwordVisible, void toggle()){
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: kDarkTitleColor),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: kBorder,
    enabledBorder: kEnabledBorder,
    focusedBorder: kFocusedBorder,
    suffixIcon: IconButton(
      icon: Icon(
        _passwordVisible ? Icons.visibility : Icons.visibility_off,
        color: kDarkTitleColor,
      ),
      onPressed: toggle,
    ),
  );
}

InputDecoration listingInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: kThemeBlueColor),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    enabledBorder: kEnabledBorder,
    focusedBorder: kFocusedBorder,
  );
}