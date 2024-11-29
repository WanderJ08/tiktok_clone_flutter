import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/home/for_you/controller_for_you_videos.dart';
import 'package:tiktok_clone/widgets/circular_image_animation.dart';
import 'package:tiktok_clone/widgets/custom_video_player.dart';

class ForYouVideoScreen extends StatefulWidget {
  const ForYouVideoScreen({super.key});

  @override
  State<ForYouVideoScreen> createState() => _ForYouVideoScreenState();
}

class _ForYouVideoScreenState extends State<ForYouVideoScreen> {
  final ControllerForYouVideos controllerVideosForYou =
      Get.put(ControllerForYouVideos());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: controllerVideosForYou.forYouAllVideosList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final eachVideoInfo =
                controllerVideosForYou.forYouAllVideosList[index];

            return Stack(
              children: [
                // Video player
                CustomVideoPlayer(
                  videoFileUrl: eachVideoInfo.videoUrl.toString(),
                ),

                // Panels (left and right)
                Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Left panel
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 22),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Username
                                  Text(
                                    "@" + eachVideoInfo.userName.toString(),
                                    style: GoogleFonts.abel(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Description tags
                                  Text(
                                    eachVideoInfo.descriptionTags.toString(),
                                    style: GoogleFonts.abel(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Artist and song name
                                  Row(
                                    children: [
                                      Image.asset(
                                        "images/music_note.png",
                                        width: 20,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "  " +
                                              eachVideoInfo.artistSongName
                                                  .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.alexBrush(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Right panel
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 4,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // User profile image
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: 62,
                                    height: 62,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 4,
                                          child: Container(
                                            width: 52,
                                            height: 52,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: Image(
                                                image: NetworkImage(
                                                  eachVideoInfo.userProfileImage
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Like button and count
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controllerVideosForYou
                                            .likeOrUnlikeVideo(eachVideoInfo
                                                .videoID
                                                .toString());
                                      },
                                      icon: Icon(
                                        Icons.favorite_rounded,
                                        size: 40,
                                        color: eachVideoInfo.likesList!
                                                .contains(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        eachVideoInfo.likesList!.length
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Comment button and count
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add_comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        eachVideoInfo.totalComments!.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Share button and count
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        eachVideoInfo.totalShares!.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                                    //profile circular animation
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: CircularImageAnimation(
                                        widgetAnimation: SizedBox(
                                          width: 62,
                                          height: 62,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                height: 52,
                                                width: 52,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                          colors: [
                                                        Colors.grey,
                                                        Colors.white,
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image(
                                                    image: NetworkImage(
                                                        eachVideoInfo
                                                            .userProfileImage
                                                            .toString()),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
