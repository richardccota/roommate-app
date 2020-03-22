import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:roommate_app/create_account_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
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

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Roommate App Login'),
          backgroundColor: Colors.lightGreen,
        ),
        body: Container(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100
                  ),
                  Text("Please login to your Account"),
                  SizedBox(height: 60),
                  TextFormField(
                    onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      labelText: ("Email"),
                      icon: Icon(Icons.account_box, color: Colors.grey),
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Can\'t be empty' : null,
                  ),
                  TextFormField(
                    onSaved: (value) => _password = value,
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
                    child: Text("Login"),
                    onPressed: () async {
                      print("PRESSED");
                      final form = _formKey.currentState;
                      form.save();

                      // Validate will return true if is valid, or false if invalid.
                      if (form.validate()) {
                        try {
                          AuthResult result =
                              await Provider.of<AuthService>(context).loginUser(
                                  email: _email, password: _password);
                          print(result);
                        } on AuthException catch (error) {
                          // handle the firebase specific error
                          return _buildErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          // gracefully handle anything else that might happen..
                          return _buildErrorDialog(context, error.toString());
                        }
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    color: Colors.grey,
                    child: Text("Create Account"),
                      onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccountPage())
                      );
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
