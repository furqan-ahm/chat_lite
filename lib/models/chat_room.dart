import 'package:e2ee_chat/models/message.dart';

class ChatRoom {
  String? chatRoomId;
  List<String>? memberIds;
  Map<String, List<int>> publicKeys;
  Message? lastMessage;

  ChatRoom(
      {this.chatRoomId,
      this.memberIds,
      this.lastMessage,
      required this.publicKeys});

  factory ChatRoom.fromMap(Map<String, dynamic> mapData) {
    return ChatRoom(
      chatRoomId: mapData['chatId'],
      publicKeys: mapData['publicKeys'],
      lastMessage:
          Message.fromMap(mapData['lastMessage'] as Map<String, dynamic>),
      memberIds: (mapData['memberIds'] as List<dynamic>)
          .map((e) => (e as String))
          .toList(),
    );
  }
}
