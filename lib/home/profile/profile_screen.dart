import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/home/profile/profile_controller.dart';

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
                controllerProfile.userMap['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(children: [
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
                              "Followings",
                              style: TextStyle(
                                fontSize: 14,
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
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                color: Colors.black54,
                                width: 1,
                                height: 15,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
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
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //user Social links
                ]),
              ),
            ),
          );
        });
  }
}
