import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:get/get.dart";
import '../upload_video/video.dart';

class ControllerForYouVideos extends GetxController {
  final Rx<List<Video>> forYouVideosList = Rx<List<Video>>([]);
  List<Video> get forYouAllVideosList => forYouVideosList.value;

  @override
  void onInit() {
    super.onInit();

    forYouVideosList.bindStream(FirebaseFirestore.instance
        .collection("videos")
        .orderBy("totalComments", descending: true)
        .snapshots()
        .map((QuerySnapshot snapshotQuery) {
      List<Video> videosList = [];
      for (var eachVideo in snapshotQuery.docs) {
        videosList.add(Video.fromDocumentSnapshot(eachVideo));
      }
      return videosList;
    }));
  }
}
