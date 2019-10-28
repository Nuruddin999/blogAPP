import 'package:flutter/material.dart';

import 'Authentification.dart';
import 'PostImage.dart';
import 'User.dart';
import 'api/blogservice.dart';

class MainPage extends StatefulWidget {

  MainPage({this.auth, this.onSignedOut});
  final Authentification auth;
  final VoidCallback onSignedOut;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
 void _exit() async {
   try {
     await widget.auth.logOut();
     widget.onSignedOut();
   } catch (e){
     print(e.toString());
   }
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
                  icon: Image.asset("assets/login.ico"), onPressed: () {
                    _exit();
              }),
              IconButton(
                  icon: Icon(Icons.add_a_photo, color: Colors.deepOrangeAccent), onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                 return  PostImage();
                    }));
              })
            ],
          ),
        ),
      ),
    );
  }
}
