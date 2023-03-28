import 'package:chat_gpt/auth/SingupPage.dart';
import 'package:chat_gpt/authbackend/UserModelView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../helper/cache.dart';
import '../resources/Toast.dart';
import '../resources/cache_keys.dart';
import '../resources/colors.dart';
import '../resources/images.dart';

class LoginPage extends GetView<UserModeView> {
  UserModeView userModeView = Get.put(UserModeView());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.solfColor,
      body: Obx(() => LoadingOverlay(
          isLoading: userModeView.signinloading.value,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  Images.logo,
                  height: 200,
                  fit: BoxFit.fitHeight,
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.150,
                  decoration: BoxDecoration(
                    // color: AppColors.hardColor,

                    gradient: LinearGradient(colors: [
                      AppColors.solfColor,
                      AppColors.solfColor,
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    controller: userModeView.email,
                    decoration: InputDecoration(
                        fillColor: Color.fromRGBO(242, 242, 242, 0.74),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: "Email",
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.150,
                  decoration: BoxDecoration(
                    // color: AppColors.hardColor,

                    gradient: LinearGradient(colors: [
                      AppColors.solfColor,
                      AppColors.solfColor,
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    controller: userModeView.password,
                    decoration: InputDecoration(
                        fillColor: Color.fromRGBO(242, 242, 242, 0.74),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: "password",
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black)),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    if (userModeView.email.text.isEmpty) {
                      AmeToast.toast("Please Enter your Email");
                    } else if (userModeView.password.text.isEmpty) {
                      AmeToast.toast("Please Enter your password");
                    } else {
                      userModeView.signIn();

                      userModeView.addStringToSF();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.150,
                    decoration: BoxDecoration(
                      color: Color(0xff1877F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Text(
                      "Login ",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black),
                    )),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    userModeView.googlesinup();
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.150,
                    decoration: BoxDecoration(
                      color: AppColors.cayanColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          SizedBox(width:20,),

                          Image.asset("assets/images/google_img.png"),
                          SizedBox(width:20,),
                          Center(
                              child: Text(
                            "Google SigIn ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Did't have an account yet.?",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: Colors.black),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(SingUp());
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ))),
    );
  }
}
