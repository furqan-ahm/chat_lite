import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(
              thickness: 1.5,
          color: lineColor,
          height: 75,
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: const Color(0xff878787)),
          ),
        ),
        const Expanded(
            child: Divider(
              thickness: 1.5,
          color: lineColor,
          height: 75,
        )),
      ],
    );
  }
}
