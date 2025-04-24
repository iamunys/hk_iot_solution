// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/mutationController.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/widgets/utilis.dart';

class MobileNumber extends StatefulWidget {
  final UserStateController userStateController;
  final TextEditingController phoneNumberController;

  const MobileNumber({
    super.key,
    required this.userStateController,
    required this.phoneNumberController,
  });

  @override
  State<MobileNumber> createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumber> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100.w,
          decoration: BoxDecoration(
            color: Constant.bgWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone_iphone,
                      color: Constant.textPrimary,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '+91',
                      style: TextStyle(
                        fontFamily: "Nunito",
                        color: Constant.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.phoneNumberController,
                  cursorColor: Constant.textPrimary,
                  maxLines: 1,
                  maxLength: 10,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    counterText: '',
                    border: InputBorder.none,
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(
                      fontFamily: "Nunito",
                      color: Constant.textSecondary.withValues(alpha: 0.5),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
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
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        SizedBox(
          height: 6.h,
          width: 100.w,
          child: ElevatedButton(
            onPressed: isloading
                ? null
                : () async {
                    if (widget.phoneNumberController.text.isNotEmpty &&
                        widget.phoneNumberController.text.isNumericOnly &&
                        widget.phoneNumberController.text.length > 9) {
                      widget.userStateController.clearError();
                      setState(() {
                        isloading = true;
                      });

                      try {
                        await widget.userStateController.verifyPhoneNumber(
                            widget.phoneNumberController.value.text);

                        if (kDebugMode) {
                          (widget.phoneNumberController.value.text);
                        }
                      } catch (e) {
                        Utilis.snackBar(
                            context: context,
                            title: 'Something went wrong',
                            message:
                                'Something went wrong please try again later');
                      } finally {
                        setState(() {
                          isloading = false;
                        });
                      }
                    } else {
                      widget.userStateController.mobileVerificationError =
                          'Please enter a valid phone number.';
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Constant.bgSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: isloading
                ? const MutationLoader()
                : Constant.textWithStyle(
                    text: 'Continue',
                    color: Constant.bgWhite,
                    fontWeight: FontWeight.w700,
                    size: 17.sp,
                  ),
          ),
        ),
        SizedBox(
          height: 3.h,
        ),
      ],
    );
  }
}
