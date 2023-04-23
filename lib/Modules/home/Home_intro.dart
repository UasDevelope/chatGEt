import 'package:chat_gpt/Modules/prompts/prompt.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/images.dart';
import '../image_gen/img_gen.dart';
import 'home.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBack(
        message: "Tap again to exit",
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(Images.background))),
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20,bottom:10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome!",
                    style: GoogleFonts.inter(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  Image.asset(Images.logo),
                  Text(
                    "How can I assist you!",
                    style: GoogleFonts.inter(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: Color.fromRGBO(235, 109, 238, 0.25)),
                          color: Color.fromRGBO(235, 109, 238, 0.25),
                          borderRadius: BorderRadius.circular(20)),
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Center(
                          child: Text(
                        "Ask me a general question.",
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ImgGen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Color.fromRGBO(255, 243, 107, 0.25),
                          ),
                          color: Color.fromRGBO(255, 243, 107, 0.25),
                          borderRadius: BorderRadius.circular(20)),
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Center(
                          child: Text(
                        "create art!.",
                        style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )),
                    ),
                  ),
                  SizedBox(height:20,),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:Border.all(
                            width:2,
                            color:Color.fromRGBO(78, 223, 255, 0.25),

                          ),
                            color:Color.fromRGBO(78, 223, 255, 0.25),
                            borderRadius: BorderRadius.circular(20)),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Text(
                          "Let’s code!",
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        )),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            border:Border.all(
                              width:2,
                              color:Color.fromRGBO(147, 244, 10, 0.25),

                            ),
                            color:Color.fromRGBO(147, 244, 10, 0.25),
                            borderRadius: BorderRadius.circular(20)),

                        height:50,
                        width: MediaQuery.of(context).size.width /1.2,
                        child: Center(
                            child: Text(
                          "Let’s just talk!.",
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        )),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AwsomePrompt()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffE0DFFE),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "Check out SoLoPrompts!",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
