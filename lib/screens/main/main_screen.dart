import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyAuthProvider.of(context).signOut(context);
        },
        child: const Icon(IconsaxBold.logout),
      ),
    );
  }
}
