import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/widget_controller.dart';
import 'package:smart_controller/views/landing/HomeScreen.dart';

import 'package:flutter/material.dart';
import 'package:smart_controller/views/landing/energy_consumption.dart';
import 'package:smart_controller/views/landing/profile_screen.dart';

class LandingScreen extends StatefulWidget {
  final String motorId;
  const LandingScreen({super.key, required this.motorId});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

List<Widget> buildBody = []; // Declare the list without initializing

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();

    buildBody = [
      HomeScreen(motorId: widget.motorId), // ✅ Now 'widget' can be accessed
      EnergyConsumption(motorId: widget.motorId),
      ProfileScreen(motorId: widget.motorId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.bgPrimary,
      bottomNavigationBar: GetBuilder<WidgetsController>(
          init: WidgetsController(),
          builder: (wid) {
            return SizedBox(
              height: 10.h,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Constant.bgSecondary,
                currentIndex: wid.bottomNavIndex,
                onTap: (value) => setState(() {
                  wid.bottomNavIndex = value;
                }),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 25,
                selectedItemColor: Constant.textPrimary,
                unselectedItemColor: Constant.textSecondary,
                items: [
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: 25,
                        child: Image.asset(
                          'lib/constant/icons/home.png',
                          color: wid.bottomNavIndex == 0
                              ? Constant.bgPrimary
                              : Constant.textPrimary.withOpacity(.7),
                        ),
                      ),
                      label: 'Home'),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: 25,
                        // child: Image.asset(
                        //   'lib/constant/icons/user.png',
                        //   color: wid.bottomNavIndex == 1
                        //       ? Constant.bgPrimary
                        //       : Constant.bgPrimary.withOpacity(.8),
                        // ),
                        child: Icon(
                          size: 22.sp,
                          Icons.electric_bolt_rounded,
                          color: wid.bottomNavIndex == 1
                              ? Constant.bgPrimary
                              : Constant.textPrimary.withOpacity(.7),
                        ),
                      ),
                      label: 'Profile'),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        height: 25,
                        child: Image.asset(
                          'lib/constant/icons/setting.png',
                          color: wid.bottomNavIndex == 2
                              ? Constant.bgPrimary
                              : Constant.textPrimary.withOpacity(.7),
                        ),
                      ),
                      label: 'Earnings'),
                ],
              ),
            );
          }),
      body: GetBuilder<WidgetsController>(
          init: WidgetsController(),
          builder: (wid) {
            return buildBody[wid.bottomNavIndex];
          }),
    );
  }
}
