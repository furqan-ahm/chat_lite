import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/services/encryption_service.dart';

class Message {
  final AppUser? sender;
  final AppUser? reciever;
  final String? text;
  final bool? unread;
  final DateTime? time;

  Message({
    required this.sender,
    required this.reciever,
    required this.text,
    required this.unread,
    required this.time,
  });

  static Message fromMap(Map<String, dynamic> mapData) => Message(
        sender: AppUser.fromMap(mapData['sender']),
        reciever: AppUser.fromMap(mapData['receiver']),
        text: mapData['content'] ?? 'Error',
        unread: mapData['unread'] ?? false,
        time: (mapData['time'] as Timestamp).toDate(),
      );

  static Future<Message> fromEncryptedMap(Map<String, dynamic> mapData) async {
    AppUser sender = AppUser.fromMap(mapData['sender']);

    var encryptedData = EncryptedData.fromJson(mapData['content']);
    return Message(
      sender: sender,
      reciever: AppUser.fromMap(mapData['receiver']),
      text: await E2EncryptionService.instance
          .decrypt(encryptedData, sender.publicKey),
      unread: mapData['unread'] ?? false,
      time: (mapData['time'] as Timestamp).toDate(),
    );
  }

  toMap() {
    return {
      'sender': sender!.toMap(),
      'receiver': reciever!.toMap(),
      'senderId': sender!.uid,
      'content': text,
      'unread': unread,
      'time': time?.toUtc()
    };
  }

  toEncryptedMap() async {
    return {
      'sender': sender!.toMap(),
      'receiver': reciever!.toMap(),
      'senderId': sender!.uid,
      'content': (await E2EncryptionService.instance
              .encrypt(reciever!.publicKey, text!))
          .toJson(),
      'unread': unread,
      'time': time?.toUtc()
    };
  }
}
