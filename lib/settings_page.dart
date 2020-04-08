import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:roommate_app/create_account_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

Future _buildErrorDialog(BuildContext context, _message) {
  return showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text('Error Message'),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    },
    context: context,
  );
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _password;
  String _email;

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Roommate App Settings'),
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                      height: 100
                  ),
                  Text("Please Settings to your Account"),
                  SizedBox(height: 60),
                  TextFormField(
                    onSaved: (value) => _email = value,
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _emailFocus, _passwordFocus);
                    },
                    decoration: InputDecoration(
                      labelText: ("Email"),
                      icon: Icon(Icons.account_box, color: Colors.grey),
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'Can\'t be empty' : null,
                  ),
                  TextFormField(
                    onSaved: (value) => _password = value,
                    focusNode: _passwordFocus,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: ("Password"),
                      icon: Icon(Icons.lock, color: Colors.grey),
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'Cannot be empty' : null,
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                    elevation: 5,
                    color: Colors.lightGreen,
                    child: Text("Settings"),
                    onPressed: ()  {
                    },
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    color: Colors.grey,
                    child: Text("Create Account"),
                    onPressed: () {
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
