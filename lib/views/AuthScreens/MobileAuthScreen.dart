// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/controller/widget_controller.dart';
import 'package:smart_controller/widgets/authentication/mobileNumber.dart';
import 'package:smart_controller/widgets/authentication/otp.dart';
import 'package:smart_controller/widgets/utilis.dart';

class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({
    super.key,
  });

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  final wid = Get.put(WidgetsController());
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Constant.bgPrimary,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark, // or .light
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          actions: [
            IconButton(
              onPressed: () => Utilis.launchWhatsApp(
                  message: 'I am having trouble logging into the app.'),
              icon: const Icon(
                Icons.contact_support_outlined,
                color: Constant.bgBlue,
              ),
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: GetBuilder<UserStateController>(
              init: UserStateController(),
              builder: (userStateController) {
                return Container(
                  height: 100.h,
                  width: 100.w,
                  color: Constant.bgPrimary,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          userStateController.verificationId == null
                              ? Constant.textWithStyle(
                                  text: 'Enter your mobile number',
                                  color: Constant.textPrimary,
                                  size: 23.sp,
                                  maxLine: 5,
                                  fontWeight: FontWeight.w900,
                                )
                              : Constant.textWithStyle(
                                  text: 'Verification code',
                                  color: Constant.textPrimary,
                                  size: 23.sp,
                                  maxLine: 5,
                                  fontWeight: FontWeight.w900,
                                ),
                          SizedBox(
                            height: 1.h,
                          ),
                          userStateController.verificationId == null
                              ? Constant.textWithStyle(
                                  text:
                                      'Kindly input your 10-digit mobile phone number',
                                  color: Constant.textSecondary,
                                  size: 15.sp,
                                  maxLine: 5,
                                  fontWeight: FontWeight.w600,
                                )
                              : Constant.textWithStyle(
                                  text:
                                      'Please input the verification code sent to your mobile device',
                                  color: Constant.textSecondary,
                                  size: 15.sp,
                                  maxLine: 5,
                                  fontWeight: FontWeight.w600,
                                ),
                          SizedBox(
                            height: 3.h,
                          ),
                          userStateController.verificationId == null
                              ? MobileNumber(
                                  phoneNumberController: phoneNumberController,
                                  userStateController: userStateController,
                                )
                              : Otp(
                                  userStateController: userStateController,
                                  otpController: otpController,
                                ),
                          SizedBox(
                            height: 3.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
