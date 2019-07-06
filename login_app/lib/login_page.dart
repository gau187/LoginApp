import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final TextEditingController emailController = new TextEditingController();
final TextEditingController passwordController = new TextEditingController();
var login = true;

var _key = new GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future _createUser(var key) async {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        FirebaseUser user = await _auth
            .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
            .then((userNew) {
          key.currentState.showSnackBar(new SnackBar(
            content: new Text("Signed Up"),
          ));
        });
      } on PlatformException catch(e){
        key.currentState.showSnackBar(new SnackBar(
          content: new Text(e.message),
        ));
      }
    }else{
      _key.currentState.showSnackBar(new SnackBar(
        content: new Text("Both field required"),
      ));
    }
  }

  Future _loginUser(var key) async {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        FirebaseUser user = await _auth
            .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
            .then((userNew) {
          key.currentState.showSnackBar(new SnackBar(
            content: new Text("Logged In"),
          ));
        });
      } on PlatformException catch(e){
        key.currentState.showSnackBar(new SnackBar(
          content: new Text(e.message),
        ));
      }
    }else{
      _key.currentState.showSnackBar(new SnackBar(
        content: new Text("Both field required"),
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
//        onPressed: () {Navigator.of(context).pushNamed(HomePage.tag);},
      onPressed: login ? () => _loginUser(_key) : () => _createUser(_key),
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text(login ? 'Log In' : 'Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    final signUpLabel = FlatButton(
      child: Text(
        login ? 'Sign Up?' : 'Login?',
        style: TextStyle(color: Colors.black54),
        textAlign: TextAlign.right,
      ),
      onPressed: () {
        setState(() {
          login = !login;
        });
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel,
            signUpLabel
          ],
        ),
      ),
    );
  }
}