import 'package:flutter/material.dart';

class ToDoItem extends StatefulWidget {

  bool isDone;
  String myChore;
  String myName;
  String myDate;
  String myTime;


  ToDoItem({Key key, this.isDone, this.myChore, this.myName, this.myDate, this.myTime}) : super(key: key);

  @override
  _ToDoItemState createState() => _ToDoItemState();


}

class _ToDoItemState extends State<ToDoItem> {
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
                "${widget.myName}: ${widget.myChore} \n${widget.myDate}, ${widget.myTime}"
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
