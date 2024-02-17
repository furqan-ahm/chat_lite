

import 'package:e2ee_chat/models/message.dart';

class ChatRoom {
  String? chatRoomId;
  List<String>? memberIds;
  Message? lastMessage;

  ChatRoom({this.chatRoomId, this.memberIds});

  ChatRoom.fromMap(Map<String, dynamic> mapData) {
    chatRoomId = mapData['chatId'];
    memberIds = (mapData['memberIds'] as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    lastMessage =
        Message.fromMap(mapData['lastMessage'] as Map<String, dynamic>);
  }
}