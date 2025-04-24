// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/controller/widget_controller.dart';
import 'package:smart_controller/views/AuthScreens/loginHome.dart';
import 'package:smart_controller/views/listMotorDevice.dart';
import 'package:smart_controller/views/select_category.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Get.put(UserStateController());
    Timer(const Duration(seconds: 1), () {
      Get.find<UserStateController>().subscribeToAuthChanges();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WidgetsController>(
        init: WidgetsController(),
        builder: (controller) {
          if (controller.splashCompleteListDevice) {
            return const ListDeviceScreen();
          } else if (controller.splashCompleteLogin) {
            return const LoginHomeScreen();
          } else if (controller.splashCompleteSelectDevice) {
            return const SelectCategory();
          } else {
            return Scaffold(
              backgroundColor: Constant.bgSecondary,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
              ),
              extendBodyBehindAppBar: true,
              body: Container(
                color: Constant.bgSecondary,
                width: 100.w,
                height: 100.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/constant/icons/saron.png",
                      scale: 2,
                      color: Constant.bgPrimary,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
