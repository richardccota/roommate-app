import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommate_app/create_account_page.dart';
import 'package:roommate_app/login_page.dart';
import 'package:roommate_app/home_page.dart';
import 'package:roommate_app/authenticator.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        builder: (BuildContext context) {
          return AuthService();
        },
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          //          ⇐ NEW
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console                                            ⇐ NEW
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            }
            // redirect to the proper page, pass the user into the
            // `HomePage` so we can display the user email in welcome msg     ⇐ NEW
            //return NavigatorPage();
            return snapshot.hasData ? HomePage(snapshot.data) : LoginPage();
          } else {
            // show loading indicator                                         ⇐ NEW
            return LoadingCircle();
          }
        },
      ),
    );
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
 // _MyHomePageState createState() => _MyHomePageState();
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
              SizedBox(height: 90),
              TextFormField(
                decoration: InputDecoration(
                  labelText: ("Username"),
                  icon: Icon(Icons.account_box, color: Colors.grey),
                ),
                validator: (value) => value.isEmpty ? 'Can\'t be empty' : null,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: ("Password"),
                  icon: Icon(Icons.lock, color: Colors.grey),
                ),
                validator: (value) => value.isEmpty ? 'Cannot be empty' : null,
              ),
              SizedBox(height: 30),
              RaisedButton(
                elevation: 5,
                //child: Text(_isLoginForm ? 'Login' : 'Create Account'),
                // onPressed: validateAndSubmit,
                color: Colors.lightGreen,
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
