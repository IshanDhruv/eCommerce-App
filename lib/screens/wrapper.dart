import 'dart:convert';
import 'dart:io';

import 'package:ecommerceapp/models/user.dart';
import 'package:ecommerceapp/screens/Authenticate/sign_in_page.dart';
import 'package:ecommerceapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  SharedPreferences _prefs;
  bool _isThereUser = false;
  bool _isLoading;
  String _password;
  User user;
  AuthService _auth = AuthService();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileForUser async {
    final path = await _localPath;
    return File('$path/user.txt');
  }

  Future readUser() async {
    final file = await _localFileForUser;
    String contents = await file.readAsString().then((value) {
      user = User.fromJson(jsonDecode(value));
      print(user.authToken);
      return value;
    });
    return contents;
  }

  Future getUser() async {
    _prefs = await SharedPreferences.getInstance();
      _isThereUser = _prefs.getBool('user');
    if (_isThereUser == true) {
      await readUser().then((value) async {
        _password = _prefs.getString('password');
        user = await _auth.signIn(user.email, _password).then((value) => user = value);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    getUser().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading)
      return Center(child: CircularProgressIndicator());
    else if (_isThereUser == true)
      return HomePage(user: user);
    else
      return SignInPage();
  }
}
