import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'Hashrag.dart';
import 'MainPage.dart';
import 'RoutingPage.dart';
import 'SizeConfig.dart';
import "Authentification.dart";
import 'api/blogservice.dart';
import 'Post.dart';
import 'package:progress_dialog/progress_dialog.dart';
class PostImage extends StatefulWidget {
  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  ProgressDialog progressDialog;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  List<Hashtag> getHashtags(String text,String id){
    List<String> words=text.split(" ");
    List<Hashtag> hashtags=[];
    for (var word in words){
      if(word.startsWith("#")){
        hashtags.add(new Hashtag(postId: id,name: word));
      }
    }
    return hashtags;
  }
  void uploadImage() async {
    if (validateAndShare()) {
      progressDialog.show();
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
      Post post=new Post(body: _mystory,image: url.toString(),accaunt: name,time: time,date: date,like: 0);
      List<Hashtag> hashtags=getHashtags(_mystory,post.body);
      hashtags.length> 0 ? blogservice().addHashtag(hashtags):null;
if (await blogservice().addData(post)){

  Navigator.push(context, MaterialPageRoute(builder: (context){
    return RoutingPage(auth: new Auth(),);
  }));
} else {
  _scaffoldKey.currentState.showSnackBar( SnackBar(
    content: Text("Error, check internet"),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  ));
}

    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog=ProgressDialog(context);
    progressDialog.style(message: "Plaese wait");
    print("${MediaQuery.of(context).size.width}  ${MediaQuery.of(context).size.height} ${MediaQuery.of(context).size}");
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
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
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 5.0),
                  child: TextFormField(
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


                    // Find the Scaffold in the widget tree and use
                    // it to show a SnackBar.
                  },
                )
              ],
            )),
      ),
    );
  }
}
