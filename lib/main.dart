import 'package:e2ee_chat/firebase_options.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/providers/user_state_provider.dart';
import 'package:e2ee_chat/screens/splash_screen.dart';
import 'package:e2ee_chat/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(
          create: (context) => MyAuthProvider(),
        ),
        ChangeNotifierProvider<UserStateProvider>(
          create: (context) => UserStateProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatX',
        theme: theme,
        home: const SplashScreen(),
      ),
    );
  }
}
