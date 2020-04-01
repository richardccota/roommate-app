import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:roommate_app/login_page.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class ShoppingListPage extends StatefulWidget {
  final FirebaseUser currentUser;

  ShoppingListPage(this.currentUser);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final FocusNode _choreFocus = FocusNode();
  final FocusNode _assignFocus = FocusNode();

  final dFormat = DateFormat.yMMMMEEEEd("en_US");
  final tFormat = DateFormat.jm();

  List<String> _names = [];
  var nameList = [];
  String _selectedName;

  var choreEditController = TextEditingController();
  var nameEditController = TextEditingController();
  var majorEditController = TextEditingController();
  var dateEditController = TextEditingController();
  var timeEditController = TextEditingController();

  var studentList = [];
  DateTime currDate = DateTime.now();

  final ref = FirebaseDatabase.instance.reference();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String userFName = "";
  String currId = "3";
  String welcomeMessage = "";

  @override
  void initState() {
    super.initState();
    initUser();
    populateUsers();
    _showListOfChores();
  }

  initUser() async {
    user = await _auth.currentUser();
    ref
        .child("House/Ranch/Users/" + user.uid + "/User First Name")
        .once()
        .then((ds) {
      userFName = ds.value;
      currId = user.uid;
      welcomeMessage = "Welcome $userFName";
      setState(() {});
    }).catchError((e) {
      print("Failed to get user. " + e.toString());
    });
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

  populateUsers() {
    ref.child("House/Ranch/Users/").once().then((ds) {
      ds.value.forEach((k, v) {
        _names.add(v['User First Name']);
      });
    }).catchError((e) {
      print("Failed to get user. " + e.toString());
    });
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _showListOfChores() {
    ref.child("House/Ranch/Chores/").once().then((ds) {
      var tempList = [];
      ds.value.forEach((k, v) {
        tempList.add(v);
      });
      tempList.sort((a, b) => (a['Date Info'].compareTo(b['Date Info'])));
      studentList.clear();
      setState(() {
        studentList = tempList;
      });
      print("LIST: $studentList");
      print("");
    }).catchError((e) {
      print("Failed to get user. " + e.toString());
    });

    /*print(ds.value);
                studentList.sort((a, b) => a['Date Due'].isBefore(b['Date Due']));
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
                });*/
  }

  void _addChore(_chore, _who, _date, _time) {

    var dateSplit = _date.split(" ");
    var myMonth = dateSplit[1];
    var myDay = dateSplit[2].substring(0, dateSplit[2].length - 1);
    var myYear = dateSplit[3];
    var myMonthNum = 0;

    var timeSplit = _time.split(":");
    var myHour = int.parse(timeSplit[0]);
    var myMinute = timeSplit[1].substring(0, 2);
    var myAMPM = timeSplit[1].substring(3);

    if (myAMPM == "PM") myHour += 12;

    var monthList = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    for (var i = 0; i < 12; i++) {
      if (monthList[i] == myMonth) myMonthNum = i + 1;
    }

    var myDate = new DateTime(int.parse(myYear), myMonthNum, int.parse(myDay),
        myHour, int.parse(myMinute));
    print(myDate);

    //print(userFName);

    //write a data: key, value
    ref
        .child("House/Ranch/Chores/" +
        userFName +
        new DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "Chore Name": _chore,
      "Chore Assigned To": _who,
      "Date Due": _date,
      "Time Due": _time,
      "Date Info": myDate.toIso8601String(),
    }).then((res) {
      print("Chore is added ");
    }).catchError((e) {
      print("Failed to add the chore. " + e.toString());
    });

    ref.child("House/Ranch/Chores/").once().then((ds) {
      var tempList = [];
      ds.value.forEach((k, v) {
        tempList.add(v);
      });
      tempList.sort((a, b) => (a['Date Info'].compareTo(b['Date Info'])));
      studentList.clear();
      setState(() {
        studentList = tempList;
      });
      print("LIST: $studentList");
      print("");
    }).catchError((e) {
      print("Failed to get user. " + e.toString());
    });

    /*print(ds.value);
                studentList.sort((a, b) => a['Date Due'].isBefore(b['Date Due']));
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
                });*/
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
          SizedBox(height: 20.0),
          SizedBox(
            //"Welcome ${widget.currentUser.email}",
            child: Text(welcomeMessage),
//            style: TextStyle(
//                fontSize: 18,
//                fontWeight: FontWeight.bold,
//                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 18.0),
          Expanded(
              child: ListView.builder(
                itemCount: studentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text(
                            "${studentList[index]['Chore Assigned To']} has to ${studentList[index]['Chore Name']} by ${studentList[index]['Date Due']} at ${studentList[index]['Time Due']}")),
                    //child: Center(child: Text("Hi ${studentList[index]['Chore Assigned To']}, $userFName 's chore is ${studentList[index]['Chore Name']}")),
                  );
                },
              )),
          TextFormField(
            controller: choreEditController,
            focusNode: _choreFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) {
              _fieldFocusChange(context, _choreFocus, _assignFocus);
            },
            decoration: InputDecoration(
              labelText: ("Chore"),
              icon: Icon(Icons.room_service, color: Colors.grey),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(Icons.person, color: Colors.grey),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 17),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                        hint: Text('Assign Chore To'),
                        underline: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                        ),
                        value: _selectedName,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedName = newValue;
                          });
                        },
                        items: _names.map((name) {
                          return DropdownMenuItem(
                            child: Text(name),
                            value: name,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DateTimeField(
              controller: dateEditController,
              decoration: InputDecoration(
                labelText: ("Date"),
                icon: Icon(Icons.calendar_today, color: Colors.grey),
              ),
              format: dFormat,
              //get date
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    initialDate: currDate,
                    firstDate: currDate,
                    lastDate: DateTime(2022));
              }),
          DateTimeField(
              controller: timeEditController,
              decoration: InputDecoration(
                labelText: ("Time"),
                icon: Icon(Icons.access_time, color: Colors.grey),
              ),
              format: tFormat,
              onShowPicker: (context, currentValue) async {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.convert(time);
              }),
          RaisedButton(
              child: Text("Add Chore"),
              onPressed: () {
                if (_selectedName != null &&
                    choreEditController.text.toString() != "" &&
                    dateEditController.text.toString() != "" &&
                    timeEditController.text.toString() != "") {
                  _addChore(_selectedName, choreEditController.text.toString(), dateEditController.text.toString(), timeEditController.text.toString());
                  _showListOfChores();
                } else {
                  _showDialog("Error!", "Please fill out all fields");
                }
              }),
          RaisedButton(
              child: Text("LOGOUT"),
              onPressed: () async {
                await Provider.of<AuthService>(context).logout();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }),
        ],
      ),
    );
  }
}