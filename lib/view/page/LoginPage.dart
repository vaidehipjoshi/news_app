import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news/data/api/models/Status.dart';
import 'package:news/data/auth/AuthRemoteService.dart';
import 'package:news/view/Routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  final AuthRemoteService authRemoteService = AuthRemoteService.create();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Icon(
          Icons.crop,
          color: Colors.white,
          size: 120,
        ),
      ),
    );
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.white,
      ),
      autofocus: false,
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: Colors.white,
            )),
      ),
    );
    final password = TextFormField(
      autofocus: false,
      style: TextStyle(
        color: Colors.white,
      ),
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (emailController.text.isEmpty) {
            _showMessageDialog('Error', 'You must fill email');
            return;
          }
          if (passwordController.text.isEmpty) {
            _showMessageDialog('Error', 'You must enter a password');
            return;
          }
          _showLoadingDialog('Please wait', 'Loading...');
          _login(context);
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).accentColor,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(
        child: Form(
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
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    authRemoteService
        .login(emailController.text, passwordController.text)
        .then((value) {
      if (value.status == Status.ERROR) {
        Navigator.of(context).pop();
        _showMessageDialog('Error', value.message);
        return;
      }
      _gotoNextScreen(context);
    }).catchError((e, s) {
      print(e);
      Navigator.of(context).pop();
      _showMessageDialog('Error', 'Something went wrong');
    });
  }

  Future<void> _showMessageDialog(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLoadingDialog(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 4.0, bottom: 4.0, left: 2.0, right: 16.0),
                  child: CircularProgressIndicator(),
                ),
                Text(msg),
              ],
            ),
          ),
        );
      },
    );
  }

  void _gotoNextScreen(BuildContext _context) {
    Navigator.of(context).pushReplacementNamed(ROUTE_PATH[Routes.HOME]);
  }
}
