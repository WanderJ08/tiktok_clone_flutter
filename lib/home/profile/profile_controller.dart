import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userMap => _userMap.value;
  Rx<String> _userID = "".obs;

  updateCurrentUserID(String visitUserID) {
    _userID.value = visitUserID;
  }

  retrieveUserInformation() async {
    DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .get();

    final userInfo = userDocumentSnapshot.data() as dynamic;

    String userName = userInfo['name'];
    String userEmail = userInfo['email'];
    String userImage = userInfo['image'];
    String userUID = userInfo['uid'];
    String userYoutube = userInfo['youtube'];
    String userInstagram = userInfo['instagram'];
    String userTwitter = userInfo['twitter'];
    String userFacebook = userInfo['facebook'];
  }
}
