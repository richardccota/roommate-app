import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommate_app/authenticator.dart';

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
  final houseEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100),
                  //Text("Settings"),
                  SizedBox(height: 60),
                  /*Container(
                    alignment: Alignment.center,
                    child: Text("COMING SOON",
                    textAlign: TextAlign.center,
                    textScaleFactor: 5,),
                  ),*/
                  /*TextFormField(
                    controller: houseEditController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: ("House Name"),
                      icon: Icon(Icons.room_service, color: Colors.grey),
                    ),
                  ),

                  RaisedButton(
                    color: Colors.grey,
                    child: Text("Update"),
                    onPressed: () async {
                      SharedPreferences myPrefs = await SharedPreferences.getInstance();
                      myPrefs.setString('House Name', houseEditController.text.toString().trim());
                    },
                  ),*/
                  Center(
                    child: RaisedButton(
                        child: Text("LOGOUT"),
                        onPressed: () async {
                          await Provider.of<AuthService>(context).logout();
                        }),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
