import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e2ee_chat/services/database_service.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chat_tile.dart';

class ConversationView extends StatefulWidget {
  final String chatRoomId;
  final String name;

  const ConversationView(
      {super.key, required this.chatRoomId, required this.name});

  @override
  ConversationViewState createState() => ConversationViewState();
}

class ConversationViewState extends State<ConversationView> {
  Size? size;
  String message = '';

  Stream? messageStream;

  final DatabaseService _db = DatabaseService();
  TextEditingController txtController = TextEditingController();

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return ListView.builder(
          reverse: true,
          itemCount: snapshot.hasData
              ? (snapshot.data as QuerySnapshot).docs.length
              : 0,
          itemBuilder: (context, index) {
            return snapshot.hasData
                ? ChatTile(
                    message: (snapshot.data as QuerySnapshot)
                        .docs[index]
                        .get('message'),
                    isSendbyMe: (snapshot.data as QuerySnapshot)
                            .docs[index]
                            .get('sentBy') ==
                        Constants.myName,
                  )
                : Container();
          },
        );
      },
    );
  }

  sendMessage(String message) {
    if (message.isEmpty) return;
    txtController.text = '';
    Map<String, dynamic> messageData = {
      "message": message,
      "sentBy": Constants.myName!,
      "time": DateTime.now().microsecondsSinceEpoch
    };

    _db.sendMessage(widget.chatRoomId, messageData);
  }

  @override
  initState() {
    messageStream = _db.getConversation(widget.chatRoomId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: Text(
          widget.name,
          style: simpleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size!.height * 0.85,
          child: Column(
            children: [
              Flexible(
                flex: 8,
                child: messageStream != null ? ChatMessageList() : Container(),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      color: Colors.white12,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 9,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 6, 0),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: TextField(
                                controller: txtController,
                                textAlignVertical: TextAlignVertical.bottom,
                                style: simpleTextStyle,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 10, 5.0, 10),
                                  filled: true,
                                  fillColor: Colors.white12,
                                  hintText: 'Message..',
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.black12, width: 2)),
                                ),
                                onChanged: (val) => message = val,
                                onSubmitted: (val) => sendMessage(val),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: size!.width * 0.3,
                              width: size!.width * 0.3,
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextButton(
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<CircleBorder>(
                                          CircleBorder()),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white12),
                                ),
                                child: Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () => sendMessage(message),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
