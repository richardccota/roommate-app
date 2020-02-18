import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Roommate App Login'),
            backgroundColor: Colors.lightGreen,
          ),
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Please login to your Account"),
                      SizedBox(
                        height: 90
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: ("Username"),
                        ),
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: ("Password"),
                        ),
                      ),
                      SizedBox(
                        height: 30
                      ),
                      RaisedButton(
                          child: Text("Login"),
                          onPressed: () => {},
                          color: Colors.lightGreen
                      ),
                    ],
                  ),
              ),
          ),
    );
  }
}
