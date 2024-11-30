import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/home/profile/profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController controllerProfile = Get.put(ProfileController());
  @override
  void initState() {
    // TODO: implement initState

    controllerProfile
        .updateCurrentUserID(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> launchUserSocialProfile(String socialLink) async {
    if (!await launchUrl(Uri.parse("https://" + socialLink))) {
      throw Exception("Could not launch" + socialLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controllerProfile) {
        if (controllerProfile.userMap.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: Text(
              controllerProfile.userMap['userName'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.network(
                      controllerProfile.userMap['userImage'],
                      height: 100,
                      width: 120,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //Followers and Following - likes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //following
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap["totalFollowings"]
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              "Following",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.black54,
                        width: 1,
                        height: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      //followers
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap["totalFollowers"]
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              "Followers",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.black54,
                        width: 1,
                        height: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      //Likes
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                              controllerProfile.userMap["totalLikes"]
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              "Likes",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //user Social links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //facebook
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap['userFacebook'] == "") {
                            Get.snackbar("Facebook Profile",
                                "This user has not connected his/her Facebook account yet");
                          } else {
                            launchUserSocialProfile(
                                controllerProfile.userMap['userFacebook']);
                          }
                        },
                        child: Image.asset(
                          "images/facebook.png",
                          width: 50,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //instagram
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap['userInstagram'] ==
                              "") {
                            Get.snackbar("Instagram Profile",
                                "This user has not connected his/her Instagram account yet");
                          } else {
                            launchUserSocialProfile(
                                controllerProfile.userMap['userInstagram']);
                          }
                        },
                        child: Image.asset(
                          "images/instagram.png",
                          width: 50,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //twitter
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap['userTwitter'] == "") {
                            Get.snackbar("Twitter Profile",
                                "This user has not connected his/her Twitter account yet");
                          } else {
                            launchUserSocialProfile(
                                controllerProfile.userMap['userTwitter']);
                          }
                        },
                        child: Image.asset(
                          "images/twitter.png",
                          width: 50,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //youtube
                      GestureDetector(
                        onTap: () {
                          if (controllerProfile.userMap['userYoutube'] == "") {
                            Get.snackbar("Youtube Profile",
                                "This user has not connected his/her Youtube account yet");
                          } else {
                            launchUserSocialProfile(
                                controllerProfile.userMap['userYoutube']);
                          }
                        },
                        child: Image.asset(
                          "images/youtube.png",
                          width: 50,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
