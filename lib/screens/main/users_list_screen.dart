import 'package:e2ee_chat/models/user.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/providers/inbox_provider.dart';
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
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(users[index].getProfilePictureURL),
              ),
              title: Text(
                users[index].name,
              ),
            );
          },
        );
      },
    );
  }
}
