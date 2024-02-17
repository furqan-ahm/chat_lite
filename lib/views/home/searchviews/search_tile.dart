
import 'package:e2ee_chat/services/database_service.dart';
import 'package:e2ee_chat/views/home/conversationviews/conversation_view.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';


class SearchTile extends StatelessWidget {


  final DatabaseService _db=DatabaseService();

  final String userName;
  final String email;
  final BuildContext context;

  SearchTile({super.key, required this.email, required this.userName, required this.context});
  
  
  
  ///create chatRoom and push as replacement
  initiateChatRoom(){

    String chatRoomId=getChatRoomId(email, Constants.myEmail!);

    List<String> emails=[email,Constants.myEmail!];
    List<String> users=[userName,Constants.myName!];

    Map<String, dynamic> chatRoomData={
      "users":users,
      "emails":emails,
      "chatRoomId":chatRoomId,
    };

    _db.createChatRoom(chatRoomId, chatRoomData);
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder:(context)=>ConversationView(chatRoomId: chatRoomId,name: userName,)
    ));
  }

  String getChatRoomId(String email_1,String email_2){
    if(email_1.compareTo(email_2)>0)
      return "$email_1\_$email_2";
    else
      return '$email_2\_$email_1';

  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: Colors.black26,
        shadowColor: Colors.blueGrey,
        margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Colors.white,child: Text(userName.substring(0,1),),),
          title:Text(userName,style: simpleTextStyle,),
          subtitle: Text(email,style: TextStyle(
              fontSize: 12,
              color: Colors.grey
          ),),
          trailing: FloatingActionButton(
            heroTag: "message$userName",
            backgroundColor: Colors.black45,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            child: Icon(Icons.message),
            onPressed: ()=>initiateChatRoom(),
          ),
        ),
      ),
    );
  }
}
