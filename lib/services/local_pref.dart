
import 'package:shared_preferences/shared_preferences.dart';

class LocalPref{


  static String sharedPref_usernameKey="unameKey";
  static String sharedPref_emailKey="emailKey";


  ///setters
  static Future<bool> setUsernamePref(String username)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPref_usernameKey, username);
  }

  static Future<bool> setEmailPref(String email)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPref_emailKey, email);
  }

  ///getters
  static Future<String?> getUsernamePref()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(sharedPref_usernameKey);
  }

  static Future<String?> getEmailPref()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(sharedPref_emailKey);
  }

}