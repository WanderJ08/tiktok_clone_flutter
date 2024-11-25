import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController instanceAuth = Get.find();

  late Rx<File?> _pickedFile;
  File? get profileImage => _pickedFile.value;

  void chooseImageFromGallery() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      Get.snackbar("Profile Image",
          "you have successfully selected yout profile image.");
    }
    _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }

  void captureImageWithCamera() async {
    final pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImageFile != null) {
      Get.snackbar("Profile Image",
          "you have successfully captured your profile image with Phone Camera.");
    }
    _pickedFile = Rx<File?>(File(pickedImageFile!.path));
  }

  void createAccountforNewUser(File imageFile, String userName,
      String userEmail, String userPassword) async {
    //create user in the firebase authentication
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userEmail, password: userPassword);
    //save the user profile image to firesebase storage
    String imageDownloadUrl = await uploadImageToStorage(imageFile);
    //save user data to the firestore database
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("Profile_Images")
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrlOfUploadedImage = await taskSnapshot.ref.getDownloadURL();

    return downloadUrlOfUploadedImage;
  }
}
