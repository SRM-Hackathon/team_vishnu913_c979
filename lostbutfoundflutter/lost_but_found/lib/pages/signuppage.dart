import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'mainPage.dart';

bool _showPassword = true;
bool loading = false;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _autoValidate = false;
String _name;
String _email;
String _password;
String _confirmedPassword;
String _phoneNumber;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
signup(){
  setState(){
    isLoading=true;
  }
  http.post(host + 'register/',body:{
    'username':_name,
    'email':_email,
    '_password':_password,
    'phone_number':_phoneNumber,
    'device_id':'eeee'
  }).then((response){
    print(response.statusCode);
    Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainPage()));
  });
}

  Widget _userNameField(){
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[ 
        Text( 
          'User Name',
          style: TextStyle( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans'
          ),
        ),
        SizedBox( 
          height: 10.0,
        ),
        Container( 
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration( 
            color: Colors.purple[200],
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
          child: TextFormField(
            validator: (String arg) {
              if(arg.length < 3){
                return 'User Name cannot be empty';
              }
              else{
                 return null;
              }
               
            }, 
            onSaved: (String val){
              _name = val;
            },
            style: TextStyle(
              color:Colors.white,

            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.people,color: Colors.white,),
              hintText: 'Enter the Username',
              hintStyle: TextStyle(
                color: Colors.white54,
              )
            ),
          )
        )
      ],
    );
  }

  Widget _emailField(){
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[ 
        Text( 
          'Email',
          style: TextStyle( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans'
          ),
        ),
        SizedBox( 
          height: 10.0,
        ),
        Container( 
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration( 
            color: Colors.purple[200],
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
          child: TextFormField( 
            validator: (String arg) {
              if(arg.length < 8){
                return 'email cannot be empty';
              }
              else{
                 return null;
              }
               
            },
            onSaved: (String val){
              _email = val;
            },
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

  Widget _passwordField(){
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[ 
        Text( 
          'Password',
          style: TextStyle( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans'
          ),
        ),
        SizedBox( 
          height: 10.0,
        ),
        Container( 
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration( 
            color: Colors.purple[200],
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
          child: TextFormField(
            validator: (String arg) {
              if(arg.length < 8){
                return 'Minimum length of the password must be 8';
              }
              else{
                 return null;
              }
               
            }, 
            onSaved: (String val){
              _password = val;
            },
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

  Widget _confirmPassword(){
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[ 
        Text( 
          'Confirm Password',
          style: TextStyle( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans'
          ),
        ),
        SizedBox( 
          height: 10.0,
        ),
        Container( 
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration( 
            color: Colors.purple[200],
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
          child: TextFormField(
            validator: (String arg) {
              if('a' != 'a'){
                return 'Confirm Password should be same as Password';
              }
              else{
                 return null;
              }
               
            }, 
            onSaved: (String val){
              _confirmedPassword = val;
            },
            obscureText: true, 
            style: TextStyle(
              color:Colors.white,

            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.email,color: Colors.white,),
              hintText: 'Confirm your Password',
              hintStyle: TextStyle(
                color: Colors.white54,
              )
            ),
          )
        )
      ],
    );
  }

  Widget _phoneNumberField(){
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[ 
        Text( 
          'Phone Number',
          style: TextStyle( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans'
          ),
        ),
        SizedBox( 
          height: 10.0,
        ),
        Container( 
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration( 
            color: Colors.purple[200],
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
          child: TextFormField(
            validator: (String arg) {
              if(arg.length < 10){
                return 'Check your phone number';
              }
              else{
                 return null;
              }
               
            }, 
            onSaved: (String val){
              _phoneNumber = val;
            },
            keyboardType: TextInputType.phone, 
            style: TextStyle(
              color:Colors.white,

            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(Icons.phone,color: Colors.white,),
              hintText: 'Enter your Phone Number',
              hintStyle: TextStyle(
                color: Colors.white54,
              )
            ),
          )
        )
      ],
    );
  }

  Widget _forgotPassword(){
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

  Widget _signUpButton(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton( 
        elevation: 5.0,
        onPressed: _validateInputs,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color:Colors.white,
        child: Text(
          'SIGN UP',
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

  Widget _signInText(){
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      },
      child: RichText(
        text: TextSpan( 
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              )
            ),
            TextSpan(
              text: 'Sign In',
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
      body: SafeArea(
        top: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children:<Widget>[
                Container( 
                  decoration: BoxDecoration( 
                    gradient: LinearGradient( 
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.purple[200],
                        Colors.purple[300],
                        Colors.purple[400],
                        Colors.purple[500]
                      ],
                      stops: [0.2,0.4,0.7,0.9]
                    )
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
                    child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Column( 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'
                            ),
                          ),
                          SizedBox(height: 30.0,),
                          _userNameField(),
                          SizedBox(height: 30.0,),
                          _emailField(),
                          SizedBox(height: 30.0,),
                          _passwordField(),
                          SizedBox(height: 30.0,),
                          _confirmPassword(),
                          SizedBox(height: 30.0,),
                          _phoneNumberField(),
                         isLoading ? _signUpButton() :Container(child:CircularProgressIndicator()),
                          _signInText(),
                        ],
                  ),
                    ),
                )
              )
              ]
            ),
          ),
        ),
      )
    );
  }
  void _validateInputs(){
    if (_formKey.currentState.validate()) {
    _formKey.currentState.save();
    signup();
  } else {
    setState(() {
      _autoValidate = true;
    });
  }
  }
}