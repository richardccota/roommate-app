import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommate_app/authenticator.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser currentUser; // ⇐ NEW

  HomePage(this.currentUser); // ⇐ NEW

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Flutter Firebase"),
        //actions: <Widget>[LogoutButton()],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20.0), // ⇐ NEW
          Text(
            // ⇐ NEW
            'Home Page Flutter Firebase  Content',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0), // ⇐ NEW
          Text(
            // ⇐ NEW
            "Welcome ${widget.currentUser.email}",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 20.0),
          RaisedButton(
              child: Text("LOGOUT"),
              onPressed: () async {
                await Provider.of<AuthService>(context).logout();
              })
        ],
      ),
    );
  }
}
