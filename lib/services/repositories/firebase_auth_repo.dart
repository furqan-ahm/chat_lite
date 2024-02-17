import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/resources/firestore_collections.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthRepository {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();

  static Future<AppUser?> getAuthUser() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      AppUser? user = await _getCurrentUser(firebaseUser.uid);
      return user;
    } else {
      return null;
    }
  }

  static Future<AppUser?> _getCurrentUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument = await firestore
        .collection(FirebaseCollections.usersCollection)
        .doc(uid)
        .get();
    if (userDocument.data() != null && userDocument.exists) {
      return AppUser.fromMap(userDocument.data()!);
    } else {
      return null;
    }
  }

  /// save a new user document in the USERS table in firebase firestore
  /// returns an error message on failure or null on success
  static Future<String?> createNewUser(AppUser user) async => await firestore
      .collection(FirebaseCollections.usersCollection)
      .doc(user.uid)
      .set(
        user.toMap(),
      )
      .then(
        (value) => null,
        onError: (e) => e,
      );

  static Future<AppUser> updateCurrentUser(AppUser user) async {
    return await firestore
        .collection(FirebaseCollections.usersCollection)
        .doc(user.uid)
        .set(user.toMap())
        .then((document) {
      return user;
    });
  }

  // static Future<String> uploadUserImageToServer(
  //   Uint8List imageData,
  //   String userID,
  // ) async {
  //   Reference upload = storage.child("images/$userID.png");
  //   UploadTask uploadTask =
  //       upload.putData(imageData, SettableMetadata(contentType: 'image/jpeg'));
  //   var downloadUrl =
  //       await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
  //   return downloadUrl.toString();
  // }

  /// login with email and password with firebase
  /// @param email user email
  /// @param password user password
  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if(!result.user!.emailVerified){
        return result;
      }
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection(FirebaseCollections.usersCollection)
          .doc(result.user?.uid ?? '')
          .get();
      AppUser? user;
      if (documentSnapshot.exists) {
        user = AppUser.fromMap(documentSnapshot.data() ?? {});
      }
      else {
        return result;
      }
      return user;
    } on auth.FirebaseAuthException catch (exception, s) {
      debugPrint('$exception$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.';
        case 'wrong-password':
          return 'Wrong password.';
        case 'user-not-found':
          return 'No user corresponding to the given email address.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.';
      }
      return 'Unexpected firebase error, Please try again.';
    } catch (e, s) {
      debugPrint('$e$s');
      return 'Login failed, Please try again.';
    }
  }

  // static Future<dynamic> linkCredentials(
  //     auth.UserCredential emailPassCredentials,
  //     auth.PhoneAuthCredential phoneAuthCredential,
  //     String phoneNumber) async {
  //   try {
  //     emailPassCredentials.user
  //         ?.linkWithCredential(phoneAuthCredential)
  //         .then((value) => value);
  //   } on auth.FirebaseAuthException catch (exception, s) {
  //     debugPrint('$exception$s');
  //     switch ((exception).code) {
  //       case 'invalid-email':
  //         return 'Email address is malformed.';
  //       case 'wrong-password':
  //         return 'Wrong password.';
  //       case 'user-not-found':
  //         return 'No user corresponding to the given email address.';
  //       case 'user-disabled':
  //         return 'This user has been disabled.';
  //       case 'too-many-requests':
  //         return 'Too many attempts to sign in as this user.';
  //       case 'email-already-exists':
  //         return 'Email already exists, please register with a different email';
  //     }
  //     return 'Unexpected firebase error, Please try again.';
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return e.toString();
  //   }
  // }



  static Future<dynamic> sendPasswordResetEmail(String email)async{
    try {
      final res=await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email); 
    } on auth.FirebaseAuthException catch (error) {
      debugPrint('$error${error.stackTrace}');
      String message = 'Couldn\'t sign up';
      switch (error.code) {
        case 'user-not-found':
          message = 'There is no user registered with the given email';
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail';
          break;
        case 'operation-not-allowed':
          message = 'Unable to send email. Contact Support';
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.';
          break;
      }
      return message;
    } catch (e, s) {
      debugPrint('FireStoreUtils.signUpWithEmailAndPassword $e $s');
      return 'Couldn\'t send the email';
    }
  }

  static Future<dynamic> createEmailAndPasswordCredentials(
    String email,
    String password,
  ) async {
    try {
      auth.UserCredential credentials = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credentials;
    } on auth.FirebaseAuthException catch (error) {
      debugPrint('$error${error.stackTrace}');
      String message = 'Couldn\'t sign up';
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use, Please pick another email!';
          break;
        case 'invalid-email':
          message = 'Enter valid e-mail';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          message = 'Password must be more than 5 characters';
          break;
        case 'too-many-requests':
          message = 'Too many requests, Please try again later.';
          break;
      }
      return message;
    } catch (e, s) {
      debugPrint('FireStoreUtils.signUpWithEmailAndPassword $e $s');
      return 'Couldn\'t sign up';
    }
  }

  // static Future<dynamic> register({
  //   required String email,
  //   required String password,
  //   required String phoneNumber,
  //   required String name,
  // }) async {
  //   try {
  //     //create credentials of email and password,
  //     auth.UserCredential emailAndPasswordCredentials =
  //         await createEmailAndPasswordCredentials(email, password);
  //     if (emailAndPasswordCredentials is String) {
  //       return emailAndPasswordCredentials;
  //     }

  //     //if successful, then create phoneAuth credentials and link between two,
  //     //finally save the user to the database and return user

  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // static signUpWithEmailAndPassword({
  //   required String emailAddress,
  //   required String password,
  //   Uint8List? imageData,
  //   required String name,
  //   required String contactNumber,
  // }) async {
  //   try {
  //     auth.UserCredential result = await auth.FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: emailAddress, password: password);
  //     String profilePicUrl = '';
  //     if (imageData != null) {
  //       // updateProgress('Uploading image, Please wait...');
  //       profilePicUrl =
  //           await uploadUserImageToServer(imageData, result.user?.uid ?? '');
  //     }
  //     AppUser user = AppUser(
  //       email: emailAddress,
  //       name: name,
  //       uid: result.user?.uid ?? '',
  //       profilePictureURL: profilePicUrl,
  //       contactNum: contactNumber,
  //     );
  //     String? errorMessage = await createNewUser(user);
  //     if (errorMessage == null) {
  //       return user;
  //     } else {
  //       return 'Couldn\'t sign up for firebase, Please try again.';
  //     }
  //   } on auth.FirebaseAuthException catch (error) {
  //     debugPrint('$error${error.stackTrace}');
  //     String message = 'Couldn\'t sign up';
  //     switch (error.code) {
  //       case 'email-already-in-use':
  //         message = 'Email already in use, Please pick another email!';
  //         break;
  //       case 'invalid-email':
  //         message = 'Enter valid e-mail';
  //         break;
  //       case 'operation-not-allowed':
  //         message = 'Email/password accounts are not enabled';
  //         break;
  //       case 'weak-password':
  //         message = 'Password must be more than 5 characters';
  //         break;
  //       case 'too-many-requests':
  //         message = 'Too many requests, Please try again later.';
  //         break;
  //     }
  //     return message;
  //   } catch (e, s) {
  //     debugPrint('FireStoreUtils.signUpWithEmailAndPassword $e $s');
  //     return 'Couldn\'t sign up';
  //   }
  // }

  /////// GOOGLE SIGN IN ///////
  // static Future<dynamic> loginWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;


  //     bool isLogged =
  //         googleAuth?.accessToken != null && googleAuth?.idToken != null;
  //     AppUser? user;


  //     if (isLogged) {
  //       // Create a new credential
  //       final googleCredential = auth.GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken,
  //         idToken: googleAuth?.idToken,
  //       );


  //       //signing in with the credentials
  //       final auth.UserCredential credential = await auth.FirebaseAuth.instance
  //           .signInWithCredential(googleCredential);
        

  //       //trying to see if the user already exists, if that's the case, then returing that user
  //       user = await _getCurrentUser(credential.user?.uid ?? '');

  //       if (user != null) {
  //         return user;
  //       }

  //       // otherwise creating a new user using our model and also updating or adding to the firestore database
        
  //       return credential;
  //       // user = AppUser(
  //       //   uid: credential.user?.uid ?? '',
  //       //   name: credential.user?.displayName ?? '',
  //       //   address: {},
  //       //   contactNum: credential.user?.phoneNumber ?? '',
  //       //   email: credential.user?.email ?? '',
  //       //   profilePictureURL: credential.user?.photoURL ?? '',
  //       // );

  //       // if there's some problem creating the user then the function _createNewUser
  //       // function will return a string otherwise if it returns null,
  //       // then it is safe to say that our new user is created and stored in firestore db
  //       // String? errorMessage = await createNewUser(user);
  //       // if (errorMessage == null) {
  //       //   return user;
  //       // } else {
  //       //   return 'Couldn\'t create new user with phone number.';
  //       // }
  //     }
  //   } on auth.FirebaseAuthException catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     //TODO: add more exceptions and messages accordingly
  //     String message = "Could'nt Sign in";

  //     return message;
  //   } on PlatformException catch (e) {
  //     if (e.code == 'sign_in_failed') {
  //       return 'Google sign in not available because google play services not found';
  //     }
  //     debugPrint(e.message);
  //     return 'Platfrom Exception';
  //     // return e.code.toString();
  //   } catch (e, s) {
  //     debugPrint('$e$s');
  //     return 'Login failed, Please try again.';
  //   }
  // }

// Logout/signout
  static Future<dynamic> logout() async {
    try {
      await auth.FirebaseAuth.instance.signOut();
    } catch (e) {
      return e.toString();
    }
  }

  // static resetPassword(String emailAddress) async =>
  //     await auth.FirebaseAuth.instance
  //         .sendPasswordResetEmail(email: emailAddress);

}