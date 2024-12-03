import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/home/profile/profile_controller.dart';
import 'package:tiktok_clone/widgets/input_text_widgets.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  String facebook = "";
  String youtube = "";
  String instagram = "";
  String twitter = "";
  String userImageUrl = "";

  TextEditingController facebookTextEditingController = TextEditingController();
  TextEditingController youtubeTextEditingController = TextEditingController();
  TextEditingController instagramTextEditingController =
      TextEditingController();
  TextEditingController twitterTextEditingController = TextEditingController();
  ProfileController controllerProfile = Get.put(ProfileController());

  getCurrentUserData() async {
    //get the current user data
    DocumentSnapshot snapshotUser = await FirebaseFirestore.instance
        .collection("users")
        .doc("currentUserID")
        .get();

    facebook = snapshotUser["facebook"];
    youtube = snapshotUser["youtube"];
    instagram = snapshotUser["instagram"];
    twitter = snapshotUser["twitter"];
    userImageUrl = snapshotUser["image"];

    setState(() {
      facebookTextEditingController.text = facebook == null ? "" : facebook;
      youtubeTextEditingController.text = youtube == null ? "" : youtube;
      instagramTextEditingController.text = instagram == null ? "" : instagram;
      twitterTextEditingController.text = twitter == null ? "" : twitter;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controllerProfile) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              "Account Settings",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      controllerProfile.userMap['userImage'],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Update your profile social links",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //facebook
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController: facebookTextEditingController,
                      lableString: "facebook.com/username",
                      assetReference: "images/facebook.png",
                      isObscure: false,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  //youtube
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController: youtubeTextEditingController,
                      lableString: "m.youtube.com/c/username",
                      assetReference: "images/youtube.png",
                      isObscure: false,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //instagram
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController: instagramTextEditingController,
                      lableString: "instagram.com/username",
                      assetReference: "images/instagram.png",
                      isObscure: false,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //twitter
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: InputTextWidget(
                      textEditingController: twitterTextEditingController,
                      lableString: "twitter.com/username",
                      assetReference: "images/twitter.png",
                      isObscure: false,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //update button

                  ElevatedButton(
                    child: const Text(
                      "Update Now",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      controllerProfile.updateUserSocialAccountLinks(
                        facebookTextEditingController.text,
                        youtubeTextEditingController.text,
                        instagramTextEditingController.text,
                        twitterTextEditingController.text,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
