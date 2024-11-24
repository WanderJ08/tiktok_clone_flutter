import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:tiktok_clone/authentication/authentication_controller.dart';
import 'package:tiktok_clone/authentication/login_screen.dart';
import 'package:tiktok_clone/widgets/input_text_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;

  var authenticationController = AuthenticationController.instanceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "Create Account",
                style: GoogleFonts.acme(
                    fontSize: 34,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "To get started now!",
                style: GoogleFonts.acme(
                  fontSize: 34,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              //profile image
              GestureDetector(
                onTap: ()
                    //Allow user to select profile image
                    {
                  authenticationController.chooseImageFromGallery();
                },
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("images/profile_avatar.jpg"),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              //user name input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: userNameTextEditingController,
                  lableString: "Username",
                  iconData: Icons.person_outline,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //email input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: emailTextEditingController,
                  lableString: "Email",
                  iconData: Icons.email_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //password input
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: InputTextWidget(
                  textEditingController: passwordTextEditingController,
                  lableString: "Password",
                  iconData: Icons.lock_outline,
                  isObscure: true,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //Login button
              //not have an account, signup now button
              showProgressBar == false
                  ? Column(
                      children: [
                        //login button
                        Container(
                          width: MediaQuery.of(context).size.width - 38,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showProgressBar = true;
                              });

                              //login user now
                            },
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),

                        //not have an account, signup now button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                //send user to signup screen
                                Get.to(LoginScreen());
                              },
                              child: const Text(
                                " Login now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Container(
                      child: SimpleCircularProgressBar(
                      progressColors: [
                        Colors.green,
                        Colors.blueAccent,
                        Colors.red,
                        Colors.amber,
                        Colors.purpleAccent,
                      ],
                      animationDuration: 3,
                      backColor: Colors.white38,
                    )
                      //Show animations

                      ),
            ],
          ),
        ),
      ),
    );
  }
}
