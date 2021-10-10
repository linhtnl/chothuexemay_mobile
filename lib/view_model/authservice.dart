import 'dart:developer';

import 'package:chothuexemay_mobile/Repositories/Implementations/customer_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final CustomerRepository _customerRepository = CustomerRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber = "";
  String verificationId = "";
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCredential) async {
    return await FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  Future<bool> signInWithOTP(smsCode, verId) async {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    UserCredential user = await signIn(authCredential);
    if (user.user != null || user.user!.uid.isEmpty) {
      return _customerRepository.login(phoneNumber);
    }
    return false;
  }

  Future<void> verifyPhone(String phoneNo, BuildContext context) async {
    phoneNumber = phoneNo;
    if (phoneNo.startsWith("0")) {
      phoneNo = phoneNo.replaceFirst('0', '+84');
    }
    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationCompleted verified =
        (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };
    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        log('The provided phone number is not valid.');
      } else {
        log(e.message.toString());
      }
    };
    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsSent = (String verificationId, int? resendToken) {
      log("Sms sent");
      this.verificationId = verificationId;
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeAutoRetrievalTimeout autoTimeout =
        (String verificationId) async {
      log('auto timeout');
      // ignore: unused_label
      timeout:
      const Duration(seconds: 100);
    };
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNo,
          verificationCompleted: verified,
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout,
          timeout: const Duration(seconds: 100));
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }
}
