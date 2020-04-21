import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:roommate_app/todo_item.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ChorePage extends StatefulWidget {
  final FirebaseUser currentUser;

  ChorePage(this.currentUser);

  @override
  _ChorePageState createState() => _ChorePageState();
}

class _ChorePageState extends State<ChorePage> {
  final FocusNode _choreFocus = FocusNode();
  final FocusNode _assignFocus = FocusNode();

  Color pickerColor = Colors.blue;

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

  var choreEditController = TextEditingController();
  var nameEditController = TextEditingController();
  var majorEditController = TextEditingController();
  var dateEditController = TextEditingController();
  var timeEditController = TextEditingController();

  var choreList = [];
  var choreListOld = [];
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
    //_showListOfChores();
  }

  initUser() async {
/*    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
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
      _showListOfChores();
      setState(() {
      });
      populateUsers();

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

  populateUsers() async {
    //await initUser();
    ref.child("House/$houseName/Users/").once().then((ds) {
      ds.value.forEach((k, v) {
        _names.add(v['User First Name'] + " " + v['User Last Name'].substring(0,1));
      });
    }).catchError((e) {
      print("Failed to get user4. " + e.toString());
    });
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _showListOfChores() {
    print("MNAME: " + houseName);
    ref.child("House/" + houseName + "/Chores/").once().then((ds) {
      var tempList = [];
      ds.value.forEach((k, v) {
        if (!v['Done']) {
          tempList.add(v);
        } else {
          tempList.insert(0, v);
        }
      });
      tempList.sort((a, b) {
        if (a['Done'] && !b['Done'])
          return 0;
        else
          return a['Date Info'].compareTo(b['Date Info']);
      });

      //=> (a['Date Info'].compareTo(b['Date Info'])) && a['Done']);
      choreList.clear();
      setState(() {
        choreList = tempList;
      });
      //print("LIST: $choreList");
      //print("");
    }).catchError((e) {
      print("Failed to get user6. " + e.toString());
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

  void _addChore(_chore, _who, _date, _time, _color) {
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

    print(_color);
    //write a data: key, value
    ref
        .child("House/" +
        houseName +
        "/Chores/" +
        userFName +
        new DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      "Chore Name": _chore,
      "Chore Assigned To": _who,
      "Date Due": _date,
      "Time Due": _time,
      "Date Info": myDate.toIso8601String(),
      "Done": false,
      "Color": _color.substring(37, _color.length-2)
    }).then((res) {
      print("Chore is added ");
    }).catchError((e) {
      print("Failed to add the chore. " + e.toString());
    });

    ref.child("House/" + houseName + "/Chores/").once().then((ds) {
      var tempList = [];
      ds.value.forEach((k, v) {
        tempList.add(v);
      });
      tempList.sort((a, b) => (a['Date Info'].compareTo(b['Date Info'])));
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
            'Chore List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            //"Welcome ${widget.currentUser.email}",
            child: Text(welcomeMessage + "\n$houseName",
                textAlign: TextAlign.center),
//            style: TextStyle(
//                fontSize: 18,
//                fontWeight: FontWeight.bold,
//                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 18.0),
          Visibility(
            visible: _isNotPicking,
            child: Expanded(
                child: ListView.builder(
              itemCount: choreList.length,
              itemBuilder: (BuildContext context, int index) {
                return ToDoItem(
                    isDone: choreList[index]['Done'],
                    myChore: choreList[index]['Chore Name'],
                    myDate: choreList[index]['Date Due'],
                    myName: choreList[index]['Chore Assigned To'],
                    myTime: choreList[index]['Time Due'],
                    myHouse: houseName,
                    myColor: Color(int.parse(choreList[index]['Color'], radix: 16)));
              },
            )),
          ),
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
                labelText: ("Chore"),
                icon: Icon(Icons.room_service, color: Colors.grey),
              ),
            ),
          ),
          Visibility(
            visible: _isPicking,
            child: Container(
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
          ),
          Visibility(
            visible: _isPicking,
            child: DateTimeField(
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
          ),
          Visibility(
            visible: _isPicking,
            child: DateTimeField(
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
                    child: Text("Add Chore"),
                    onPressed: () {
                      if (_selectedName != null &&
                          choreEditController.text.toString() != "" &&
                          dateEditController.text.toString() != "" &&
                          timeEditController.text.toString() != "") {
                        _addChore(
                            choreEditController.text.toString(),
                            _selectedName,
                            dateEditController.text.toString(),
                            timeEditController.text.toString(),
                            pickerColor.toString());
                        _showListOfChores();
                        setState(() {
                          _isNotPicking = true;
                          _isPicking = false;
                          _selectedName = null;
                          choreEditController.text = "";
                          dateEditController.text = "";
                          timeEditController.text = "";
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
                      _showListOfChores();
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
                child: Text("Add New Chore"),
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
