import 'package:e2ee_chat/constants/colors.dart';
import 'package:e2ee_chat/providers/auth_provider.dart';
import 'package:e2ee_chat/screens/auth/fill_profile_screen.dart';
import 'package:e2ee_chat/screens/auth/verify_email_screen.dart';
import 'package:e2ee_chat/utils/mixins.dart';
import 'package:e2ee_chat/utils/validation.dart';
import 'package:e2ee_chat/widgets/common/max_sized_container.dart';
import 'package:e2ee_chat/widgets/custom_back_button.dart';
import 'package:e2ee_chat/widgets/custom_divider.dart';
import 'package:e2ee_chat/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../providers/user_state_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_outlined_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with ContextSize {
  bool rememberMe = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: MaxSizedContainer(
            safePadding: MediaQuery.of(context).padding,
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomBackButton()),
                  const Spacer(),
                  Text(
                    "Create Your Account",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.urbanist(
                        color: bodyTextColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomFormField(
                      labelText: 'Email',
                      controller: emailController,
                      isPassword: false,
                      validatorFunction: ValidationUtils.validateEmail,
                      primaryColor: primaryColor,
                      textColor: bodyTextColor,
                      textFieldBgColor: Colors.transparent,
                      isLabelCenter: false),
                  const SizedBox(height: 15),
                  CustomFormField(
                      labelText: 'Password',
                      isPassword: true,
                      controller: passController,
                      validatorFunction: ValidationUtils.validatePassword,
                      primaryColor: primaryColor,
                      textColor: bodyTextColor,
                      textFieldBgColor: Colors.transparent,
                      isLabelCenter: false),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: rememberMe,
                        side: BorderSide(
                            color: bodyTextColor.withOpacity(0.5), width: 2),
                        activeColor: primaryColor,
                        onChanged: (value) =>
                            setState(() => rememberMe = value ?? false),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      Text(
                        'Remember Me',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: bodyTextColor.withOpacity(0.6)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<MyAuthProvider>(context, listen: false)
                            .signUpWithEmailAndPassword(context,
                                emailController.text, passController.text,
                                rememberMe: rememberMe)
                            .then((value) {
                          if (value != null) {
                            final userStateProvider =
                                Provider.of<UserStateProvider>(context,
                                    listen: false);
                            userStateProvider.saveLoginSharedPreference(true);

                            Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: FillProfileScreen(
                                    credentials: value,
                                  ),
                                ));
                            // Navigator.push(
                            //     context,
                            //     PageTransition(type: PageTransitionType.rightToLeft, child: VerifyEmailScreen(userCredentials: value,),));
                          }
                        });
                      }
                    },
                    fullWidth: true,
                    buttonText: 'Sign Up',
                  ),
                  // const CustomDivider(text: 'or'),
                  // CustomOutlinedButton(
                  //   onPressed: () {
                  //     Provider.of<MyAuthProvider>(context, listen: false)
                  //         .signInWithGoogle(context);
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Image.asset(
                  //         'assets/Google.png',
                  //         height: 20,
                  //       ),
                  //       const SizedBox(
                  //         width: 20,
                  //       ),
                  //       Text(
                  //         'Continue with Google',
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodySmall
                  //             ?.copyWith(fontSize: 13),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     OutlinedButton(
                  //         onPressed: () {},
                  //         style: ButtonStyle(
                  //             shape: MaterialStatePropertyAll(
                  //                 RoundedRectangleBorder(
                  //                     borderRadius:
                  //                         BorderRadius.circular(12)))),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               vertical: 12.0, horizontal: 8),
                  //           child: Image.asset(
                  //             'assets/Google.png',
                  //             height: 30,
                  //           ),
                  //         )),
                  //     const SizedBox(
                  //       width: 30,
                  //     ),
                  //     OutlinedButton(
                  //         onPressed: () {},
                  //         style: ButtonStyle(
                  //             shape: MaterialStatePropertyAll(
                  //                 RoundedRectangleBorder(
                  //                     borderRadius:
                  //                         BorderRadius.circular(12)))),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               vertical: 12.0, horizontal: 8),
                  //           child: Image.asset(
                  //             'assets/Facebook.png',
                  //             height: 30,
                  //           ),
                  //         )),
                  //   ],
                  // ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
