
import 'package:e2ee_chat/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({Key? key, this.onPressed, this.fullWidth=false, this.buttonText, this.backgroundColor, this.foregroundColor}) : super(key: key);

  final Future Function()? onPressed;
  final String? buttonText;
  final Color? backgroundColor;
  final bool fullWidth;
  final Color? foregroundColor;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {


  bool loading=false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed==null||loading?null:()async{
          setState(() {
            loading=true;
          });
          await widget.onPressed!();
          setState(() {
            loading=false;
          });
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(2),
          backgroundColor: MaterialStateProperty.all(widget.backgroundColor??primaryColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          minimumSize: widget.fullWidth
              ? MaterialStateProperty.all(
                  const Size(double.infinity, 60),
                )
              : MaterialStateProperty.all(const Size(0, 50)),
          //now the button color will be same even if it is not focused.
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return accentColor.withOpacity(0.2);
              }

              return primaryColor; //default color
            },
          ),
        ),
        child: Padding(
          // padding: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: loading?const CircularProgressIndicator(color: Colors.white, strokeWidth: 2,):Text(
            widget.buttonText ?? 'Press',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: widget.foregroundColor??Colors.white,
                ),
          ),
        ));
  }
}
