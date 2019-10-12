import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showPassword = true;

  Widget _emailField() {
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[ 
        Text( 
          'Email',
          style: TextStyle( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox( 
          height: 10.0,
        ),
        Container( 
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration( 
            color: Color(0xFF6CA8F1),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0,2)
              ),
            ]
          ),
          height: 60.0,
          child: TextField( 
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color:Colors.white,

            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.email,color: Colors.white,),
              hintText: 'Enter your Email',
              hintStyle: TextStyle(
                color: Colors.white54,
              )
            ),
          )
        )
      ],
    );
  }

  Widget _passwordField() {
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[ 
        Text( 
          'Password',
          style: TextStyle( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox( 
          height: 10.0,
        ),
        Container( 
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration( 
            color: Color(0xFF6CA8F1),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0,2)
              ),
            ]
          ),
          height: 60.0,
          child: TextField(
            obscureText: _showPassword, 
            style: TextStyle(
              color:Colors.white,

            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.email,color: Colors.white,),
              suffixIcon: 
                IconButton(
                  icon:_showPassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                  color:Colors.white,
                  onPressed: () => setState(() {
                    _showPassword = !_showPassword;
                  })
                ),
              hintText: 'Enter your Password',
              hintStyle: TextStyle(
                color: Colors.white54,
              )
            ),
          )
        )
      ],
    );
  }

  Widget _forgotPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton( 
        onPressed: (){},
        padding: EdgeInsets.only(right:0.0),
        child: Text(
          'Forgot Password?',
          style:TextStyle(
            color:Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      )
    );
  }

  Widget _loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton( 
        elevation: 5.0,
        onPressed: (){},
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color:Colors.white,
        child: Text(
          'LOGIN',
          style:TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    );
  }

  Widget _sigUpText() {
    return GestureDetector(
      onTap: (){},
      child: RichText(
        text: TextSpan( 
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              )
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle( 
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )
            ) 
          ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector( 
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack( 
            children: <Widget>[ 
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5)
                    ],
                    stops: [
                      0.1,0.4,0.7,0.9
                    ]
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView( 
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0
                  ),
                  child: Column( 
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      _emailField(),
                      SizedBox(height: 30.0,),
                      _passwordField(),
                      SizedBox(height: 30.0,),
                      _forgotPassword(),
                      _loginButton(),
                      _sigUpText(),
                    ],
                  ),
                )
              )
            ],
          )
        )
      )
    );
  }
}