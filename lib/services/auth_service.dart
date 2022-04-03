import 'package:chat_lite/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  chatUser? _getMyUser(User? user) {
    return user != null ? chatUser(userId: user.uid) : null;
  }

  Stream<chatUser?> get user {
    return _auth.authStateChanges()
        .map(_getMyUser);
  }

  Future signInWithEmailAndPassword(String email, String pass) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: pass);
      User? user = credential.user;
      return _getMyUser(user);
    }
    catch (e) {
      print('Unable to Sign In' + e.toString());
      if (e is FirebaseAuthException) {
        String code = e.code;
        switch(code){
          case'wrong-password':
            code='incorrect password';
            break;
          case'invalid-email':
            code='invalid email';
            break;
          case 'user-not-found':
            code='user not found';
            break;
        }
        return code;
      }
      return e.toString();
    }
  }

  Future signUpWithEmailAndPassword(String email, String pass) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User? user = credential.user;
      return _getMyUser(user);
    }
    catch (e) {
      print('Unable to Sign Up' + e.toString());
      if (e is FirebaseAuthException) {
        String code = e.code;
        switch (code) {
          case'invalid-email':
            code = 'invalid username';
            break;
          case 'email-already-in-use':
            code = 'email is already in use';
            break;
        }
        return code;
      }
      return e.toString();
    }
  }
    Future resetPassword(String email) async {
      try {
        return await _auth.sendPasswordResetEmail(email: email);
      }
      catch (e) {
        return e.toString();
      }
    }

    Future signOut() async {
      try {
        return await _auth.signOut();
      } catch (e) {
        return e.toString();
      }
    }
  }

