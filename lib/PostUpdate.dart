

import 'package:flutter/material.dart';

import 'Authentification.dart';
import 'MainPage.dart';
import 'Post.dart';
import 'RoutingPage.dart';
import 'api/blogservice.dart';

class PostUpdate extends StatefulWidget {
  PostUpdate({this.post});
  final Post post;
  @override
  _PostUpdateState createState() => _PostUpdateState();
}

class _PostUpdateState extends State<PostUpdate> {
  final formkey = new GlobalKey<FormState>();
  String _mystory;
  bool validateAndShare() {
    final form = formkey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
  void updatePost() async {
    if(validateAndShare()){widget.post.body=_mystory;
    print(widget.post.toString());
    if (await blogservice().updateData(widget.post.id, widget.post)){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return RoutingPage(auth: new Auth(),);
      }));
    }
    }

/* */
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text("Paint your history"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
               Image.network(widget.post.image,height: MediaQuery.of(context).size.width,width:  MediaQuery.of(context).size.width),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(initialValue: widget.post.body ,
                maxLines: 4,
                decoration:
                InputDecoration(labelText: "So whats happened  ?)"),
                validator: (value) {
                  return value.isEmpty ? "Please write you story )" : null;
                },
                onSaved: (value) {
                  _mystory = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                elevation: 10.0,
                color: Colors.pink[700],
                child: Text("Update your story !"),
                textColor: Colors.white,
                onPressed: () {
                  updatePost();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  }

