import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fireservices/keys.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/text_field.dart';

class AuthProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  AuthType _authType = AuthType.login;
  AuthType get authType => _authType;

  // below two lines used to initiate the auth and firestore
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // this function used to setup the page to login if already signup
  // actual meaning is if signup is true show login else show signup
  setAuthType() {
    _authType = _authType == AuthType.signup ? AuthType.login : AuthType.signup;
    notifyListeners();
  }

  //get user token for send notification
  Future<String> getUserToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    final String? token = await firebaseMessaging.getToken();
    print(token);
    return token!;
  }

  //authenticate function for all firebase functionality
  authenticate() async {
    UserCredential userCredential;
    try {
      if (_authType == AuthType.signup) {
        // firebase Authentication account creation
        userCredential = await firebaseAuth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        String token = await getUserToken();

        //send email verification mail
        await userCredential.user!.sendEmailVerification();

        //firestore storing signup data
        await firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          "email": userCredential.user!.email,
          "uid": userCredential.user!.uid,
          "user_name": usernameController.text,
          "token": token,
        });
      }

      // firebase account login
      if (_authType == AuthType.login) {
        userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        String token = await getUserToken();
        await firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({
          "token": token,
        });
      }
    } on FirebaseAuthException catch (error) {
      // catch funtion catch the problem during fireservice and it show to user
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.code),
        backgroundColor: Colors.red,
      ));
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.black,
      ));
    }
  }

  // below function change state in home page if verified
  bool? emailverified;
  updateEmailVerificationState() async {
    emailverified = firebaseAuth.currentUser!.emailVerified;
    if (!emailverified!) {
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        print("timer callled");
        await firebaseAuth.currentUser!.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          emailverified = user.emailVerified;
          timer.cancel();
          notifyListeners();
        }
      });
    }
  }

  TextEditingController resetEmailController = TextEditingController();
  // Password reset
  resetPassword(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Enter your email'),
            content: CustomTextField(
              hinttext: 'Enter email',
              controller: resetEmailController,
              prefixicon: Icons.email
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context).pop();
                    try {
                      await firebaseAuth.sendPasswordResetEmail(
                          email: resetEmailController.text);
                      Keys.scaffoldMessengerKey.currentState!.showSnackBar(
                        const SnackBar(
                          content: Text('Email send successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      navigator; // for pop()
                    } catch (e) {
                      Keys.scaffoldMessengerKey.currentState!.showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                      navigator;
                    }
                  },
                  child: const Text('Submit'))
            ],
          );
        });
  }

  //firebase Phone number verification
  TextEditingController phoneController =
      TextEditingController(text: '+919943312165');
  verifyPhoneNumber(BuildContext context) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneController.text,
          timeout: const Duration(seconds: 30),
          verificationCompleted: (AuthCredential authCredential) {
            Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text('Verification Completed'),
              backgroundColor: Colors.green,
            ));
          },
          verificationFailed: (FirebaseAuthException exception) {
            Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text('Verification Failed'),
              backgroundColor: Colors.red,
            ));
          },
          codeSent: (String? verId, int? forcecodeResent) {
            Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text('Code sent successfully'),
              backgroundColor: Colors.green,
            ));
            verificationId = verId;
            // otp dialog box
            optDialogBox(context);
          },
          codeAutoRetrievalTimeout: (String verId) {
            Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
              content: Text('Time out'),
              backgroundColor: Colors.red,
            ));
          });
    } on FirebaseException catch (e) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(e.message!),
        backgroundColor: Colors.red,
      ));
    }
  }

  String? verificationId;
  // method for OTP dialog box
  TextEditingController otpController = TextEditingController();
  optDialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Enter the OTP'),
            content: CustomTextField(
              controller: otpController,
              prefixicon: Icons.code,
              hinttext: 'Enter OTP',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    signInWithPhone();
                    Navigator.of(context).pop();
                  },
                  child: Text("Submit"))
            ],
          );
        });
  }

  //Verifiy the entered OTP
  signInWithPhone() {
    firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text));
  }

  //Google signin
  GoogleSignIn googleSignIn = GoogleSignIn();
  signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      try {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await firebaseAuth.signInWithCredential(authCredential);
        print(googleSignInAccount.photoUrl);
        print(googleSignInAccount.displayName);
        print(googleSignInAccount.email);
      } on FirebaseAuthException catch (e) {
        Keys.scaffoldMessengerKey.currentState!
            .showSnackBar(SnackBar(content: Text(e.message!)));
      }
    } else {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text('Account not selected'),
        backgroundColor: Colors.red,
      ));
    }
  }

  //firebase signout
  logOut() {
    try {
      firebaseAuth.signOut();
      googleSignIn.signOut();
    } catch (error) {
      Keys.scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.black,
      ));
    }
  }
}

enum AuthType { signup, login }
