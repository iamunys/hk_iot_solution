// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:go_router/go_router.dart';
import 'package:smart_controller/controller/Exceptions.dart';
import 'package:smart_controller/controller/widget_controller.dart';
import 'package:smart_controller/main.dart';
import 'package:smart_controller/services/firebaseAuthServices.dart';
import 'package:smart_controller/widgets/utilis.dart';

class UserStateController extends GetxController {
  FirebaseAuthentication? firebaseAuth;

  String? _mobileVerificationError;
  String? _verificationId;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  User? currentUser;
  String? userId;
  String? userEmailId;

  @override
  void onInit() {
    firebaseAuth = FirebaseAuthentication();
    super.onInit();
  }

  String? get mobileVerificationError => _mobileVerificationError;

  set mobileVerificationError(String? cause) {
    final currentContext = NavigationService.navigatorKey.currentContext;

    _mobileVerificationError = cause;
    if (_mobileVerificationError != null) {
      Utilis.snackBar(
          context: currentContext!, title: 'Oops!', message: '$cause');
    }
    update();
  }

  String? get verificationId => _verificationId;
  set verificationId(String? cause) {
    _verificationId = cause;
    update();
  }

  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool flag) {
    _isLoggedIn = flag;
    update();
  }

  bool get isLoading => _isLoading;
  set isLoading(bool flag) {
    _isLoading = flag;
    update();
  }

  clearError() {
    mobileVerificationError = null;
  }

  //Phone number verifications methods and fields

  verifyPhoneNumber(String? phoneNumber) async {
    int lengthPhoneNumber = phoneNumber!.length;
    try {
      await FirebaseAuthentication.verifyPhoneNumber(
          lengthPhoneNumber == 10 ? '+91$phoneNumber' : phoneNumber,
          verifyPhoneNumberCallBack,
          verifyPhoneErrorCallback);
    } on UserException catch (e) {
      mobileVerificationError = e.cause;
    } catch (e) {
      mobileVerificationError =
          "Could not verify phone number, please try again later!";
    }
  }

  verifyPhoneNumberCallBack(String id, int? token) {
    verificationId = id;
    update();
  }

  verifyPhoneErrorCallback(firebase.FirebaseAuthException e) {
    print("Firebase Error: ${e.code} - ${e.message}");
    if (e.code == 'invalid-phone-number') {
      mobileVerificationError = 'The provided phone number is not valid.';
    } else {
      mobileVerificationError =
          'Error while verifying, Please try again later.';
    }
    update();
  }

  verifyOTP(String? otp) async {
    try {
      debugPrint('Verifying Otp:$otp');
      await FirebaseAuthentication.signInWithPhoneAuthCredential(
          verificationId, otp);
      subscribeToAuthChanges();
    } on UserException catch (e) {
      mobileVerificationError = e.cause;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      mobileVerificationError = "Could not verify OTP, please try again later!";
    }
  }

  verifyGoogle() async {
    try {
      await FirebaseAuthentication.signInWithGoogle();
      subscribeToAuthChanges();
    } on UserException catch (e) {
      mobileVerificationError = e.cause;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      mobileVerificationError =
          "Could not sign to Google, please try again later!";
    }
  }

  verifyAppleLogin() async {
    try {
      await FirebaseAuthentication.signInWithApple();
      subscribeToAuthChanges();
    } on UserException catch (e) {
      mobileVerificationError = e.cause;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      mobileVerificationError =
          "Could not sign to Apple, please try again later!";
    }
  }

  subscribeToAuthChanges() async {
    currentUser = await FirebaseAuthentication.listenToAuthChange();
    if (currentUser == null) {
      debugPrint('User is not logged In');
      isLoggedIn = false;
      Get.find<WidgetsController>().splashCompleteLogin = true;
      Get.find<WidgetsController>().splashCompleteListDevice = false;
    } else {
      userId = currentUser!.uid;
      userEmailId = currentUser!.email;
      debugPrint('User is loggedIn : ${currentUser?.uid}');
      debugPrint('Firebase Token : ${await currentUser?.getIdToken()}');
      isLoggedIn = true;

      try {
        Get.find<WidgetsController>().splashCompleteLogin = false;
        Get.find<WidgetsController>().splashCompleteListDevice = true;
      } catch (e) {
        if (kDebugMode) {
          print('Error checking/creating ID: $e');
        }
      }
    }
  }

  signOut() async {
    //logout
    verificationId = null;
    await FirebaseAuthentication.signOut();
    debugPrint('Logout Called');
    isLoggedIn = false;
    // deleteStringPreference('motorId');
    isLoggedIn = false;
    final currentContext = NavigationService.currentContext;
    Get.find<WidgetsController>().splashCompleteLogin = true;
    Get.find<WidgetsController>().splashCompleteListDevice = false;
    currentContext.go('/');
  }

  // Future<void> setStringPreference(String key, String value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(key, value);
  // }

  // Future<String?> getStringPreference(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(key);
  // }

  // Future<void> deleteStringPreference(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(key);
  // }
}
