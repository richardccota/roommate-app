import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:roommate_app/chore_page.dart';
import 'package:roommate_app/home_page.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser currentUser; // ⇐ NEW

  HomePage(this.currentUser); // ⇐ NEW

  @override
  _HomePageState createState() => _HomePageState();
}

FirebaseUser _currentUser;

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  initUser() async {
    _currentUser = await _auth.currentUser();
  }

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    Text("Screen 1"),
    ChorePage(_currentUser),
    Text("Screen 3"),
  ];

  void _onTapBottomNavBar(index) {
    setState(() {
      _selectedIndex = index;
    });
    print("screen $_selectedIndex has been chosen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body:
          _widgetOptions.elementAt(_selectedIndex)
    );
  }
}
