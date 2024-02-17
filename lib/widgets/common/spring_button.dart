import 'package:flutter/material.dart';

class SpringButton extends StatefulWidget {
const SpringButton({ Key? key, this.child, required this.onTap}) : super(key: key);


  final Widget? child;
  final Function onTap;

  @override
  State<SpringButton> createState() => _SpringButtonState();
}

class _SpringButtonState extends State<SpringButton> {
  
  bool isTapped=false;


  toggleSpring(bool val)=>setState(()=>isTapped=val);

  @override
  Widget build(BuildContext context){
    return AnimatedScale(
      scale: isTapped?0.9:1,
      duration: const Duration(milliseconds: 80),
      child: GestureDetector(
        onTapDown: (dt){
          toggleSpring(true);
        },
        onTapCancel: (){
          toggleSpring(false);
        },
        onTapUp: (det){
          toggleSpring(false);
          widget.onTap();
        },
        child: widget.child
      ),
    );
  }
}