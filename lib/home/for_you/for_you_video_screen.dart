import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
              ],
            );
          },
        );
      }),
    );
  }
}
