import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'MainPage.dart';
import 'SizeConfig.dart';
import "Authentification.dart";
import 'api/blogservice.dart';
import 'Post.dart';
class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  File sampleImage;
  final formkey = new GlobalKey<FormState>();
  String _mystory;
  String imageUrl;
  Auth auth = new Auth();

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndShare() {
    final form = formkey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadImage() async {
    if (validateAndShare()) {
      var datekey=new DateTime.now();
      final StorageReference =
          FirebaseStorage.instance.ref().child("Blog Images");
      final uploadTask =
          StorageReference.child("${datekey.toString()}.jpg").putFile(sampleImage);
      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      String name = await auth.getStatus();
      print(url.toString());
      var dateformat=new DateFormat("MMM d,yyy");
      var timeformat=new DateFormat("EEE , hh:mm aaa");
      String date=dateformat.format(datekey);
      String time=timeformat.format(datekey);
if (await blogservice().addData(new Post(image: url.toString(),body: _mystory,accaunt: name,time: time,date: date))){
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return MainPage();
  }));
}
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Paint your history"),
        centerTitle: true,
      ),
      body: Center(
          child: sampleImage == null
              ? Text("Select your image")
              : beginUploadImage()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        tooltip: "Add image",
        child: Icon(
          Icons.add_a_photo,
          color: Colors.pink[700],
        ),
      ),
    );
  }

  Widget beginUploadImage() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                Image.file(sampleImage,
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(
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
                  child: Text("Share your story !"),
                  textColor: Colors.white,
                  onPressed: () {
                    uploadImage();
                  },
                )
              ],
            )),
      ),
    );
  }
}
