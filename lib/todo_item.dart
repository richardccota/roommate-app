import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ToDoItem extends StatefulWidget {
  bool isDone;
  String myChore;
  String myName;
  String myDate;
  String myTime;

  ToDoItem(
      {Key key,
      this.isDone,
      this.myChore,
      this.myName,
      this.myDate,
      this.myTime})
      : super(key: key);

  @override
  _ToDoItemState createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  final ref = FirebaseDatabase.instance.reference();
  final ref2 = FirebaseDatabase.instance.reference();
  var choreList = [];


  void _updateStatus(chore, date, name, time, done) {
    ref.child("House/Ranch/Chores/").once().then((ds) {
      var tempList = [];
      ds.value.forEach((k, v) {
        if (v['Chore Name'] == chore &&
            v['Date Due'] == date &&
            v['Chore Assigned To'] == name &&
            v['Time Due'] == time) {
          ref2.child("House/Ranch/Chores/" + k).update({
            "Done": done
          }).then((res) {
            print("Chore is updated ");
          }).catchError((e) {
            print("Failed to update the chore. " + e.toString());
          });
        }
      });
    }).catchError((e) {
      print("Failed to get user. " + e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Checkbox(
                    value: widget.isDone,
                    onChanged: (val) {
                      _updateStatus(widget.myChore, widget.myDate,
                          widget.myName, widget.myTime, val);
                      setState(() {
                        widget.isDone = val;
                      });
                    }),
              ],
            )),
        Expanded(
          flex: 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "${widget.myName}: ${widget.myChore} \n${widget.myDate}, ${widget.myTime}"),
            ],
          ),
        ),
      ],
    ));
  }
}
