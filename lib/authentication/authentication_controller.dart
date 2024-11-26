import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/authentication/login_screen.dart';
import 'package:tiktok_clone/global.dart';
import 'dart:io';
import 'user.dart' as userModel;
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
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);
      //save the user profile image to firesebase storage
      String imageDownloadUrl = await uploadImageToStorage(imageFile);
      //save user data to the firestore database
      userModel.User user = userModel.User(
        name: userName,
        email: userEmail,
        image: imageDownloadUrl,
        uid: credential.user!.uid,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set(user.toJson());

      Get.snackbar("Account Created",
          "Congratulations your account has been created successfully.");
    } catch (error) {
      Get.snackbar("Account creation unsuccessful",
          "Error occured while creating user account.");
      showProgressBar = false;
      Get.to(LoginScreen());
    }
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
