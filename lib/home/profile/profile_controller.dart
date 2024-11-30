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

    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = true;
    List<String> thumbnailsList = [];

    _userMap.value = {
      "name": userName,
      "email": userEmail,
      "image": userImage,
      "uid": userUID,
      "youtube": userYoutube,
      "instagram": userInstagram,
      "twitter": userTwitter,
      "facebook": userFacebook,
      "totalLikes": totalLikes,
      "totalFollowers": totalFollowers,
      "totalFollowings": totalFollowings,
      "isFollowing": isFollowing,
      "thumnailsList": thumbnailsList,
    };

    update();
  }
}
