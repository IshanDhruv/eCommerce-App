import 'package:ecommerceapp/models/user.dart';
import 'package:ecommerceapp/screens/Authenticate/sign_in_page.dart';
import 'package:ecommerceapp/screens/Authenticate/sign_up_page.dart';
import 'package:ecommerceapp/screens/wrapper.dart';
import 'package:ecommerceapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  //make Status bar transparent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyApp(), theme: ThemeData.dark()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<User>.value(value: AuthService().user, child: Wrapper());
  }
}
