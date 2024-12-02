import 'package:firebase_auth/firebase_auth.dart';

bool showProgressBar = false;

String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
