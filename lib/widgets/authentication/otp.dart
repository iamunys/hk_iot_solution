// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/mutationController.dart';
import 'package:smart_controller/controller/userStateController.dart';

class Otp extends StatelessWidget {
  final bool isRegister;
  final TextEditingController otpController;
  final UserStateController userStateController;
  const Otp({
    super.key,
    this.isRegister = false,
    required this.userStateController,
    required this.otpController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          decoration: BoxDecoration(
            color: Constant.bgSecondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: otpController,
            maxLength: 6,
            keyboardType: TextInputType.number,
            cursorColor: Constant.textPrimary,
            maxLines: 1,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              counterText: '',
              border: InputBorder.none,
              hintText: 'Enter Otp',
              hintStyle: TextStyle(
                  fontFamily: "Nunito",
                  color: Constant.textSecondary.withValues(alpha: .5),
                  fontSize: 16.sp,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600),
            ),
            style: TextStyle(
              fontFamily: "Nunito",
              color: Constant.textPrimary,
              fontSize: 16.sp,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        SizedBox(
          height: 5.h,
          width: 100.w,
          child: ElevatedButton(
            onPressed: userStateController.isLoading
                ? null
                : () async {
                    if (otpController.text.isNotEmpty) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      userStateController.isLoading = true;

                      try {
                        await userStateController
                            .verifyOTP(otpController.value.text);
                        context.pop();
                      } finally {
                        userStateController.isLoading = false;
                      }

                      if (userStateController.mobileVerificationError != null) {
                        otpController.clear();
                      }
                    } else {
                      userStateController.mobileVerificationError =
                          'Please enter a valid Otp';
                    }
                    userStateController.isLoading = false;
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isRegister ? Constant.textPrimary : Constant.textSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: userStateController.isLoading
                ? const MutationLoader()
                : Constant.textWithStyle(
                    text: 'LOGIN',
                    color: Constant.bgWhite,
                    fontWeight: FontWeight.w700,
                    size: 15.sp,
                  ),
          ),
        ),
      ],
    );
  }
}
