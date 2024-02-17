import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance;

Future<String?> uploadProfileImage(String uid, String imagePath) async {
  try {
    File imageFile = File(imagePath);

    final profilePicRef = storageRef.ref().child('users/$uid/profile_pic');

    await profilePicRef.putFile(imageFile);
    final imageURL = await profilePicRef.getDownloadURL();
    return imageURL;
  } catch (e) {
    print(e);
  }

  return null;
}
