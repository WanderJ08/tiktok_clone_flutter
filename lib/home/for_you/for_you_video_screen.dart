import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/home/for_you/controller_for_you_videos.dart';
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
                //video
                CustomVideoPlayer(
                  videoFileUrl: eachVideoInfo.videoUrl.toString(),
                ),

                //left right - panels
                Column(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //left panel
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.only(left: 22),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //USERNAME
                              Text(
                                "@" + eachVideoInfo.userName.toString(),
                                style: GoogleFonts.abel(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),

                              const SizedBox(height: 6),
                              //description = tags
                              Text(
                                "@" + eachVideoInfo.descriptionTags.toString(),
                                style: GoogleFonts.abel(
                                    fontSize: 18, color: Colors.white),
                              ),

                              const SizedBox(height: 6),

                              //artist song name
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
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ))
                      ],
                    ))
                  ],
                )
              ],
            );
          },
        );
      }),
    );
  }
}
