// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/widgets/authentication/apple_sign_in.dart';
import 'package:smart_controller/widgets/authentication/mobileNumberWid.dart';
import 'package:smart_controller/widgets/authentication/signWithGoogle.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginHomeScreen extends StatefulWidget {
  const LoginHomeScreen({super.key});

  @override
  State<LoginHomeScreen> createState() => _LoginHomeScreenState();
}

class _LoginHomeScreenState extends State<LoginHomeScreen> {
  final Uri privacy = Uri.parse('https://www.google.com');
  final Uri terms = Uri.parse('https://www.google.com');

  @override
  void initState() {
    super.initState();
  }

// padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark, // or .light
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Constant.bgWhite,
        extendBodyBehindAppBar: true,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Constant.bgSecondary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 1.h),
                  Constant.textWithStyle(
                      text: '✨🏠',
                      color: Constant.bgWhite,
                      size: 25.sp,
                      textAlign: TextAlign.center,
                      maxLine: 5,
                      fontWeight: FontWeight.w900),
                  Constant.textWithStyle(
                      text: 'Smart Living Starts Here',
                      color: Constant.bgWhite,
                      size: 23.sp,
                      textAlign: TextAlign.center,
                      maxLine: 5,
                      fontWeight: FontWeight.w900),
                  SizedBox(height: 3.h),
                  if (Platform.isIOS) ...[
                    const AppleSigninButton(),
                    SizedBox(height: 1.h),
                  ],
                  const SignWithGoogle(),
                  SizedBox(height: 1.h),
                  // const MobileNumberWid(),
                  SizedBox(height: 3.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'By Creating or logging into an account you are agreeing with our',
                          style: TextStyle(
                            fontFamily: "Nunito",
                            color: Constant.bgWhite,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                            text: ' Terms and Conditions',
                            style: TextStyle(
                              fontFamily: "Nunito",
                              color: Constant.textPrimary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                launchUrl(terms);
                              }),
                        TextSpan(
                          text: ' and',
                          style: TextStyle(
                            fontFamily: "Nunito",
                            color: Constant.bgWhite,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                            text: ' Privacy Policy.',
                            style: TextStyle(
                              fontFamily: "Nunito",
                              color: Constant.textPrimary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                launchUrl(privacy);
                              }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 50.h,
                width: 100.w,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/constant/icons/saronIcon.png',
                        fit: BoxFit.cover,
                        scale: 8,
                      ),
                      Text(
                        'Saron Smart',
                        style: TextStyle(
                            fontFamily: 'Anton',
                            color: Constant.bgSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 32.sp,
                            letterSpacing: 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
