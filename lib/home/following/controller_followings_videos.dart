import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:get/get.dart";
import 'package:tiktok_clone/global.dart';
import '../upload_video/video.dart';

class ControllerFollowingVideos extends GetxController {
  final Rx<List<Video>> followingVideosList = Rx<List<Video>>([]);
  List<Video> get followingAllVideosList => followingVideosList.value;
  List<String> followingKeysList = [];

  @override
  void onInit() {
    super.onInit();
    getFollowingPersonsVideos();
  }

  getFollowingPersonsVideos() async {
    //1. get the followers
    var followingDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .collection("following")
        .get();

    for (int i = 0; i < followingDocument.docs.length; i++) {
      followingKeysList.add(followingDocument.docs[i].id);
    }

    //2. get videos of the following users
    followingVideosList.bindStream(
      FirebaseFirestore.instance
          .collection("videos")
          .orderBy("publishedDateTime", descending: true)
          .snapshots()
          .map((QuerySnapshot snapshotVideo) {
        List<Video> followingPersonsVideos = [];

        for (var eachVideo in snapshotVideo.docs) {
          for (int i = 0; i < followingKeysList.length; i++) {
            String followingPersonID = followingKeysList[i];
            if (eachVideo["userID"] == followingPersonID) {
              followingPersonsVideos.add(Video.fromDocumentSnapshot(eachVideo));
            }
          }
        }

        return followingPersonsVideos;
      }),
    );
  }

  likeOrUnlikeVideo(String videoID) async {
    var currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();

    DocumentSnapshot snapshotDoc = await FirebaseFirestore.instance
        .collection("videos")
        .doc(videoID)
        .get();

    //if already liked or not liked
    if ((snapshotDoc.data() as dynamic)["likesList"].contains(currentUserID)) {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoID)
          .update({
        "likesList": FieldValue.arrayRemove([currentUserID]),
      });
      //if not like
    } else {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoID)
          .update({
        "likesList": FieldValue.arrayUnion([currentUserID]),
      });
    }
  }
}
