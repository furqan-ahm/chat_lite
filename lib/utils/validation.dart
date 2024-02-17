import 'package:flutter/services.dart';

class ValidationUtils {
  static String? validateName(String? value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(pattern);
    if (value?.isEmpty ?? true) {
      return "Name is required";
    } else if (!regExp.hasMatch(value ?? '')) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  static String? validateMobile(String? value) {
    String pattern = r'(^\+?[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value?.isEmpty ?? true) {
      return "Mobile phone number is required";
    } else if(value!.length!=10){
      return 'Mobile phone number is required';
    } else if (!regExp.hasMatch(value)) {
      return "Mobile phone number must contain only digits";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if ((value?.length ?? 0) < 6) {
      return 'Password must be more than 5 characters';
    } else {
      return null;
    }
  }

  static String? validateTextFormFieldForEmptyInput(String? value) {
    if ((value?.length ?? 0) < 1) {
      return 'Empty input not allowed';
    } else {
      return null;
    }
  }

  static String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value ?? '')) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return 'Password doesn\'t match';
    } else if (confirmPassword?.isEmpty ?? true) {
      return 'Confirm password is required';
    } else {
      return null;
    }
  }

  static List<TextInputFormatter> numberTextInputFormater = [
    FilteringTextInputFormatter.digitsOnly
  ];
}