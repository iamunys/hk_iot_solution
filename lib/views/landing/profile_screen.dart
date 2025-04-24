import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_controller/constant/constant.dart';
import 'package:smart_controller/controller/userStateController.dart';
import 'package:smart_controller/widgets/utilis.dart';

class ProfileScreen extends StatefulWidget {
  final String motorId;
  const ProfileScreen({super.key, required this.motorId});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userState = Get.put(UserStateController());
  final TextEditingController emailIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Constant.bgPrimary,
        centerTitle: true,
        title: Constant.textWithStyle(
            fontWeight: FontWeight.bold,
            text: 'Settings',
            size: 18.sp,
            color: Constant.textPrimary),
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Constant.bgPrimary,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 3.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.w,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Constant.textWithStyle(
                            textAlign: TextAlign.center,
                            text: 'MOTCON V3',
                            size: 17.sp,
                            maxLine: 3,
                            fontWeight: FontWeight.w700,
                            color: Constant.textPrimary),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Constant.textWithStyle(
                                textAlign: TextAlign.center,
                                text: userState.currentUser!.email.toString(),
                                size: 16.sp,
                                maxLine: 3,
                                fontWeight: FontWeight.w600,
                                color: Constant.textSecondary),
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => copyToClipboard(
                                    userState.currentUser!.email.toString()),
                                icon: const Icon(Icons.copy))
                          ],
                        ),
                        if (widget.motorId != '')
                          Constant.textWithStyle(
                              textAlign: TextAlign.center,
                              text: widget.motorId,
                              size: 15.sp,
                              maxLine: 3,
                              fontWeight: FontWeight.w600,
                              color: Constant.textPrimary),

                        SizedBox(height: 1.h),
                        // Constant.textWithStyle(
                        //     textAlign: TextAlign.center,
                        //     text: "User ID :",
                        //     size: 15.sp,
                        //     maxLine: 3,
                        //     fontWeight: FontWeight.w700,
                        //     color: Constant.textSecondary),
                        // Constant.textWithStyle(
                        //     textAlign: TextAlign.center,
                        //     text: userState.currentUser!.uid,
                        //     size: 15.sp,
                        //     maxLine: 3,
                        //     fontWeight: FontWeight.w700,
                        //     color: Constant.textPrimary),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Constant.bgWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        if (widget.motorId != '') ...[
                          InkWell(
                            onTap: () => showCustomAlertDialog(),
                            child: SizedBox(
                              height: 7.h,
                              width: 100.w,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 10.w,
                                      width: 10.w,
                                      decoration: const BoxDecoration(
                                        color: Constant.bgPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'lib/constant/icons/user.png',
                                          color: Constant.textPrimary,
                                          scale: 2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 1.h,
                                    ),
                                    Constant.textWithStyle(
                                        text: 'Add Another User',
                                        fontWeight: FontWeight.w700,
                                        size: 16.sp,
                                        maxLine: 3,
                                        color: Constant.textPrimary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 2.h,
                            color: Constant.textSecondary,
                            thickness: .1,
                          ),
                        ],
                        InkWell(
                          onTap: () => context.push('/helpCenter'),
                          child: SizedBox(
                            height: 7.h,
                            width: 100.w,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 10.w,
                                    width: 10.w,
                                    decoration: const BoxDecoration(
                                      color: Constant.bgPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'lib/constant/icons/phone.png',
                                        color: Constant.textPrimary,
                                        scale: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.h,
                                  ),
                                  Constant.textWithStyle(
                                      text: 'Contact Us',
                                      fontWeight: FontWeight.w700,
                                      size: 16.sp,
                                      maxLine: 3,
                                      color: Constant.textPrimary),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 2.h,
                          color: Constant.textSecondary,
                          thickness: .1,
                        ),
                        if (widget.motorId != '') ...[
                          InkWell(
                            onTap: () => getUserAccessStatus(
                                widget.motorId,
                                userState.currentUser!.email!
                                    .split(".")[0]
                                    .toString()),
                            child: SizedBox(
                              height: 7.h,
                              width: 100.w,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 10.w,
                                      width: 10.w,
                                      decoration: const BoxDecoration(
                                        color: Constant.bgPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.delete,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 1.h,
                                    ),
                                    Constant.textWithStyle(
                                        text: 'Delete Device',
                                        fontWeight: FontWeight.w700,
                                        size: 16.sp,
                                        maxLine: 3,
                                        color: Constant.textPrimary),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 2.h,
                            color: Constant.textSecondary,
                            thickness: .1,
                          ),
                        ],
                        InkWell(
                          onTap: () => Utilis.showAlertDialog(
                              button2onpress: () async {
                                context.pop();
                                Get.find<UserStateController>().signOut();
                              },
                              button1name: 'Cancel',
                              button2name: 'Logout',
                              context: context,
                              title: 'Logout Account',
                              description: 'Are you sure you want to logout?',
                              needSecondButton: true),
                          child: SizedBox(
                            height: 7.h,
                            width: 100.w,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 10.w,
                                    width: 10.w,
                                    decoration: const BoxDecoration(
                                      color: Constant.bgPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'lib/constant/icons/power.png',
                                        scale: 2,
                                        color: Constant.textPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.h,
                                  ),
                                  Constant.textWithStyle(
                                      text: 'Logout',
                                      fontWeight: FontWeight.w700,
                                      size: 16.sp,
                                      maxLine: 3,
                                      color: Constant.textPrimary),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteDevice(String deviceId) async {
    try {
      await FirebaseDatabase.instance.ref('dS/$deviceId').remove();
      await FirebaseDatabase.instance.ref('energyConsuming/$deviceId').remove();
      Utilis.snackBar(
          context: context,
          title: 'Successfull',
          message: 'Device deleted successfully',
          failure: true);
    } catch (e) {
      Utilis.snackBar(
          context: context,
          title: 'Something went wrong',
          message:
              'Something went wrong for delete device.please try again later.');
    }
  }

  void showCustomAlertDialog() {
    emailIdController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Constant.bgPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Constant.textWithStyle(
              text: 'Add User',
              size: 18.sp,
              color: Constant.textPrimary,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Utilis.getThefields(
                    controller: emailIdController,
                    hintText: 'Email Id',
                    maxLine: 1,
                    height: 6),
              ),
              SizedBox(
                height: 1.h,
              ),
              Constant.textWithStyle(
                  text: "Please add the email ID of the user you wish to add.",
                  maxLine: 3,
                  fontWeight: FontWeight.w600,
                  size: 15.sp,
                  color: Constant.textSecondary),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Constant.textWithStyle(
                  text: 'Cancel',
                  size: 15.sp,
                  color: Constant.textPrimary,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600),
            ),
            // Submit Button
            ElevatedButton(
              onPressed: () =>
                  addUserIdToDevice(widget.motorId, emailIdController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Constant.bgSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Constant.textWithStyle(
                  text: 'Submit',
                  size: 15.sp,
                  color: Constant.bgWhite,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700),
            ),
          ],
        );
      },
    );
  }

  // void fetchUserId() async {
  //   String? uid =
  //       await FirebaseService.getUserIdByEmail("iamunys313@gmail.com");
  //   print("User ID: $uid");
  // }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));

    Utilis.snackBar(
        context: context,
        title: 'Copied',
        message: 'Copied to Clipboard',
        failure: false);
  }

  void addUserIdToDevice(String deviceId, String newEmailId) async {
    if (isValidEmail(newEmailId)) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("dS/$deviceId/uIds");
      await ref.update({newEmailId.split(".")[0]: false});
      context.pop();
      Utilis.snackBar(
          context: context,
          title: 'User Added',
          message: 'User added successfully',
          failure: false);
    } else {
      context.pop();

      Utilis.snackBar(
        context: context,
        title: 'User Added Failed',
        message: 'Enter a valid email',
      );
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> getUserAccessStatus(String motorId, String emailId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("dS/$motorId/uIds/$emailId");

    try {
      DatabaseEvent event = await ref.once();
      if (event.snapshot.exists) {
        bool hasAccess = event.snapshot.value == true; // Check if key exists
        print("User has access: $hasAccess");
        if (hasAccess) {
          Utilis.showAlertDialog(
              button2onpress: () async {
                context.pop();
                deleteDevice(widget.motorId);
                context.pop();
              },
              button1name: 'Cancel',
              button2name: 'Delete',
              context: context,
              title: 'Delete Device',
              description: 'Are you sure you want to delete this device?',
              needSecondButton: true);
        } else {
          Utilis.snackBar(
              context: context,
              title: 'User Access Denied',
              message: 'You don\'t have permission to do this',
              failure: true);
        }
      } else {
        Utilis.snackBar(
            context: context,
            title: 'Somthing went wrong',
            message: 'Something went wrong please try again later.',
            failure: true);
      }
    } catch (e) {
      Utilis.snackBar(
          context: context,
          title: 'Somthing went wrong',
          message: 'Something went wrong please try again later.',
          failure: true);
    }
  }
}
