import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key, this.isWhite=false}) : super(key: key);

  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'back',
      onPressed: () {
        Navigator.pop(context);
      },
      elevation: 0,
      backgroundColor: isWhite?Colors.white:primaryColor,
      child: Icon(
        IconsaxOutline.arrow_left,
        color: isWhite?primaryColor:Colors.white,
      ),
    );
  }
}
