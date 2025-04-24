// ignore_for_file: file_names
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/widgets/utilis.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({
    super.key,
  });

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final Uri instagram = Uri.parse(
      'https://www.instagram.com/https://www.instagram.com/saronlabs?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==');

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      leadingWidth: 15.w,
      leading: Utilis.backButton(context: context),
    );
  }

  Widget _buildScreenTitle() {
    return Constant.textWithStyle(
      text: 'Help Center',
      color: Constant.textPrimary,
      size: 23.sp,
      maxLine: 5,
      fontWeight: FontWeight.w900,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.bgPrimary,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            _buildScreenTitle(),
            SizedBox(height: 3.h),
            InkWell(
              onTap: () => launchUrl(instagram),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: 8.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: Constant.bgWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 12.w,
                        width: 12.w,
                        decoration: const BoxDecoration(
                          color: Constant.bgPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            'lib/constant/icons/instagram.png',
                            //     color: Constant.bgBlue,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 1.h,
                      ),
                      Constant.textWithStyle(
                          text: 'Instagram',
                          size: 16.sp,
                          fontWeight: FontWeight.w600,
                          maxLine: 3,
                          color: Constant.textPrimary),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Constant.textWithStyle(
                text: 'Follow @saronlabs for the latest updates and features.',
                size: 15.sp,
                fontWeight: FontWeight.w600,
                maxLine: 5,
                color: Constant.textSecondary),
            SizedBox(
              height: 1.h,
            ),
            InkWell(
              onTap: () =>
                  Utilis.launchWhatsApp(message: 'Hi there, I need a help.'),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: 8.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: Constant.bgWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 12.w,
                        width: 12.w,
                        decoration: const BoxDecoration(
                          color: Constant.bgPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            'lib/constant/icons/whatsapp.png',
                            //     color: Constant.bgBlue,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 1.h,
                      ),
                      Constant.textWithStyle(
                          text: 'Whats App',
                          size: 16.sp,
                          fontWeight: FontWeight.w600,
                          maxLine: 3,
                          color: Constant.textPrimary),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Constant.textWithStyle(
                text: 'Contact us on WhatsApp for any inquiries.',
                size: 15.sp,
                fontWeight: FontWeight.w600,
                maxLine: 5,
                color: Constant.textSecondary),
            SizedBox(
              height: 1.h,
            ),
            Constant.textWithStyle(
                text: 'E-Mail ID: saroninnovaturelabs@gmail.com',
                size: 16.sp,
                fontWeight: FontWeight.w600,
                maxLine: 5,
                color: Constant.textPrimary),
            // SizedBox(
            //   height: 40.h,
            //   width: 100.w,
            //   child: Image.asset(
            //     'lib/constant/icons/contactUs.png',
            //     scale: 3,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
