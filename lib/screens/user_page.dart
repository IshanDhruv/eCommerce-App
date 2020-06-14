import 'package:ecommerceapp/models/user.dart';
import 'package:ecommerceapp/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Authenticate/sign_in_page.dart';

class UserPage extends StatelessWidget {
  User user;

  UserPage({this.user});

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    print(user.id);
    print(user.name);
    print(user.email);
    print(user.items);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your profile"),

      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(user.name, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              MaterialButton(
                color: Colors.red,
                child: Text("LOGOUT"),
                onPressed: () {
                  _auth.signOut(user.authToken).then((value) {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
