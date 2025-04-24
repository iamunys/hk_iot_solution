// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/widgets/utilis.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Constant.bgSecondary,
        centerTitle: false,
        elevation: 5,
        // leading: Get.find<WidgetsController>().isAddDevice
        //     ? IconButton(
        //         onPressed: () {
        //           Get.find<WidgetsController>().isAddDevice = false;
        //           Get.find<WidgetsController>().splashCompleteLogin = false;
        //           Get.find<WidgetsController>().splashCompleteSelectDevice =
        //               false;
        //           Get.find<WidgetsController>().splashCompleteListDevice = true;
        //         },
        //         icon: const Icon(
        //           Icons.arrow_back_ios_new_rounded,
        //           color: Constant.bgWhite,
        //         ))
        //     : const SizedBox.shrink(),
        title: Text(
          'Hk Iot Solutions',
          style: TextStyle(
              fontFamily: 'Anton',
              color: Constant.bgWhite,
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              letterSpacing: 2),
        ),
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Constant.bgPrimary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.h),
            Constant.textWithStyle(
                fontWeight: FontWeight.w800,
                text: 'Select Your Device',
                size: 20.sp,
                color: Constant.textPrimary),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                context.push('/listDevice');
              },
              child: Card(
                elevation: 10,
                color: Constant.bgWhite,
                child: Container(
                  width: 50.w,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        'lib/constant/icons/battery.png',
                        color: Constant.textPrimary.withOpacity(.8),
                        scale: 4,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Constant.textWithStyle(
                          fontWeight: FontWeight.w700,
                          text: 'MOTCON V3',
                          size: 15.sp,
                          color: Constant.textPrimary),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            InkWell(
              onTap: () {
                Utilis.snackBar(
                    context: context,
                    title: 'Coming Soon',
                    message:
                        'This not available right now. We are working on it.',
                    failure: false);
              },
              child: Card(
                elevation: 10,
                color: Constant.bgWhite,
                child: Container(
                  width: 50.w,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Image.asset('lib/constant/icons/switch.png',
                          color: const Color.fromARGB(255, 241, 160, 160)
                              .withOpacity(.8),
                          scale: 4),
                      SizedBox(height: 1.h),
                      Constant.textWithStyle(
                          fontWeight: FontWeight.w700,
                          text: 'SMART SWITCH',
                          size: 15.sp,
                          color: Constant.textSecondary),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
