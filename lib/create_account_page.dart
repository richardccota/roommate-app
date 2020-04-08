import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:roommate_app/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _houseFocus = FocusNode();

  String _fName;
  String _lName;
  String _house;
  String _password;
  String _email;

  var fNameEditController = TextEditingController();
  var lNameEditController = TextEditingController();
  var houseEditController = TextEditingController();

  final ref = FirebaseDatabase.instance.reference();

  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Roommate App Create Account'),
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
                  Text("Please enter your information"),
                  //SizedBox(height: 60),
                  TextFormField(
                    controller: fNameEditController,
                    onSaved: (value) => _fName = value.trim(),
                    focusNode: _fNameFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _fNameFocus, _lNameFocus);
                    },
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
                    focusNode: _lNameFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _lNameFocus, _houseFocus);
                    },
                    decoration: InputDecoration(
                      labelText: ("Last Name"),
                      icon: Icon(Icons.account_box, color: Colors.grey),
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'Can\'t be empty' : null,
                  ),
                  TextFormField(
                    controller: houseEditController,
                    onSaved: (value) => _house = value.trim(),
                    focusNode: _houseFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term){
                      _fieldFocusChange(context, _houseFocus, _emailFocus);
                    },
                    decoration: InputDecoration(
                      labelText: ("House Name"),
                      icon: Icon(Icons.home, color: Colors.grey),
                    ),
                    validator: (value) =>
                    value.isEmpty ? 'Can\'t be empty' : null,
                  ),
                  TextFormField(
                    onSaved: (value) => _email = value.trim(),
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
                      ref.child("House/"+houseEditController.text.toString().trim()+"/Users/"+user.uid).set(
                          {
                            "User First Name" : fNameEditController.text.toString().trim(),
                            "User Last Name" : lNameEditController.text.toString().trim(),
                            "House" : houseEditController.text.toString().trim()
                          }
                      ).then((res) {
                        print("User is added ");
                      }).catchError((e) {
                        print("Failed to add the user. " + e.toString());
                      });
                      ref.child("Users/"+user.uid).set(
                          {
                            "User First Name" : fNameEditController.text.toString().trim(),
                            "User Last Name" : lNameEditController.text.toString().trim(),
                            "House" : houseEditController.text.toString().trim()
                          }
                      ).then((res) {
                        print("User is added ");
                      }).catchError((e) {
                        print("Failed to add the user. " + e.toString());
                      });

                    SharedPreferences myPrefs = await SharedPreferences.getInstance();
                    myPrefs.setString('House Name', houseEditController.text.toString().trim());

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(user))
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
