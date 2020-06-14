import 'package:ecommerceapp/screens/Authenticate/sign_up_page.dart';
import 'package:ecommerceapp/screens/home_page.dart';
import 'package:ecommerceapp/services/auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
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
              title: Text("Sign In"),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
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
                            "Sign in",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              var result = await _auth.signIn(_email, _password);
                              if (result == null)
                                setState(() {
                                  error = 'Could not sign in';
                                  _isLoading = false;
                                });
                              else {
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(user: result)));
                              }
                            }
                          }),
                      RaisedButton(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpPage()));
                          }),
                      SizedBox(height: 20),
                      Text(error),
                    ],
                  ),
                )),
          );
  }
}
