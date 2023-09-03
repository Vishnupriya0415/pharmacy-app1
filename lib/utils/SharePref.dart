// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPref;
  init() async {
    _sharedPref ??= await SharedPreferences.getInstance();
    //print(_sharedPref!.getString("userId"));
  }

  //get

  String? get id => _sharedPref!.getString("id") ?? "";

  //setters
  setId(String id) {
    _sharedPref!.setString("id", id);
  }
}

final sharedPrefs = SharedPref();
