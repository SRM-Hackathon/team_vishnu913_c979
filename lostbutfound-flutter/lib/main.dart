import 'package:flutter/material.dart';
import './pages/loginpage.dart';
import './pages/mainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());
var host='http://2654d851.ngrok.io/';
var change = '';
var port='80';
var path='2654d851.ngrok.io';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState(){
    print("main dart initstate");
    super.initState();
    SharedPreferences.getInstance().then((prefs){
      setState(() {
        print(change);
        if(prefs.getString('token') == null){
          change = '';
        }
        else{
          change = prefs.getString('token');
        }
        
        print(change);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return change == '' ? LoginPage() : MainPage();
  }
}