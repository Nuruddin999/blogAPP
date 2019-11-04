import 'package:flutter/material.dart';

import 'Authentification.dart';
import 'Post.dart';
import 'PostImage.dart';
import 'PostUpdate.dart';
import 'User.dart';
import 'api/blogservice.dart';

class MainPage extends StatefulWidget {
  MainPage({this.auth, this.onSignedOut});

  final Authentification auth;
  final VoidCallback onSignedOut;

  @override
  _MainPageState createState() => _MainPageState();
}
var currentvalue;
const dropdownitems=["delete",'edit'];
class _MainPageState extends State<MainPage> {
  List<Post> posts = [];

  void _exit() async {
    try {
      await widget.auth.logOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    blogservice().getAllData().then((list) {
      for (var post in list) {
        posts.add(post);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13.0),
            child: Text(
              "Draft",
              style: TextStyle(color: Colors.black26, letterSpacing: 4.0),
            )),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/camera.png"),
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset("assets/login.ico"),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[postItem(posts, context)],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        child: Container(
          margin: EdgeInsets.only(left: 50.0, right: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                  icon: Image.asset("assets/login.ico"),
                  onPressed: () {
                    _exit();
                  }),
              IconButton(
                  icon: Icon(Icons.add_a_photo, color: Colors.deepOrangeAccent),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PostImage();
                    }));
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget postItem(List<Post> posts, context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFF0F0F0)
            )
          )
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    posts[index].accaunt,
                    style: TextStyle(fontSize: 13),
                  )),
                  DropdownButton(value: currentvalue, items: dropdownitems.map((String value){
                    return DropdownMenuItem<String>(child: Text(value),value: value,);
                  }).toList(), onChanged: (newvalue){
                    setState(() {
                      currentvalue=newvalue;
                    });
                    switch (currentvalue){
                      case "delete":
                        posts.removeAt(index);
                        break;
                      case "edit":
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PostUpdate(post: posts[index],);
                          }));
                        }

                    }
                  }),
                  Image.asset(
                    "assets/more.png",
                    height: 15,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Image.network(
              posts[index].image,
              fit: BoxFit.cover,
              height: 350,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:2.0,horizontal: 10),
              child: Row(
          children: <Widget>[
              Image.asset("assets/heart.png", height: 35,width: 25,)
          ],
          ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0,horizontal:10.0),
                child: Text("1000 likes"),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,bottom: 20.0),
                child: RichText(text: TextSpan(
                  style: TextStyle(fontSize: 14,
                  color: Colors.black),
                    children: <TextSpan>[
TextSpan(text: "${posts[index].accaunt} ",style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "${posts[index].body}",style: TextStyle(fontWeight: FontWeight.normal))

                  ]
                )),
              ),
            )
          ],
        ),
      );
    }, childCount: posts.length));
  }
}
