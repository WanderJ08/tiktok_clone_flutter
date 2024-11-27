import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

class UploadController extends GetxController {
  compressVideoFile(String videoFilePath) async {
    final compressVideoFilePath = await VideoCompress.compressVideo(
        videoFilePath,
        quality: VideoQuality.MediumQuality);
    return compressVideoFilePath!.file;
  }

  uploadCompressedVideoFiletoFirebaseStorage(
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
}
