import 'package:ecommerceapp/services/auth.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  String _name = '';
  String _email = '';
  String _password = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Sign Up"),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(labelText: "Name", border: OutlineInputBorder()),
                        validator: (val) => val.isEmpty ? 'Enter your name' : null,
                        onChanged: (val) {
                          setState(() {
                            _name = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            _email = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                        validator: (val) => val.length < 6 ? 'Password should be longer than 6 characters' : null,
                        onChanged: (val) {
                          _password = val;
                        },
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              var result = await _auth.signUp(_email, _password, _name);
                              if (result == null)
                                setState(() {
                                  error = 'Could not sign up';
                                  _isLoading = false;
                                });
                              else{
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(user: result)));
                              }
                            }
                          }),
                      SizedBox(height: 20),
                      Text(error),
                    ],
                  ),
                )),
          );
  }
}
