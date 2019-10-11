import 'package:flutter/material.dart';
import './pages/loginpage.dart';

void main() => runApp(MyApp());
var host='http://87046cfe.ngrok.io/';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}