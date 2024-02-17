import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e2ee_chat/models/user.dart';

class Message{

  String text;
  bool isSentByUser;
  DateTime time;
  AppUser? user;


  Message({required this.text, required this.isSentByUser, required this.time, this.user});

  static Message fromMap(data) {

    return Message(isSentByUser: data['sentByUser'],text: data['message'],time: (data['time'] as Timestamp).toDate(), user: data['user']!=null?AppUser.fromMap(data['user']):null);
  }

}

