
import 'package:e2ee_chat/constants/colors.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/screens/auth/login_screen.dart';
import 'package:e2ee_chat/screens/auth/signup_screen.dart';
import 'package:e2ee_chat/utils/mixins.dart';
import 'package:e2ee_chat/widgets/custom_button.dart';
import 'package:e2ee_chat/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_outlined_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with ContextSize{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/get_started/welcome.png',
                height: size.height / 4.5,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Let's you in",
              style: GoogleFonts.urbanist(
                  color: bodyTextColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 40,
            ),
            // CustomOutlinedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: Row(
            //     children: [
            //       Image.asset(
            //         'assets/Facebook.png',
            //         height: 20,
            //       ),
            //       const SizedBox(
            //         width: 20,
            //       ),
            //       Text(
            //         'Continue with Facebook',
            //         style: Theme.of(context)
            //             .textTheme
            //             .bodySmall
            //             ?.copyWith(fontSize: 13),
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
           
            CustomButton(
              onPressed: () async{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              },
              fullWidth: true,
              buttonText: 'Sign In With Password',
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => const SignupScreen(),));
                    },
                    child: Text(
                      'Signup',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: primaryColor, fontWeight: FontWeight.w700),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
