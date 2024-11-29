import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/home/comments/comment.dart';

class CommentsController extends GetxController {
  String currentVideoID = "";

  updatedCurrentVideoID(String videoID) {
    currentVideoID = videoID;
  }

  saveNewCommentToDatabase(String commentTextData) async {
    //save new comment to database
    try {
      String commentID = DateTime.now().millisecondsSinceEpoch.toString();

      DocumentSnapshot snapshotUserDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Comment commentModel = Comment(
        userName: (snapshotUserDocument.data() as dynamic)["name"],
        userID: FirebaseAuth.instance.currentUser!.uid,
        userProfileImage: (snapshotUserDocument.data() as dynamic)["image"],
        commentText: commentTextData,
        commentID: commentID,
        commentLikesList: [],
        publishedDateTime: DateTime.now(),
      );
      //save new comment info to database
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoID)
          .collection("comments")
          .doc(commentID)
          .set(commentModel.toJson());

      //update comments counter
      DocumentSnapshot currentVideoSnapshotDocument = await FirebaseFirestore
          .instance
          .collection("videos")
          .doc(currentVideoID)
          .get();

      await FirebaseFirestore.instance
          .collection("videos")
          .doc(currentVideoID)
          .update({
        "totalComments":
            (currentVideoSnapshotDocument.data() as dynamic)["totalComments"] +
                1
      });
    } catch (errorMsg) {
      Get.snackbar(
          "Error In Posting New Comment", "Message:" + errorMsg.toString());
    }
  }
}