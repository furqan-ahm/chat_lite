import 'package:e2ee_chat/constants/colors.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/screens/main/users_list_view.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Chat SAMPLE'
        ),
      ),
      body: const UsersListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyAuthProvider.of(context).signOut(context);
        },
        child: const Icon(IconsaxBold.logout),
      ),
    );
  }
}
