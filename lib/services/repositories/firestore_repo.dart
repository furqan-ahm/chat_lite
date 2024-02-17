import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e2ee_chat/models/message.dart';
import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/resources/firestore_collections.dart';
import 'package:flutter/widgets.dart';

import '../../models/chat_room.dart';

class FirestoreRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // static CollectionReference chatCollection(String orderId) => _firestore
  //     .collection(FirebaseCollections.ordersCollection)
  //     .doc(orderId)
  //     .collection('chats');

  // static Stream<List<OrderChatRoom>> getOrderChatStream() => _firestore
  //     .collection(FirebaseCollections.ordersCollection)
  //     .orderBy('lastMessageTime')
  //     .snapshots()
  //     .map((event) => event.docs
  //             .where((element) => element.data()['lastMessageTime'] != null)
  //             .map((e) {
  //           return OrderChatRoom.fromMap(e.id, e.data());
  //         }).toList());

  // static Stream<List<Message>> getMessagesStream(
  //   String orderId,
  // ) =>
  //     chatCollection(orderId).orderBy('time').snapshots().map(
  //         (event) => event.docs.map((e) => Message.fromMap(e.data())).toList());

  // static Stream<List<Message>> getGeneralMessageStream(String userId) =>
  //     generalChatCollection(userId).orderBy('time').snapshots().map(
  //         (event) => event.docs.map((e) => Message.fromMap(e.data())).toList());

  // static setOrderMessageSeen(String orderId) {
  //   _firestore
  //       .collection(FirebaseCollections.ordersCollection)
  //       .doc(orderId)
  //       .set({'admin_seen': true}, SetOptions(merge: true)).onError(
  //           (error, stackTrace) => print(error));
  // }

  // static sendOrderMessage(String orderId, Map<String, Object> data) {
  //   chatCollection(orderId).add(data);
  //   _firestore
  //       .collection(FirebaseCollections.ordersCollection)
  //       .doc(orderId)
  //       .set({
  //     'lastMessage': data,
  //     'lastMessageTime': Timestamp.now(),
  //     'seen': false
  //   }, SetOptions(merge: true));
  // }

  static Stream<List<AppUser>> getUsers(String uid) {
    return _firestore
        .collection(FirebaseCollections.usersCollection).where('uid', isNotEqualTo: uid)  
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => AppUser.fromMap(e.data())).toList());
  }

  static Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Message.fromMap(e.data())).toList());
  }

  static Future<ChatRoom> createChatRoom(
      AppUser currentUser, AppUser otherUser) async {
    //creating unique id that stays same when either of users start the convo
    String chatId;
    List<String> memberIds;
    Map<String, List<int>> publicKeys = {
      currentUser.uid: currentUser.publicKey,
      otherUser.uid: otherUser.publicKey
    };

    if (currentUser.uid.compareTo(otherUser.uid) > 0) {
      chatId = currentUser.uid + otherUser.uid;
      memberIds = [currentUser.uid, otherUser.uid];
    } else {
      chatId = otherUser.uid + currentUser.uid;
      memberIds = [otherUser.uid, currentUser.uid];
    }

    ChatRoom newRoom = ChatRoom(
      chatRoomId: chatId,
      memberIds: memberIds,
      publicKeys: publicKeys,
    );

    await _firestore.collection('chatrooms').doc(chatId).set(
      {
        'chatId': chatId,
        'memberIds': memberIds,
        'publicKeys': publicKeys,
      },
      SetOptions(merge: true),
    );

    return newRoom;
  }

  // needs indexing for proper ordering
  static Stream<List<ChatRoom>> getChatRooms(String uid) {
    return _firestore
        .collection('chatrooms')
        .where('memberIds', arrayContains: uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ChatRoom.fromMap(e.data())).toList());
  }

  static Future<void> uploadMessage(String chatId, Message message) async {
    var encryptedMessage=await message.toEncryptedMap();
    
    _firestore
        .collection('chatrooms')
        .doc(chatId)
        .collection('messages')
        .add(encryptedMessage);

    _firestore.collection('chatrooms').doc(chatId).update({
      'lastMessage': encryptedMessage,
      // 'lastMessageTime': message.toEncryptedMap()['time']
    });
  }

  static Future<void> markMessagesRead(
    String chatId,
    String uid,
    Message lastMessage,
  ) async {
    _firestore
        .collection('chatrooms')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isEqualTo: uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              element.reference.update({'unread': false});
            }));

    if (lastMessage.sender!.uid != uid) return;
    var mapData = lastMessage.toMap();
    mapData['unread'] = false;
    _firestore
        .collection('chatrooms')
        .doc(chatId)
        .update({'lastMessage': mapData});
  }

  static Future<dynamic> setNotificationToken(String uid, String token) async {
    await _firestore
        .collection(FirebaseCollections.usersCollection)
        .doc(uid)
        .update({'notification_token': token});
  }

  static Future<dynamic> isRegistered(String phoneNumber) async {
    dynamic result = '';
    try {
      await _firestore
          .collection(FirebaseCollections.usersCollection)
          .where("phone", isEqualTo: phoneNumber)
          .where('numberVerified', isEqualTo: true)
          .get()
          .then((value) {
        // print(
        //     'value inside the firestore checking value: ${value.docs.length}');
        if (value.docs.isNotEmpty) {
          // print('isNotEmpty');
          result = true;
        } else {
          result = false;
        }
      });
    } catch (e) {
      debugPrint(e.toString());

      result = e.toString();
    }

    return result;
  }

  //UPDATING USER DATA
  static Future<dynamic> addOrUpdateUserData({
    required String uid,
    required String key,
    required dynamic value,
  }) async {
    try {
      final userCollection =
          _firestore.collection(FirebaseCollections.usersCollection);
      final userDocID = await userCollection
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) => snapshot.docs.first.id);

      //this will add if the new value is not found, and updates the already existing data.
      String result = await userCollection
          .doc(userDocID)
          .set({key: value}, SetOptions(merge: true)).then((value) {
        return 'updated';
      }).onError((error, stackTrace) {
        return error.toString();
      });

      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> updateAll({
    required String uid,
    required Map<String, dynamic> valueMap,
  }) async {
    try {
      final userCollection =
          _firestore.collection(FirebaseCollections.usersCollection);
      final userDocID = await userCollection
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) => snapshot.docs.first.id);

      //this will add if the new value is not found, and updates the already existing data.
      String result = await userCollection
          .doc(userDocID)
          .set(valueMap, SetOptions(merge: true))
          .then((value) {
        return 'updated';
      }).onError((error, stackTrace) {
        return error.toString();
      });

      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> updateUserData({
    required String uid,
    required String key,
    required dynamic value,
  }) async {
    try {
      final userCollection =
          _firestore.collection(FirebaseCollections.usersCollection);
      final userDocID = await userCollection
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) => snapshot.docs.first.id);

      // print(user.data());
      String result = await userCollection
          .doc(userDocID)
          .update({key: value}).then((value) {
        return 'updated';
      }).onError((error, stackTrace) {
        return error.toString();
      });

      return result;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> deleteUserData(
      {required String uid,
      required String key,
      required String keyName}) async {
    try {
      final userCollection =
          _firestore.collection(FirebaseCollections.usersCollection);
      final userDocID = await userCollection
          .where('uid', isEqualTo: uid)
          .get()
          .then((snapshot) => snapshot.docs.first.id);

      String result = await userCollection.doc(userDocID).set({
        key: {
          keyName: FieldValue.delete(),
        }
      }, SetOptions(merge: true)).then((value) {
        return 'deleted';
      }).onError((error, stackTrace) {
        return error.toString();
      });

      return result;
    } catch (e) {
      return e.toString();
    }
  }
}
