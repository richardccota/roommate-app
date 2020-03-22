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

  var studentList = [];

  final ref = FirebaseDatabase.instance.reference();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String userFName="HELLO";
  String currId = "3";

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    Text("Screen 1"),
    Text("Screen 2"),
    Text("Screen 3"),
  ];

  void _onTapBottomNavBar(index) {
    setState(() {
      _selectedIndex = index;
    });
    print("screen $_selectedIndex has been chosen");
  }

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
      setState(() {

      });
    }).catchError((e){
      print("Failed to get user. "+e.toString());
    });
  }

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
          _widgetOptions.elementAt(_selectedIndex),
          Text(
            // ⇐ NEW
            'Home Page Flutter Firebase  Content',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0), // ⇐ NEW
          SizedBox(
            // ⇐ NEW
            //"Welcome ${widget.currentUser.email}",
            child: Text("Welcome "+ userFName),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text("Shopping List"),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text("Chores"),
            icon: Icon(Icons.account_box),
          ),
          BottomNavigationBarItem(
            title: Text("Other"),
            icon: Icon(Icons.email),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTapBottomNavBar,
      ),
    );
  }
}
