// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e2ee_chat/services/repositories/firestore_repo.dart';
// import 'package:e2ee_chat/views/home/chatrooms_screen.dart';
// import 'package:flutter/cupertino.dart';

// import '../models/message.dart';

import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/services/repositories/firestore_repo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InboxProvider extends ChangeNotifier {


   static InboxProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<InboxProvider>(context, listen: listen);


  Stream<List<AppUser>> getUsers(AppUser currentUser) {
    return FirestoreRepository.getUsers(currentUser.uid);
  }
}





// class InboxProvider extends ChangeNotifier {
//   Future sendMessage(
//       String docId, String message, {required bool isGeneral}) async {
//     var data = {
//       'message': message,
//       'sentByUser': false,
//       'time': Timestamp.now()
//     };

//     var result = await (isGeneral?FirestoreRepository.sendGeneralMessage(docId, data):FirestoreRepository.sendOrderMessage(docId, data));

    
//     return result;
//   }


//   setSeen(bool isGeneral, docId)=>isGeneral?FirestoreRepository.setGeneralMessageSeen(docId):FirestoreRepository.setOrderMessageSeen(docId);


//   Stream<List<Message>> messageStream(String orderId) =>
//       FirestoreRepository.getMessagesStream(orderId);
//   Stream<List<Message>> generalMessageStream(String userId) =>
//       FirestoreRepository.getGeneralMessageStream(userId);

//   Stream<List<ChatRoom>> orderChatStream() {
//     return FirestoreRepository.getOrderChatStream();
//   }

//   //tricky bit

//   // Stream<List<OrderChatRoom>> uninitiatedChatStream(String uid) {
//   //   _uninitiatedChatStream ??=
//   //       FirestoreRepository.getUninitiatedOrderChatStream(uid);

//   //   return _uninitiatedChatStream!;
//   // }
// }
