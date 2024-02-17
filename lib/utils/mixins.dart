import 'package:flutter/material.dart';



//simple mixin that allows access to size of the current context directly
//may add other stuff later
mixin ContextSize <T extends StatefulWidget> on State<T> {
  Size get size=>MediaQuery.of(context).size;
}


class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}