import 'package:flutter/material.dart';

class MaxSizedContainer extends StatelessWidget {
const MaxSizedContainer({ Key? key, required this.child, this.margin, this.padding, this.safePadding, this.hasAppBar=false}) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final bool hasAppBar;
  final EdgeInsetsGeometry? margin;
  final EdgeInsets? safePadding;// this is the extra padding(i.e from SafeArea) to be subtracted from height, 
  final Widget child;

  @override
  Widget build(BuildContext context){

    double height = MediaQuery.of(context).size.height-(safePadding==null?0:safePadding!.bottom+safePadding!.top);

    return Container(
      margin: margin,
      padding: padding,
      height: hasAppBar?height-56:height,
      child: child,
    );
  }
}