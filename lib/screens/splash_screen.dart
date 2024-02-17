import 'package:e2ee_chat/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/user_state_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<List<bool>> _getSessionInfo(BuildContext context) async {
    final userStateProvider =
        Provider.of<UserStateProvider>(context, listen: false);

    await Provider.of<MyAuthProvider>(context, listen: false).refreshUser();

    final bool isAppOpenedForFirstTime =
        await userStateProvider.getOnboardSharedPreference();
    final bool isLogedIn = await userStateProvider.getLoginSharedPreference();

    return [isAppOpenedForFirstTime, isLogedIn];
  }

  void checkAuthenticationSession(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      },
    );

    //Wont work yet

    // _getSessionInfo(context).then((value) async {
    //   if (value[0] == true || value[1] == false) {
    //     await Future.delayed(
    //       const Duration(seconds: 1),
    //       () {
    //        Navigator.of(context).push(
    //           MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    //         );
    //       },
    //     );
    //   } else {
    //     await Future.delayed(
    //       const Duration(seconds: 1),
    //       () {
    //         Navigator.pushAndRemoveUntil(
    //             context,
    //             MaterialPageRoute(builder: (context) => const MainScreen()),
    //             (route) => false);
    //       },
    //     );
    //   }
    // }).onError((error, stackTrace) {

    //   print(error);
    // });
  }

  @override
  void initState() {
    super.initState();
    checkAuthenticationSession(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: 'logo',
              child: Image.asset('assets/get_started/welcome.png',
                  width: MediaQuery.of(context).size.width * 0.65),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
