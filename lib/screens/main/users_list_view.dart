import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/providers/inbox_provider.dart';
import 'package:e2ee_chat/screens/main/chat_screen.dart';
import 'package:e2ee_chat/services/repositories/firestore_repo.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser currentUser = MyAuthProvider.of(context).currentUser;

    return StreamBuilder(
      stream: InboxProvider.of(context).getUsers(currentUser),
      builder: (context, snapshot) {
        var users = snapshot.data ?? [];

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                FirestoreRepository.createChatRoom(currentUser, users[index])
                    .then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatRoom: value,
                          otherUser: users[index],
                        ),
                      ));
                });
              },
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(users[index].getProfilePictureURL),
              ),
              title: Text(
                users[index].name,
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
        );
      },
    );
  }
}
