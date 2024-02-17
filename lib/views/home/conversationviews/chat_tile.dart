import 'package:flutter/material.dart';

import '../../../constants.dart';

class ChatTile extends StatelessWidget {
  final String message;
  final bool isSendbyMe;

  const ChatTile({super.key, required this.message, required this.isSendbyMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 8),
      alignment: isSendbyMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(isSendbyMe ? 20 : 0),
              bottomRight: Radius.circular(isSendbyMe ? 0 : 20),
            ),
            color: isSendbyMe ? Colors.blueGrey : Colors.white10,
          ),
          child: Text(
            message,
            style: simpleTextStyle,
          )),
    );
  }
}
