import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userMap => _userMap.value;
  Rx<String> _userID = "".obs;

  updateCurrentUserID(String visitUserID) {
    _userID.value = visitUserID;

    retrieveUserInformation();
  }

  retrieveUserInformation() async {
    //get user info
    DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userID.value)
        .get();

    final userInfo = userDocumentSnapshot.data() as dynamic;

    String userName = userInfo["name"];
    String userEmail = userInfo["email"];
    String userImage = userInfo["image"];
    String userUID = userInfo["uid"];
    String userYoutube = userInfo["youtube"] == null ? "" : userInfo["youtube"];
    String userInstagram =
        userInfo["instagram"] == null ? "" : userInfo["instagram"];
    String userTwitter = userInfo["twitter"] == null ? "" : userInfo["twitter"];
    String userFacebook =
        userInfo["facebook"] == null ? "" : userInfo["facebook"];

    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = false;
    List<String> thumbnailsList = [];

    //get the users videos info
    var currentUserVideos = await FirebaseFirestore.instance
        .collection("videos")
        .orderBy("publishedDateTime", descending: true)
        .where("userID", isEqualTo: _userID.value)
        .get();

    for (int i = 0; i < currentUserVideos.docs.length; i++) {
      thumbnailsList
          .add((currentUserVideos.docs[i].data() as dynamic)["thumbnailUrl"]);
    }

    //get total number of followers
    var followersNumDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .collection("followers")
        .get();

    totalFollowers = followersNumDocument.docs.length;

    //get total number of followings
    var followingsNumDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .collection("following")
        .get();

    totalFollowings = followingsNumDocument.docs.length;

    //get the isFollowing true or false value
    //check if online currentuserID exists in the followers list of the visitprofile person
    FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .collection("followers")
        .doc(currentUserId)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _userMap.value = {
      "userName": userName,
      "userEmail": userEmail,
      "userImage": userImage,
      "userIUD": userUID,
      "userYoutube": userYoutube,
      "userInstagram": userInstagram,
      "userTwitter": userTwitter,
      "userFacebook": userFacebook,
      "totalLikes": totalLikes.toString(),
      "totalFollowers": totalFollowers.toString(),
      "totalFollowings": totalFollowings.toString(),
      "isFollowing": isFollowing,
      "thumnailsList": thumbnailsList,
    };
    update();
  }

  followUnFollowUser() async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .collection("followers")
        .doc(currentUserId)
        .get();

    // Si el usuario ya sigue al otro
    if (document.exists) {
      // Eliminar de seguidores
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userID.value)
          .collection("followers")
          .doc(currentUserId)
          .delete();

      // Eliminar de siguiendo
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .collection("following")
          .doc(_userID.value)
          .delete();

      _userMap.value.update(
          "totalFollowers", (value) => (int.parse(value) - 1).toString());
      _userMap.value
          .update("isFollowing", (_) => false); // Actualizar isFollowing
    } else {
      // Agregar a seguidores
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userID.value)
          .collection("followers")
          .doc(currentUserId)
          .set({});

      // Agregar a siguiendo
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .collection("following")
          .doc(_userID.value)
          .set({});

      _userMap.value.update(
          "totalFollowers", (value) => (int.parse(value) + 1).toString());
      _userMap.value
          .update("isFollowing", (_) => true); // Actualizar isFollowing
    }

    update(); // Notificar cambios
  }
}
