import 'dart:async';

import 'package:e2ee_chat/constants/colors.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/screens/auth/fill_profile_screen.dart';
import 'package:e2ee_chat/utils/mixins.dart';
import 'package:e2ee_chat/widgets/common/max_sized_container.dart';
import 'package:e2ee_chat/widgets/custom_back_button.dart';
import 'package:e2ee_chat/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key, required this.userCredentials})
      : super(key: key);

  final UserCredential userCredentials;

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with ContextSize {
  Timer? refresher;

  @override
  void initState() {
    super.initState();
    widget.userCredentials.user!.sendEmailVerification();
    refresher = Timer.periodic(const Duration(seconds: 2), (timer) {
      Provider.of<MyAuthProvider>(context, listen: false)
          .refreshVerificationStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MyAuthProvider>(builder: (context, auth, _) {
          return SingleChildScrollView(
            child: MaxSizedContainer(
              safePadding: MediaQuery.of(context).padding,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    'assets/illustrations/otp.png',
                    height: size.height / 4,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    auth.emailVerified ? 'Email Verified!' : 'Verify Email',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'A verification link has been sent to the following email',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: bodyTextColor.withOpacity(0.4)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.userCredentials.user!.email!),
                  const Spacer(),
                  auth.emailVerified
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't recieve an email? ",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                      color: bodyTextColor.withOpacity(0.6),
                                      fontSize: 13),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Resend',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                ))
                          ],
                        ),
                  CustomButton(
                    buttonText:
                        auth.emailVerified ? 'Continue' : 'Not Verified',
                    backgroundColor: auth.emailVerified ? null : Colors.red,
                    onPressed: auth.emailVerified
                        ? () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FillProfileScreen(
                                      credentials: widget.userCredentials),
                                ));
                          }
                        : null,
                    fullWidth: true,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    'By continuing you’re indicating that you accept our Terms of Use and our Privacy Policy',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: bodyTextColor.withOpacity(0.8), fontSize: 13),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
