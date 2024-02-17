
import 'package:e2ee_chat/utils/mixins.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


@immutable
class CustomFormField extends StatefulWidget {
  // const CustomFormField({Key? key}) : super(key: key);
  final String? labelText;
  bool isPassword;
  final String? Function(String?) validatorFunction;
  final TextEditingController? controller;
  final Color primaryColor;
  final Color textColor;
  final Color textFieldBgColor;
  final bool isLabelCenter;
  Widget? suffixWidget;
  Widget? prefixWidget;
  int? maxLength;
  bool? enabled;
  List<TextInputFormatter>? textInputFormatters;
  CustomFormField({
    this.textInputFormatters,
    this.maxLength,
    super.key,
    this.labelText,
    this.enabled,
    this.isPassword=false,
    this.controller,
    this.suffixWidget,
    this.prefixWidget,
    required this.validatorFunction,
    required this.primaryColor,
    required this.textColor,
    required this.textFieldBgColor,
    this.isLabelCenter=false,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enableInteractiveSelection: (widget.enabled??true),
      focusNode: (widget.enabled??true)?null:AlwaysDisabledFocusNode(),
      obscureText: widget.isPassword,
      validator: widget.validatorFunction,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: widget.textColor,
          ),
      cursorColor: widget.primaryColor.withOpacity(0.5),
      maxLength: widget.maxLength,
      inputFormatters: widget.textInputFormatters,
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: widget.prefixWidget,
        filled: true,

        fillColor: widget.textFieldBgColor,

        suffixIcon: widget.labelText?.contains('Password')??false
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isPassword = !widget.isPassword;
                  });
                },
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Icon(
                    !widget.isPassword
                        ? IconsaxOutline.eye
                        : IconsaxOutline.eye_slash,
                    color: widget.textColor,
                    size: 20,
                  ),
                ),
              )
            : widget.suffixWidget,
        contentPadding: const EdgeInsets.only(left: 12, right: 12),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: widget.textColor.withOpacity(0.5),
            ),

        floatingLabelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: widget.textColor.withOpacity(0.5),
            ),
        label: widget.labelText!=null?widget.isLabelCenter
            ? Center(
                child: Text(
                  widget.labelText!,
                ),
              )
            : Text(
                widget.labelText!,
              ):null,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.primaryColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.textColor.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.textColor.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.textColor.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }
}