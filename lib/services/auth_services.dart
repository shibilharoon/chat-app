import 'package:chathub/model/user_model.dart';
import 'package:chathub/view/widget/customer_alert_dialogue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("error occured");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("error occured");
    }
    return null;
  }

  signinWithGoogle() async {
    try {
      final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gauth = await guser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gauth.accessToken, idToken: gauth.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? googleuser = userCredential.user;
      final UserModel userdata = UserModel(
          name: googleuser!.displayName,
          email: googleuser.email,
          uid: googleuser.uid);
      firestore.collection('users').doc(googleuser.uid).set(userdata.toJson());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  void signInwithPhone(
      String phonenumber, context, String name, String email) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phonenumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            var credential =
                await auth.signInWithCredential(phoneAuthCredential);
            final UserModel userdata = UserModel(
                email: email,
                name: name,
                uid: credential.user!.uid,
                phonenumber: credential.user!.phoneNumber);
            firestore
                .collection("users")
                .doc(credential.user!.uid)
                .set(userdata.toJson());
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, resendtoken) {
            showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  veridicationId: verificationId,
                );
              },
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  void verifyOtp(
      {required String verificationId,
      required String otp,
      required Function onSuccess}) async {
    try {
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      User? user = (await auth.signInWithCredential(cred)).user;

      if (user != null) {
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  signInWithGithub(context) async {
    GithubAuthProvider githubAuthProvider = GithubAuthProvider();
    try {
      UserCredential user = await auth.signInWithProvider(githubAuthProvider);
      User gituser = user.user!;
      final UserModel userdata = UserModel(
          email: gituser.email, name: gituser.displayName, uid: gituser.uid);
      firestore.collection("users").doc(gituser.uid).set(userdata.toJson());
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    final GoogleSignIn google = GoogleSignIn();

    try {
      await auth.signOut();
      await google.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
