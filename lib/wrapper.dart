import 'package:chat_lite/models/user.dart';
import 'package:chat_lite/views/authentication/authenticate.dart';
import 'package:chat_lite/views/home/chatrooms_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<chatUser?>(context);

    if(user==null)return Authenticate();

    return const ChatRoom();
  }
}
