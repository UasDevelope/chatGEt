
import 'package:chat_gpt/Modules/home/home.dart';
import 'package:chat_gpt/auth/loginPage.dart';
import 'package:chat_gpt/authbackend/usermodel.dart';
import 'package:chat_gpt/resources/Toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
class UserModeView extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserModel userModel = Get.put(UserModel());
  TextEditingController usernamecntrlr = TextEditingController();
  TextEditingController emailcntrlr = TextEditingController();
  TextEditingController passwordctlr = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  //bolean
  GoogleSignIn _googleSignIn = GoogleSignIn();
  var signinloading = false.obs;
  var signuploading = false.obs;
  Future<void> SignUp() async {
    signuploading.value=true;
    try {
      var user = await auth.createUserWithEmailAndPassword(
          email: emailcntrlr.text, password: passwordctlr.text);
      if (user != null) {
        userModel.username = usernamecntrlr.text;
        userModel.useremail = emailcntrlr.text;
        userModel.password = passwordctlr.text;
        userModel.id = auth.currentUser!.uid;
        if (user != null) {
          await firestore.collection("users").doc(auth.currentUser!.uid).set(
                userModel.fromjson(),
              );
          Get.to(LoginPage());
        }
        signuploading.value=false;

      }
    } catch (e) {
      AmeToast.toast("${e}");
      signuploading.value=false;

    }
  }

  Future<void> signIn() async {
    signinloading.value=true;

    try {
      var user = await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      if (user != null) {
        Get.to(Home());
      }
      signinloading.value=false;

    } catch (e) {
      AmeToast.toast("${e}");
      signinloading.value=false;

    }
  }
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email',email.text);
    print(prefs);
  }
  Future<void> googlesinup() async {
    try {
      var singng = await _googleSignIn.signIn();
      GoogleSignInAccount? googleSignInAccount = await singng;
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        AuthCredential credential = await GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        print(googleSignInAccount.email);
        userModel.useremail = googleSignInAccount.email;
        userModel.username = googleSignInAccount.displayName;
        userModel.id = googleSignInAccount.id;
        firestore
            .collection("user")
            .doc(googleSignInAccount.id)
            .set(userModel.fromjson());
        AmeToast.sucesstoast("Data is stored sucessfully");
        Get.to(Home());
      }
    } catch (error) {
      AmeToast.toast("$error");
      print(error);
    }
  }

}
