import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/home/profile/followersScreen/followers_screen.dart';
import 'package:tiktok_clone/home/profile/followingScreen/following_screen.dart';
import 'package:tiktok_clone/home/profile/profile_controller.dart';
import 'package:tiktok_clone/home/profile/video_player_profile.dart';
import 'package:tiktok_clone/settings/account_settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  String? visitUserID;

  ProfileScreen({this.visitUserID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController controllerProfile = Get.put(ProfileController());
  bool isFollowingUser = false;

  @override
  void initState() {
    // TODO: implement initState

    controllerProfile.updateCurrentUserID(widget.visitUserID.toString());
    getIsFollowingValue();
  }

  getIsFollowingValue() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.visitUserID.toString())
        .collection("followers")
        .doc(currentUserId)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          isFollowingUser = true;
        });
      } else {
        setState(() {
          isFollowingUser = false;
        });
      }
    });
  }

  Future<void> launchUserSocialProfile(String socialLink) async {
    if (!await launchUrl(Uri.parse("https://" + socialLink))) {
      throw Exception("Could not launch" + socialLink);
    }
  }

  handleClickEvent(String choiceClicked) {
    switch (choiceClicked) {
      case "Settings":
        Get.to(AccountSettingsScreen());
        break;
      case "Logout":
        FirebaseAuth.instance.signOut();
        Get.snackbar("Logged Out", "You are successfully logged out");
        Future.delayed(const Duration(milliseconds: 1000), () {
          SystemChannels.platform.invokeMethod("SystemNavigator.pop");
        });
        break;
    }
  }

  readClickedThumbnailInfo(String clickedThumbnailUrl) async {
    var allVideosDocs =
        await FirebaseFirestore.instance.collection("videos").get();

    for (int i = 0; i < allVideosDocs.docs.length; i++) {
      if ((allVideosDocs.docs[i].data() as dynamic)["thumbnailUrl"] ==
          clickedThumbnailUrl) {
        Get.to(
          () => VideoPlayerProfile(
              clickedVideoID:
                  (allVideosDocs.docs[i].data() as dynamic)["videoID"]),
        );
      }
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
            actions: [
              widget.visitUserID.toString() == currentUserId
                  ? PopupMenuButton<String>(
                      onSelected: handleClickEvent,
                      itemBuilder: (BuildContext context) {
                        return {
                          "Settings",
                          "Logout",
                        }.map((String choiseClicked) {
                          return PopupMenuItem<String>(
                            value: choiseClicked,
                            child: Text(choiseClicked),
                          );
                        }).toList();
                      },
                    )
                  : Container(),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      controllerProfile.userMap['userImage'],
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
                        onTap: () {
                          Get.to(
                            FollowingScreen(
                                visitedProfileUserID:
                                    widget.visitUserID.toString()),
                          );
                        },
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
                        onTap: () {
                          Get.to(
                            FollowersScreen(
                                visitedProfileUserID:
                                    widget.visitUserID.toString()),
                          );
                        },
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
                  const SizedBox(
                    height: 16,
                  ),
                  //Follow - unfolow - signout
                  ElevatedButton(
                    onPressed: () {
                      //if it is the user own profile - user view his/her own profile
                      //signout
                      if (widget.visitUserID.toString() == currentUserId) {
                        FirebaseAuth.instance.signOut();
                        Get.snackbar(
                            "Logged Out", "You are successfully logged out");
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          SystemChannels.platform
                              .invokeMethod("SystemNavigator.pop");
                        });
                      }
                      //user view other user profile
                      //follow - unfollow button
                      else {
                        //if already i am following other user
                        //unfollow button
                        if (isFollowingUser == true) {
                          setState(() {
                            isFollowingUser = false;
                          });
                        }
                        //if im not already following other user
                        //follow button
                        else {
                          setState(() {
                            isFollowingUser = true;
                          });
                        }
                        controllerProfile.followUnFollowUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 90,
                      ),
                      shape: widget.visitUserID.toString() == currentUserId
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(color: Colors.red),
                            )
                          : isFollowingUser == true
                              ? RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: const BorderSide(color: Colors.red),
                                )
                              : RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: const BorderSide(color: Colors.green),
                                ),
                    ),
                    child: Text(
                      widget.visitUserID.toString() == currentUserId
                          ? "Sign Out"
                          : isFollowingUser == true
                              ? "Unfollow"
                              : "Follow",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //user's videos - thumnails
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        controllerProfile.userMap["thumnailsList"].length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: .7,
                      crossAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      String eachThumbnailUrl =
                          controllerProfile.userMap["thumnailsList"][index];

                      return GestureDetector(
                        onTap: () {
                          readClickedThumbnailInfo(eachThumbnailUrl);
                        },
                        child: Image.network(
                          eachThumbnailUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
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
