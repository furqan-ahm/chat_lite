import 'package:e2ee_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final FirebaseFirestore _db=FirebaseFirestore.instance;

  Future<QuerySnapshot>getUserByUsername(String uname)async{
    return await _db.collection('users').where("name", isEqualTo: "$uname").get();
  }

  Future<QuerySnapshot>getUserByEmail(String email)async{
    return await _db.collection('users').where("email", isEqualTo: "$email").get();
  }

  uploadUserInfo(userData){
    _db.collection("users")
        .add(userData);
  }

  createChatRoom(String chatRoomId, chatRoomData){
    _db.collection('ChatRooms')
        .doc(chatRoomId).set(chatRoomData).catchError(
            (e){
              print(e.toString());
            });
  }

  getConversation(String chatRoomId){
    return FirebaseFirestore.instance.collection('ChatRooms')
        .doc(chatRoomId)
        .collection("chats").orderBy('time', descending: true)
        .snapshots();
  }

  sendMessage(String chatRoomId, messageData)async{
    await FirebaseFirestore.instance.collection('ChatRooms').doc(chatRoomId)
        .collection("chats")
        .add(messageData);
  }

  getChatRooms(){
    return FirebaseFirestore.instance.collection('ChatRooms').where("emails",arrayContains: Constants.myEmail!).snapshots();
  }

}