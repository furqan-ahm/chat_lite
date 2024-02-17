import 'package:e2ee_chat/services/auth_service.dart';
import 'package:e2ee_chat/services/database_service.dart';
import 'package:e2ee_chat/services/local_pref.dart';
import 'package:e2ee_chat/views/home/room_tile.dart';
import 'package:e2ee_chat/views/home/searchviews/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e2ee_chat/constants.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {

  final AuthService _auth= AuthService();

  final DatabaseService _db=DatabaseService();

  Size? size;
  Stream? roomsStream;

  @override
  void initState() {
    getUserInfo().then((value){
      setState(() {
        roomsStream=_db.getChatRooms();
      });
    });

    super.initState();
  }

  Future<bool>getUserInfo()async{
    Constants.myName = await LocalPref.getUsernamePref();
    Constants.myEmail = await LocalPref.getEmailPref();
    return true;
  }


  Widget chatRoomList(){
    return StreamBuilder(
      stream: roomsStream,
      builder: (context,snapshot){
        print(Constants.myName!);
        return ListView.builder(
          itemCount: snapshot.hasData?(snapshot.data as QuerySnapshot).docs.length:0,
          itemBuilder: (context,index){
            List<dynamic> names=(snapshot.data as QuerySnapshot).docs[index].get('users');
            return snapshot.hasData?RoomTile(
              chatRoomId: (snapshot.data as QuerySnapshot).docs[index].get('chatRoomId'),
              userName: (names[0]+names[1]).toString().replaceAll(Constants.myName!, ""),)
                :Container();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Chat Me'),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app_rounded,color: Colors.white,),
            ),
            onTap: (){_auth.signOut();},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "search",
        child: Icon(Icons.search),
        backgroundColor: Colors.blueGrey,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>SearchView()
          ));
        },
      ),
      body: chatRoomList(),
      );

  }
}
