import 'dart:convert';
import 'dart:io';

import 'package:ecommerceapp/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  User user;
  SharedPreferences _prefs;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileForUser async {
    final path = await _localPath;
    return File('$path/user.txt');
  }

  Future writeUser(String data) async {
    final file = await _localFileForUser;
    return file.writeAsString('$data');
  }

  Future signUp(String email, String password, String name) async {
    var _body = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
    });

    const headers = {'Content-type': 'application/json'};
    try {
      final response = await http.post(
        "https://kicksup.herokuapp.com/users/signup",
        headers: headers,
        body: _body,
      );
      if (response.statusCode == 201) {
        var data = response.body;
        user = User.fromJson(jsonDecode(data));
        _prefs = await SharedPreferences.getInstance();
        _prefs.setBool('user', true);
        _prefs.setString('password', password);
        writeUser(data);
        return user;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signIn(String email, String password) async {
    var _body = jsonEncode({
      "email": email,
      "password": password,
    });

    const headers = {'Content-type': 'application/json'};
    try {
      final response = await http.post(
        "https://kicksup.herokuapp.com/users/login",
        headers: headers,
        body: _body,
      );
      if (response.statusCode == 200) {
        var data = response.body;
        user = User.fromJson(jsonDecode(data));
        _prefs = await SharedPreferences.getInstance();
        _prefs.setBool('user', true);
        _prefs.setString('password', password);
        writeUser(data);
        return user;
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signOut(String authToken) async {
    var headers = {'Content-type': 'application/json', 'Authorization' : authToken};
    try {
      final response = await http.post(
        "https://kicksup.herokuapp.com/users/logout",
        headers: headers,
      );
      if (response.statusCode == 200) {
        _prefs = await SharedPreferences.getInstance();
        _prefs.setBool('user', false);
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
