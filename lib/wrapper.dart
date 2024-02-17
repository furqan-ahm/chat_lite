
import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/views/authentication/authenticate.dart';
import 'package:e2ee_chat/views/home/chatrooms_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<chatUser?>(context);

    if(user==null)return const Authenticate();

    return const ChatRoom();
  }
}
