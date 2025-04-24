// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_controller/controller/Exceptions.dart';
import 'dart:developer' as logger;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthentication extends GetxController {
  // static final authInstance = FirebaseAuth.instance;

  static Future<User?> listenToAuthChange() async {
    await for (User? user in FirebaseAuth.instance.authStateChanges()) {
      if (user == null) {
        debugPrint('User is currently signed out! : $user');
        return null;
      } else {
        debugPrint('User is signed in! : $user');

        return user;
      }
    }
    return null;
  }

  static verifyPhoneNumber(String? phoneNumber, codeSent, verifyErr,
      {int? resendToken}) async {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Phone auth verification failed: ${e.code} - ${e.message}");
          // Add appropriate error handling based on the error code
          if (e.code == 'invalid-phone-number') {
            // Handle invalid phone number
          } else if (e.code == 'too-many-requests') {
            // Handle rate limiting
            // Implement exponential backoff
          } else {
            // Handle other errors
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Verification code sent! ID: $verificationId');
          // ...
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // ...
        },
        forceResendingToken: resendToken);

    // await FirebaseAuth.instance.verifyPhoneNumber(
    //     phoneNumber: phoneNumber,
    //     verificationCompleted: (PhoneAuthCredential credential) async {
    //       await FirebaseAuth.instance.signInWithCredential(credential);
    //     },
    //     verificationFailed: verifyErr,
    //     codeSent: (String verificationId, int? resendToken) {
    //       debugPrint('code sent');

    //       codeSent(verificationId, resendToken);
    //     },
    //     codeAutoRetrievalTimeout: (String verificationId) {},
    //     forceResendingToken: resendToken);
  }

  static signInWithPhoneAuthCredential(verificationId, smsCode) async {
    // Create a PhoneAuthCredential with the code

    // Sign the user in (or link) with the credential
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUSer = userCredential.additionalUserInfo!.isNewUser;
      String? userName = userCredential.additionalUserInfo!.username;
      String? authCode = userCredential.additionalUserInfo!.authorizationCode;
      String? proID = userCredential.additionalUserInfo!.providerId;
      debugPrint("Is that new user : $isNewUSer");
      debugPrint("userName : $userName");
      debugPrint("Auth Code : $authCode");
      debugPrint("Pro Id  : $proID");
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        throw UserException("Invalid OTP");
      }
    } catch (e) {
      throw UserException("Error while OTP verification.");
    }
  }

  static Future signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      // Obtain Google authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      bool isNewUSer = result.additionalUserInfo!.isNewUser;
      String? userName = result.additionalUserInfo!.username;
      String? authCode = result.additionalUserInfo!.authorizationCode;
      String? proID = result.additionalUserInfo!.providerId;
      debugPrint("Is that new user : $isNewUSer");
      debugPrint("userName : $userName");
      debugPrint("Auth Code : $authCode");
      debugPrint("Pro Id  : $proID");
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        throw UserException("Invalid OTP");
      }
    } catch (e) {
      throw UserException("Error while google verification.");
    }
  }

  static Future<UserCredential> signInWithApple() async {
    try {
      // Request credential for Apple Sign In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      logger.log('Apple Credential: ${appleCredential.identityToken}');

      // Create OAuthCredential for Firebase
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      logger.log('OAuth Credential: $oauthCredential');
      // Sign in to Firebase
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      // Update user display name if it's null (common with Apple Sign In)
      if (userCredential.user != null) {
        final displayName =
            '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                .trim();
        if (displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
        }
      }

      return userCredential;
    } catch (e) {
      debugPrint('Error signing in with Apple: $e');
      rethrow;
    }
  }

  static signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
