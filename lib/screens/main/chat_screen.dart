import 'package:e2ee_chat/models/chat_room.dart';
import 'package:e2ee_chat/models/message.dart';
import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/services/encryption_service.dart';
import 'package:e2ee_chat/services/repositories/firestore_repo.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.chatRoom,
    required this.otherUser,
  }) : super(key: key);

  final ChatRoom chatRoom;
  final AppUser otherUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool loading = true;
  AppUser? _currentUser;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = MyAuthProvider.of(context).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.otherUser.name,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream:
                  FirestoreRepository.getMessages(widget.chatRoom.chatRoomId!),
              builder: (context, snapshot) {
                List<Message> messages = snapshot.hasData ? snapshot.data! : [];

                if (messages.isNotEmpty) {
                  FirestoreRepository.markMessagesRead(
                    widget.chatRoom.chatRoomId!,
                    widget.otherUser.uid,
                    messages.first,
                  );
                }

                return ListView.builder(
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    bool isSentByMe =
                        messages[index].sender!.uid == _currentUser!.uid;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(bottom: 8),
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(isSentByMe ? 20 : 0),
                            bottomRight: Radius.circular(isSentByMe ? 0 : 20),
                          ),
                          color: isSentByMe
                              ? Theme.of(context).primaryColor.withOpacity(0.75)
                              : Colors.blueGrey,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder<String>(
                                future: E2EncryptionService.instance.decrypt(
                                    messages[index].encryptedData!,
                                    widget.otherUser.publicKey),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data??"Decrypting..",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  );
                                }),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index].time!.hour.toString() +
                                      ':' +
                                      messages[index].time!.minute.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                isSentByMe
                                    ? Icon(
                                        messages[index].unread!
                                            ? Icons.check_circle_outline
                                            : Icons.check_circle,
                                        size: 18,
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: null,
                    controller: messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    FirestoreRepository.uploadMessage(
                      widget.chatRoom.chatRoomId!,
                      Message(
                        text: messageController.text,
                        unread: true,
                        sender: _currentUser,
                        reciever: widget.otherUser,
                        time: DateTime.now(),
                      ),
                    );
                    messageController.clear();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
