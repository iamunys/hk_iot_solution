// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';

class MobileNumberWid extends StatelessWidget {
  const MobileNumberWid({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => context.push('/mobileAuth'),
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
            Icon(
              Icons.phone_iphone,
              color: Constant.textPrimary,
              size: 22.sp,
            ),
            Expanded(
              child: Constant.textWithStyle(
                textAlign: TextAlign.center,
                text: 'Continue with Mobile Number',
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
