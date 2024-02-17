
import 'package:e2ee_chat/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ResetEmailSentDialog extends StatelessWidget {

  final String email;

  const ResetEmailSentDialog({Key? key,required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment
          .center, //so that the alert is shown at the center of the screen.
      mainAxisSize: MainAxisSize
          .min, //so that the card only takes the required space and not more than that
      children: [
        AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          // insetPadding: const EdgeInsets.all(8),
          titlePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          title: const Icon(
            Icons.mail,
            size: 82,
            color: primaryColor,
          ),
          content: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Password reset email sent',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              RichText(
                text: TextSpan(
                    text:
                        'An email to reset your password has been sent to ',
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: email,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      )
                    ]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
            ],
          ),
          actions: [
            CustomButton(
              buttonText: 'Okay!',
              fullWidth: true,
              onPressed: () async {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ],
    );
  }
}
