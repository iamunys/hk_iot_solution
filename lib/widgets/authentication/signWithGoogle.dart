// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/mutationController.dart';
import 'package:smart_controller/controller/userStateController.dart';

class SignWithGoogle extends StatefulWidget {
  const SignWithGoogle({super.key});

  @override
  State<SignWithGoogle> createState() => _SignWithGoogleState();
}

class _SignWithGoogleState extends State<SignWithGoogle> {
  final userStateController = Get.put(UserStateController());
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true; // Start loading
              });
              try {
                await userStateController.verifyGoogle();
              } finally {
                setState(() {
                  isLoading = false; // Stop loading
                });
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: 100.w,
        decoration: BoxDecoration(
          color: Constant.bgWhite,
          border: Border.all(color: Constant.bgWhite),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (isLoading)
              const MutationLoader()
            else
              SizedBox(
                child: Image.asset(
                  'lib/constant/icons/google.png',
                  fit: BoxFit.fill,
                  height: 20.sp,
                  width: 20.sp,
                ),
              ),
            Expanded(
              child: Constant.textWithStyle(
                textAlign: TextAlign.center,
                text: isLoading ? 'Signing in...' : 'Continue with Google',
                color: Constant.textPrimary,
                fontWeight: FontWeight.w700,
                size: 16.sp,
              ),
            ),
            const Icon(
              Icons.email_outlined,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
