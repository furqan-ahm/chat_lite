import 'dart:async';
import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/providers/user_state_provider.dart';
import 'package:e2ee_chat/screens/auth/welcome_screen.dart';
import 'package:e2ee_chat/screens/main/main_screen.dart';
import 'package:e2ee_chat/services/encryption_service.dart';
import 'package:e2ee_chat/services/repositories/firebase_auth_repo.dart';
import 'package:e2ee_chat/services/repositories/firebase_storage_repo.dart';
import 'package:e2ee_chat/services/repositories/firestore_repo.dart';
import 'package:e2ee_chat/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MyAuthProvider extends ChangeNotifier {
  bool get emailVerified => FirebaseAuth.instance.currentUser!.emailVerified;

  static MyAuthProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyAuthProvider>(context, listen: listen);

  refreshVerificationStatus() {
    FirebaseAuth.instance.currentUser!
        .reload()
        .then((value) => notifyListeners());
  }

  Future<AppUser?> refreshUser() async {
    _currentUser = await FirebaseAuthRepository.getAuthUser();

    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null && _currentUser != null) {
        FirestoreRepository.setNotificationToken(_currentUser!.uid, token);
      }
    });

    notifyListeners();
    return _currentUser;
  }

  UserCredential? registerationPhoneUser;

  String verificationID = '';

  setPhoneAuthCredential(UserCredential credential) {
    registerationPhoneUser = credential;
    notifyListeners();
  }

  bool get isPhoneNumberVerified =>
      FirebaseAuth.instance.currentUser!.phoneNumber ==
      _currentUser!.contactNum;

  AppUser? _currentUser;

  AppUser get currentUser => _currentUser!;

  Future<bool> signIn(String email, String password, BuildContext context,
      {required bool rememberMe}) async {
    await FirebaseAuthRepository.loginWithEmailAndPassword(email, password)
        .then((value) async {
      if (value is AppUser) {
        _currentUser = value;

        await E2EncryptionService.instance.initialize(uid: value.uid);
        FirebaseMessaging.instance.getToken().then((token) {
          if (token != null) {
            FirestoreRepository.setNotificationToken(value.uid, token);
          }
        });

        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const MainScreen(),
            ),
            (route) => false);
        // Navigator.pushNamedAndRemoveUntil(
        //     context, RouteName.mainScreen, (route) => false);
      } else {
        if (value is UserCredential) {
          await E2EncryptionService.instance.initialize(uid: value.user!.uid);
          // if (value.user!.emailVerified) {
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const MainScreen(),
              ));
          // } else {
          //   Navigator.push(
          //       context,
          //       PageTransition(
          //         type: PageTransitionType.rightToLeft,
          //         child: VerifyEmailScreen(
          //           userCredentials: value,
          //         ),
          //       ));
          // }
          return;
        }
        Utils.showSnackbar(value.toString(), context);
      }
    });
    return true;
  }

  Future<bool> sendPasswordResetEmail(
      String email, BuildContext context) async {
    final res = await FirebaseAuthRepository.sendPasswordResetEmail(email);

    if (res is String) {
      Utils.showSnackbar(res, context);
      return false;
    }

    return true;
  }

  Future<void> signOut(BuildContext context) async {
    FirestoreRepository.setNotificationToken(currentUser.uid, '');
    // GoogleSignIn().disconnect();
    FirebaseAuthRepository.logout().then((value) async {
      if (value is String) {
        Utils.showSnackbar(value.toString(), context);
      } else {
        _currentUser = null;
        registerationPhoneUser = null;
        // Update user session
        final userStateProvider =
            Provider.of<UserStateProvider>(context, listen: false);
        userStateProvider.deleteLoginSharedPreference();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            ),
            (route) => false);
        // Navigator.pushNamedAndRemoveUntil(
        //     context, RouteName.getStarted, (route) => false);
      }
    }).onError(
        (error, stackTrace) => Utils.showSnackbar(error.toString(), context));
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password,
      {required bool rememberMe}) async {
    final result =
        await FirebaseAuthRepository.createEmailAndPasswordCredentials(
            email, password);
    if (result is String) {
      Utils.showSnackbar(result.toString(), context);
    } else {
      UserCredential emailAndPasswordCredentials = result;

      await E2EncryptionService.instance
          .initialize(uid: emailAndPasswordCredentials.user!.uid);
      return emailAndPasswordCredentials;
    }
    return null;
  }

  Future<bool> updateUserProfile(AppUser user, {String? imgPath}) async {
    try {
      if (imgPath != null) {
        user.profilePictureURL =
            (await uploadProfileImage(user.uid, imgPath)) ??
                user.profilePictureURL;
      }
      final result = await FirebaseAuthRepository.updateCurrentUser(user);
      _currentUser = result;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fillUserProfile({
    required BuildContext context,
    required UserCredential credentials,
    required String name,
    required String nickname,
    required DateTime dob,
    String? imgPath,
    required String email,
    String? notificationToken,
    required String phoneNumber,
  }) async {
    String? token = await FirebaseMessaging.instance.getToken();

    var publicKey = await E2EncryptionService.instance.getPublicKey;

    AppUser appUser = AppUser(
      email: email,
      numberVerified: false,
      uid: credentials.user?.uid ?? '',
      name: name,
      notificationToken: token,
      dateOfBirth: dob,
      publicKey: publicKey,
      nickname: nickname,
      contactNum: phoneNumber,
    );

    if (imgPath != null) {
      appUser.profilePictureURL =
          (await uploadProfileImage(appUser.uid, imgPath)) ??
              appUser.profilePictureURL;
    }
    // print('appUser $appUser');

    await FirebaseAuthRepository.createNewUser(appUser).then((value) {
      if (value == null) {
        _currentUser = appUser;
        final userStateProvider =
            Provider.of<UserStateProvider>(context, listen: false);
        userStateProvider.saveLoginSharedPreference(true);

        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const MainScreen(),
            ),
            (route) => false);
        // Navigator.pushNamedAndRemoveUntil(
        //     context, RouteName.mainScreen, (route) => false);
      } else {
        Utils.showSnackbar('Couldn\'t create new user.', context);
      }
    });
    return true;
  }

}
