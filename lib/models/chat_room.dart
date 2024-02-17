import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e2ee_chat/models/message.dart';

class ChatRoomModel {
  String orderId;
  Message? lastMessage;
  DateTime? lastMessageTime;
  bool seen;

  ChatRoomModel(
      {required this.orderId,
      required this.lastMessage,
      required this.seen,
      required this.lastMessageTime});

  static ChatRoomModel fromMap(String id, Map data) => ChatRoomModel(
      orderId: id,
      lastMessage: Message.fromMap(data['lastMessage']),
      seen: data['admin_seen']??true,
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate());

  String get timeString {
    return '${lastMessageTime!.day}/${lastMessageTime!.month}/${lastMessageTime?.year.toString().substring(2, 4)}';
  }
}