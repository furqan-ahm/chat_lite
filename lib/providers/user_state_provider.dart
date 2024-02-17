import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStateProvider extends ChangeNotifier {
  static String isLoggedInSharedPreference = 'ISLOGGEDIN';
  static String onBoardSharedPreference = 'FIRSTTIME';

  UserStateProvider() {
    saveOnboardSharedPreference(false);
  }

  Future<void> saveLoginSharedPreference(bool islogin) async {
    print('ehe');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // isLoggedIn = islogin;
    prefs.setBool(isLoggedInSharedPreference, islogin);
    notifyListeners();
  }

  Future<bool> getLoginSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool(isLoggedInSharedPreference);

    return result ?? false;
  }

  Future<void> saveOnboardSharedPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(onBoardSharedPreference, value);
    notifyListeners();
  }

  Future<bool> getOnboardSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool(onBoardSharedPreference);
    return result ?? true;
  }

  Future<void> deleteLoginSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(isLoggedInSharedPreference);
    notifyListeners();
  }
}