import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ToDoItem extends StatefulWidget {
  bool isDone;
  String myChore;
  String myName;
  String myDate;
  String myTime;
  String myHouse;
  Color myColor;

  ToDoItem(
      {Key key,
      this.isDone,
      this.myChore,
      this.myName,
      this.myDate,
      this.myTime,
      this.myHouse,
      this.myColor})
      : super(key: key);

  @override
  _ToDoItemState createState() => _ToDoItemState();
}

class ShoppingItem extends StatefulWidget {
  bool isDone;
  String myItem;
  String myHouse;
  Color myColor;

  ShoppingItem({Key key, this.isDone, this.myItem, this.myHouse, this.myColor})
      : super(key: key);

  @override
  _ShoppingItemState createState() => _ShoppingItemState();
}

class _ToDoItemState extends State<ToDoItem> {
  final ref = FirebaseDatabase.instance.reference();
  final ref2 = FirebaseDatabase.instance.reference();
  var choreList = [];

  void _updateStatus(chore, date, name, time, done, color) {
    print("UPDATING?");
    ref.child("House/${widget.myHouse}/Chores/").once().then((ds) {
      ds.value.forEach((k, v) {
        if (v['Chore Name'] == chore &&
            v['Date Due'] == date &&
            v['Chore Assigned To'] == name &&
            v['Time Due'] == time) {
          ref2
              .child("House/${widget.myHouse}/Chores/" + k)
              .update({"Done": done}).then((res) {
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
        margin: EdgeInsets.fromLTRB(4, 6, 4, 0),
        decoration: BoxDecoration(
          color: widget.myColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0))),
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
                              widget.myName, widget.myTime, val, widget.myColor);
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

class _ShoppingItemState extends State<ShoppingItem> {
  final ref = FirebaseDatabase.instance.reference();
  final ref2 = FirebaseDatabase.instance.reference();
  var choreList = [];

  void _updateStatus(item, done, color) {
    print("Running _updateStatus");
    print(widget.myHouse);
    ref.child("House/${widget.myHouse}/Items/").once().then((ds) {
      ds.value.forEach((k, v) {
        if (v['Item Name'] == item) {
          ref2
              .child("House/${widget.myHouse}/Items/" + k)
              .update({"Done": done}).then((res) {
            print("Item is updated ");
          }).catchError((e) {
            print("Failed to update the item. " + e.toString());
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
        margin: EdgeInsets.fromLTRB(4, 6, 4, 0),
        decoration: BoxDecoration(
            color: widget.myColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0))),
        child: Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Checkbox(
                    value: widget.isDone,
                    onChanged: (val) {
                      _updateStatus(widget.myItem, val, widget.myColor);
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
              Text("${widget.myItem}"),
            ],
          ),
        ),
      ],
    ));
  }
}
