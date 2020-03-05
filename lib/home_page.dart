import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser currentUser; // ⇐ NEW

  HomePage(this.currentUser); // ⇐ NEW

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var idEditController = TextEditingController();
  var nameEditController = TextEditingController();
  var majorEditController = TextEditingController();

  final ref = FirebaseDatabase.instance.reference();

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
          SizedBox(height: 18.0),
          TextFormField(
            controller: idEditController,
            decoration: InputDecoration(
              labelText: ("Chore"),
              icon: Icon(Icons.lock, color: Colors.grey),
            ),
          ),
          TextFormField(
            controller: nameEditController,
            decoration: InputDecoration(
              labelText: ("Assign To"),
              icon: Icon(Icons.lock, color: Colors.grey),
            ),
          ),


          RaisedButton(
              child: Text("UPDATE"),
              onPressed: () {
                print(idEditController.text.toString());
                print(nameEditController.text.toString());

                //write a data: key, value
                ref.child("House/Ranch/Chores/"+idEditController.text.toString()).set(
                    {
                      "Chore Name" : nameEditController.text.toString()
                    }
                ).then((res) {
                  print("Chore is added ");
                }).catchError((e) {
                  print("Failed to add the chore. " + e.toString());
                });

              }
          ),
          RaisedButton(
              child: Text("LOGOUT"),
              onPressed: () async {
                await Provider.of<AuthService>(context).logout();
              }),

          Expanded(
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  child: Center(child: Text("HI $index"))
                );
              },
            )
          )
        ],
      ),
    );
  }
}
