import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:firebase_storage/firebase_storage.dart";
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  File sampleImage;
  final formkey = new GlobalKey<FormState>();
  String _mystory;

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }
  bool validateAndShare(){
    final form=formkey.currentState;

    if (form.validate()){
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget beginUploadImage() {
    return Container(
      child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              Image.file(
                sampleImage,
                height: 1000.0,
                width: 1000.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "So whats happened  ?)"),
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
                child: Text("Share your story !"),
                textColor: Colors.cyan[700],
                onPressed: (){
                  validateAndShare();
                },
              )
            ],
          )),
    );
  }
}
