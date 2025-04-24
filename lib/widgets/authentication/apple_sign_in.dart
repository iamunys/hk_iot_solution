import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/mutationController.dart';
import 'package:smart_controller/controller/userStateController.dart';

class AppleSigninButton extends StatefulWidget {
  const AppleSigninButton({super.key});

  @override
  State<AppleSigninButton> createState() => _AppleSigninButtonState();
}

class _AppleSigninButtonState extends State<AppleSigninButton> {
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
          ? null // Disable button when loading
          : () async {
              setState(() {
                isLoading = true;
              });
              try {
                await userStateController.verifyAppleLogin();
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        // height: 5.h,
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
              Icon(
                Icons.apple,
                color: Constant.textPrimary,
                size: 22.sp,
              ),
            Expanded(
              child: Constant.textWithStyle(
                textAlign: TextAlign.center,
                text: isLoading ? 'Signing in...' : 'Continue with Apple',
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
