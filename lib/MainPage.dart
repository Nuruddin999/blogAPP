import 'package:flutter/material.dart';

import 'Authentification.dart';
import 'Post.dart';
import 'PostImage.dart';
import 'PostListitem.dart';
import 'PostUpdate.dart';
import 'ShowHideText.dart';
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
const dropdownitems = ["delete", 'edit'];

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Post> posts = [];
  bool likebuttonpressed = false;

  void _exit() async {
    try {
      await widget.auth.logOut();
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }


  /*void likeOrDislikePost(Post post, bool buttonlikepressed){
    setState(() {
      buttonlikepressed==true ? post.like=post.like+1 : post.like=post.like-1;
      if(post.like<0){
        post.like=0;
      }
      buttonlikepressed ==true ?  buttonlikepressed ==false: null;
    });

    blogservice().updateData(post.id, post);

  }*/

  @override
  void initState() {
    super.initState();

    blogservice().getAllData().then((list) {
      for (var post in list) {
        setState(() {

          posts.add(post);
        });
      }
    }).catchError((onError){
    _scaffoldKey.currentState.showSnackBar( SnackBar(
    content: Text("Error, check internet"),
    action: SnackBarAction(
    label: 'Undo',
    onPressed: () {
    // Some code to undo the change.
    },
    ),
    ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _scaffoldKey,
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
          return PostListItem(posts: posts, index: index,);
        }, childCount: posts.length));
  }
}
