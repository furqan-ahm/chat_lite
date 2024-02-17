import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({Key? key, this.onPressed, this.child}) : super(key: key);

  final Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(color: lineColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          minimumSize: MaterialStateProperty.all(
            const Size(double.infinity, 60),
          ),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return accentColor.withOpacity(0.2);
              }

              return Colors.transparent; //default color
            },
          ),
        ),
        child: Padding(
          // padding: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 44),
          child: child,
        ));
  }
}
