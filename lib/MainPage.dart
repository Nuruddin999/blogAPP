import 'package:flutter/material.dart';

import 'Authentification.dart';
import 'User.dart';
import 'api/blogservice.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  blogservice b=blogservice();
  @override
  void initState() {
    Authentification auth=Auth();
auth.signUp("sg7720@gmail.com", "234");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your stories"),
      ),
      body: Container(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: Container(
          margin: EdgeInsets.only(left: 50.0,right: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                  icon: Image.asset("assets/login.ico"), onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.add_a_photo, color: Colors.deepOrangeAccent), onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
