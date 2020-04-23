import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:roommate_app/todo_item.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ShoppingPage extends StatefulWidget {
  final FirebaseUser currentUser;

  ShoppingPage(this.currentUser);

  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final FocusNode _choreFocus = FocusNode();
  final FocusNode _assignFocus = FocusNode();

  final dFormat = DateFormat.yMMMMEEEEd("en_US");
  final tFormat = DateFormat.jm();

  final snackBar = SnackBar(
    content: Text("Chore Added!"),
    duration: const Duration(milliseconds: 1200),
  );

  List<String> _names = [];
  var nameList = [];
  String _selectedName;

  var _isPicking = false;
  var _isNotPicking = true;
  var _isPickingColor = false;

  Color pickerColor = Colors.blue;

  var choreEditController = TextEditingController();
  var nameEditController = TextEditingController();
  var majorEditController = TextEditingController();
  var dateEditController = TextEditingController();
  var timeEditController = TextEditingController();

  var choreList = [];
  DateTime currDate = DateTime.now();

  final ref = FirebaseDatabase.instance.reference();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String userFName = "";
  String currId = "3";
  String welcomeMessage = "";
  String houseName = "";

  @override
  void initState() {
    super.initState();
    initUser();
    //populateUsers();
    //_showListOfItems();
  }

  initUser() async {
   /* final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      houseName = (sharedPrefs.getString('House Name'));
    });*/
    user = await _auth.currentUser();
    ref
        .child("Users/" + user.uid)
        .once()
        .then((ds) {
          houseName = ds.value['House'];
          userFName = ds.value['User First Name'];
          welcomeMessage = "Welcome $userFName!";
          print(houseName);
          print(userFName);
          setState(() {});
          _showListOfItems();
    }).catchError((e) {
      print("Failed to get user. " + e.toString());
    });

    /*ref
        .child("House/" + houseName + "/Users/" + user.uid + "/User First Name")
        .once()
        .then((ds) {
          print(user.uid);
      userFName = ds.value;
      currId = user.uid;
      welcomeMessage = "Welcome $userFName";
      setState(() {});
    }).catchError((e) {
      print("Failed to get user. " + e.toString());
    });
    _showListOfItems();*/
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void _showDialog(_title, _message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(_title),
          content: Text(_message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _showListOfItems() {
    print("NAME: " + houseName);
    ref.child("House/" + houseName + "/Items/").once().then((ds) {
      var tempList = [];
      ds.value.forEach((k, v) {
        if(!v['Done'])
          tempList.add(v);
        else
          tempList.insert(0, v);
      });
      choreList.clear();
      setState(() {
        choreList = tempList;
      });
    }).catchError((e) {
      print("Failed to get user8. " + e.toString());
    });

    /*print(ds.value);
                choreList.sort((a, b) => a['Date Due'].isBefore(b['Date Due']));
                choreList.clear();
                ds.value.forEach((k,v) {
                  setState(() {
                    choreList.add(v);
                  });
                });
                print("LIST: $choreList");
                print("");
                }).catchError((e){
                  print("Failed to get user. "+e.toString());
                });*/
  }

  void _addItem(_item, _color) {

    //write a data: key, value
    ref
        .child("House/" +
        houseName +
        "/Items/" +
        userFName +
        new DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "Item Name": _item,
      "Done": false,
      "Color": _color.substring(37, _color.length-2),
      "Added By": userFName
    }).then((res) {
      print("Chore is added ");
    }).catchError((e) {
      print("Failed to add the chore. " + e.toString());
    });

    ref.child("House/" + houseName + "/Items/").once().then((ds) {
      var tempList = [];
      ds.value.forEach((k, v) {
        tempList.add(v);
      });
      choreList.clear();
      setState(() {
        choreList = tempList;
      });
      //("LIST: $choreList");
      //print("");
    }).catchError((e) {
      print("Failed to get user. " + e.toString());
    });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 25.0),
          Text(
            'Shopping List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            //"Welcome ${widget.currentUser.email}",
            child: Text(
                welcomeMessage + "\n$houseName",
                textAlign: TextAlign.center
            ),
//            style: TextStyle(
//                fontSize: 18,
//                fontWeight: FontWeight.bold,
//                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 18.0),
          Expanded(
              child: ListView.builder(
                itemCount: choreList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ShoppingItem(
                    isDone: choreList[index]['Done'],
                    myItem: choreList[index]['Item Name'],
                    myHouse: houseName,
                    myColor: Color(int.parse(choreList[index]['Color'], radix: 16)),
                    myName: choreList[index]['Added By'],
                  );
                },
              )),
          Visibility(
            visible: _isPicking,
            child: TextFormField(
              controller: choreEditController,
              focusNode: _choreFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (term) {
                _fieldFocusChange(context, _choreFocus, _assignFocus);
              },
              decoration: InputDecoration(
                labelText: ("Item"),
                icon: Icon(Icons.shopping_basket, color: Colors.grey),
              ),
            ),
          ),
          Visibility(
              visible: _isPicking,
              child: RaisedButton(
                child: Text("Choose Color"),
                onPressed: () {
                  setState(() {
                    _isPicking = false;
                    _isPickingColor = true;
                  });
                },
                color: pickerColor,
              )),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: _isPicking,
                    child: RaisedButton(
                        child: Text("Add Item"),
                        onPressed: () {
                          if (
                              choreEditController.text.toString() != "") {
                            _addItem(
                                choreEditController.text.toString(), pickerColor.toString());
                            _showListOfItems();
                            setState(() {
                              _isNotPicking = true;
                              _isPicking = false;
                              choreEditController.text = "";
                            });
                            Scaffold.of(context).showSnackBar(snackBar);
                          } else {
                            _showDialog(
                                "Error!", "Please fill out all of the fields");
                          }
                        }),
                  ),
                  Visibility(
                      visible: _isPicking,
                      child: RaisedButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          setState(() {
                            _isNotPicking = true;
                            _isPicking = false;
                          });
                        },
                      )),
                ],
              )),
          Visibility(
              visible: _isPickingColor,
              child: BlockPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              )),
          Visibility(
              visible: _isPickingColor,
              child: SizedBox(
                height: 20,
              )),
          Visibility(
              visible: _isPickingColor,
              child: RaisedButton(
                child: Text("Confirm"),
                color: pickerColor,
                textColor: Colors.black,
                onPressed: () {
                  setState(() {
                    _isPickingColor = false;
                    _isPicking = true;
                  });
                },
              )),
          Visibility(
              visible: _isNotPicking,
              child: RaisedButton(
                child: Text("Add New Item"),
                onPressed: () {
                  setState(() {
                    _isNotPicking = false;
                    _isPicking = true;
                  });
                },
              ))
          /*RaisedButton(
              child: Text("LOGOUT"),
              onPressed: () async {
                await Provider.of<AuthService>(context).logout();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }),*/
        ],
      ),
    );
  }
}
