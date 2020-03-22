import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:firebase_database/firebase_database.dart';


class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
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

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _fName;
  String _lName;
  String _password;
  String _email;

  var fNameEditController = TextEditingController();
  var lNameEditController = TextEditingController();

  final ref = FirebaseDatabase.instance.reference();



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Roommate App Create Account'),
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
                  Text("Please enter your information"),
                  SizedBox(height: 60),
                  TextFormField(
                    controller: fNameEditController,
                    onSaved: (value) => _fName = value.trim(),
                    decoration: InputDecoration(
                      labelText: ("First Name"),
                      icon: Icon(Icons.account_box, color: Colors.grey),
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'Can\'t be empty' : null,
                  ),
                  TextFormField(
                    controller: lNameEditController,
                    onSaved: (value) => _lName = value.trim(),
                    decoration: InputDecoration(
                      labelText: ("Last Name"),
                      icon: Icon(Icons.account_box, color: Colors.grey),
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'Can\'t be empty' : null,
                  ),
                  TextFormField(
                    onSaved: (value) => _email = value.trim(),
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
                  SizedBox(height: 10),
                  RaisedButton(
                    color: Colors.grey,
                    child: Text("Create Account"),
                    onPressed: () async {
                      print("PRESSED");
                      final form = _formKey.currentState;
                      form.save();

                      // Validate will return true if is valid, or false if invalid.
                      if (form.validate()) {
                        try {
                          AuthResult result =
                          await Provider.of<AuthService>(context)
                              .signUp(email: _email.trim(), password: _password);
                          print(result);

                        } on AuthException catch (error) {
                          // handle the firebase specific error
                          return _buildErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          // gracefully handle anything else that might happen..
                          return _buildErrorDialog(context, error.toString());
                        }

                      }
                      FirebaseUser user = await Provider.of<AuthService>(context).getUser();
                      //write a data: key, value
                      ref.child("House/Ranch/Users/"+user.uid).set(
                          {
                            "User First Name" : fNameEditController.text.toString().trim(),
                            "User Last Name" : lNameEditController.text.toString().trim()
                          }
                      ).then((res) {
                        print("User is added ");
                      }).catchError((e) {
                        print("Failed to add the user. " + e.toString());
                      });

                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
