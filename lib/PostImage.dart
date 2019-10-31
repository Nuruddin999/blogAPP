import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'SizeConfig.dart';

class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  File sampleImage;
  final formkey = new GlobalKey<FormState>();
  String _mystory;
  String imageUrl;

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
  void uploadImage() async {
    if (validateAndShare()){
    var date=new DateTime.now();
    final StorageReference=FirebaseStorage.instance.ref().child("Blog Images");
    final uploadTask=StorageReference.child("${date.toString()}.jpg").putFile(sampleImage);
    var url=await (await uploadTask.onComplete).ref.getDownloadURL().then((value)=>{

    });
    imageUrl=url.toString();
    print("Image url: $url");
  }}

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
        child: Icon(Icons.add_a_photo,
        color: Colors.pink[700],),
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
                 Image.file(
                    sampleImage,
                    height:MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width

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
                  color: Colors.pink[700],
                  child: Text("Share your story !"),
                  textColor: Colors.white,
                  onPressed: (){
                    uploadImage();
                  },
                )
              ],
            )),
      ),
    );
  }
}