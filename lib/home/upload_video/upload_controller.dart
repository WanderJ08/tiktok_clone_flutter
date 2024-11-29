import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/home/home_screen.dart';
import 'package:tiktok_clone/home/upload_video/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController {
  compressVideoFile(String videoFilePath) async {
    final compressVideoFilePath = await VideoCompress.compressVideo(
        videoFilePath,
        quality: VideoQuality.LowQuality);
    return compressVideoFilePath!.file;
  }

  uploadCompressedVideoFileToFirebaseStorage(
      String videoID, String videoFilePath) async {
    UploadTask videoUploadTask = FirebaseStorage.instance
        .ref()
        .child("All Videos")
        .child(videoID)
        .putFile(await compressVideoFile(videoFilePath));

    TaskSnapshot snapshot = await videoUploadTask;

    String dowloadUrlOfUploadedVideo = await snapshot.ref.getDownloadURL();

    return dowloadUrlOfUploadedVideo;
  }

  getThumbnailImage(String videoFilePath) async {
    final thumbnailImage = await VideoCompress.getFileThumbnail(videoFilePath);
    return thumbnailImage;
  }

  uploadThumbnailImagetoFirebaseStorage(
      String videoID, String videoFilePath) async {
    UploadTask thumbnailUploadTask = FirebaseStorage.instance
        .ref()
        .child("All Thumbnails")
        .child(videoID)
        .putFile(await getThumbnailImage(videoFilePath));

    TaskSnapshot snapshot = await thumbnailUploadTask;

    String dowloadUrlOfUploadedThumbnail = await snapshot.ref.getDownloadURL();

    return dowloadUrlOfUploadedThumbnail;
  }

  saveVideoInformationToFirestoreDatabase(
      String artistSongName,
      String descriptionTags,
      String videoFilePath,
      BuildContext context) async {
    try {
      DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      String videoID = DateTime.now().millisecondsSinceEpoch.toString();

      //1. Upload video to firebase storage
      String videoDownloadUrl =
          await uploadCompressedVideoFileToFirebaseStorage(
              videoID, videoFilePath);
      //2.Upload thumbnail to firebase storage
      String thumbnailDownloadUrl =
          await uploadThumbnailImagetoFirebaseStorage(videoID, videoFilePath);

      //3. Save video information to firestore database
      Video videoObject = Video(
        userID: FirebaseAuth.instance.currentUser!.uid,
        userName: (userDocumentSnapshot.data() as Map<String, dynamic>)["name"],
        userProfileImage:
            (userDocumentSnapshot.data() as Map<String, dynamic>)["image"],
        videoID: videoID,
        totalComments: 0,
        totalShares: 0,
        likesList: [],
        artistSongName: artistSongName,
        descriptionTags: descriptionTags,
        videoUrl: videoDownloadUrl,
        thumbnailUrl: thumbnailDownloadUrl,
        publishedDateTime: DateTime.now().millisecondsSinceEpoch,
      );
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoID)
          .set(videoObject.toJson());

      Get.to(HomeScreen());

      Get.snackbar("New Video", "You have successfully uploaded a new video");
    } catch (errorMsg) {
      Get.snackbar("Video Upload Unsuccessfull",
          "Error ocurred, your video is not uploaded. Try Again");
    }
  }
}
