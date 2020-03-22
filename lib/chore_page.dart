import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:firebase_database/firebase_database.dart';

class ChorePage extends StatefulWidget {
  final FirebaseUser currentUser; // ⇐ NEW

  ChorePage(this.currentUser); // ⇐ NEW

  @override
  _ChorePageState createState() => _ChorePageState();
}

class _ChorePageState extends State<ChorePage> {

  var idEditController = TextEditingController();
  var nameEditController = TextEditingController();
  var majorEditController = TextEditingController();

  var studentList = [];

  final ref = FirebaseDatabase.instance.reference();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String userFName="";
  String currId = "3";
  String welcomeMessage = "";


  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser();
    ref.child("House/Ranch/Users/" + user.uid+"/User First Name").once().then((ds){
      userFName = ds.value;
      currId = user.uid;
      welcomeMessage = "Welcome $userFName";
      setState(() {

      });
    }).catchError((e){
      print("Failed to get user. "+e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(
            // ⇐ NEW
            'Home Page Flutter Firebase  Content',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0), // ⇐ NEW
          SizedBox(
            // ⇐ NEW
            //"Welcome ${widget.currentUser.email}",
            child: Text(welcomeMessage),
//            style: TextStyle(
//                fontSize: 18,
//                fontWeight: FontWeight.bold,
//                fontStyle: FontStyle.italic),
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
                ref.child("House/Ranch/Chores/"+ userFName + new DateTime.now().millisecondsSinceEpoch.toString()).set(
                    {
                      "Chore Name" : idEditController.text.toString(),
                      "Chore Assigned To" : nameEditController.text.toString()
                    }
                ).then((res) {
                  print("Chore is added ");
                }).catchError((e) {
                  print("Failed to add the chore. " + e.toString());
                });


                ref.child("House/Ranch/Chores/").once().then((ds){

                /*  var tempList = [];
                  ds.value.forEach((k,v) {
                    tempList.add(v);
                  });
                  studentList.clear();
                  setState(() {
                    studentList = tempList;
                  });*/

                print(ds.value);
                studentList.clear();
                ds.value.forEach((k,v) {
                  setState(() {
                    studentList.add(v);
                  });
                });
                print("LIST: $studentList");
                print("");
                }).catchError((e){
                  print("Failed to get user. "+e.toString());
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
              itemCount: studentList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  child: Center(child: Text("${studentList[index]['Chore Assigned To']}'s chore is ${studentList[index]['Chore Name']}")),
                  //child: Center(child: Text("Hi ${studentList[index]['Chore Assigned To']}, $userFName 's chore is ${studentList[index]['Chore Name']}")),
                );
              },
            )
          )
        ],
      ),
    );
  }
}
