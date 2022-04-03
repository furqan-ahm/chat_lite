import 'package:flutter/material.dart';

import '../../constants.dart';
import 'conversationviews/conversation_screen.dart';

class RoomTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;

  RoomTile({required this.userName,required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.black26,
        shadowColor: Colors.blueGrey,
        margin: EdgeInsets.fromLTRB(10, 3, 10, 3),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Colors.white,child: Text(userName.substring(0,1),),),
          title:Text(userName,style: simpleTextStyle,),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
                builder:(context)=>ConversationView(chatRoomId: chatRoomId,name: userName,)
            ));
          },
        ),
      ),
    );
  }
}
