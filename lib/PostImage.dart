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
  PostImage({this.post});
  final Post post;
  @override
  _PostImageState createState() => _PostImageState();
}
enum ChangeType { addnewpost, updatecurrentpost }
class _PostImageState extends State<PostImage> {
  ChangeType changeType;


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
Future<String> uploadImage() async{
    String url;
  if (validateAndShare()) {
    var datekey=new DateTime.now();
    final StorageReference = FirebaseStorage.instance.ref().child("Blog Images");
    final uploadTask =
    StorageReference.child("${datekey.toString()}.jpg").putFile(sampleImage);
    url =  (await uploadTask.onComplete).ref.getDownloadURL().toString();

} return url;
  }
  void addPost() async {
    var datekey=new DateTime.now();
  String url= await uploadImage();
      String name = await auth.getStatus();
      print(url.toString());
      var dateformat=new DateFormat("MMM d,yyy");
      var timeformat=new DateFormat("EEE , hh:mm aaa");
      String date=dateformat.format(datekey);
      String time=timeformat.format(datekey);

      blogservice().addData(new Post(image: url.toString(),body: _mystory,accaunt: name,time: time,date: date)).then((result){
        if(result){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return MainPage();
        }));}
      });
    }
  void updatePost() async {
    if(validateAndShare()){
      if(sampleImage!=null){
        var datekey=new DateTime.now();
        final StorageReference =
        FirebaseStorage.instance.ref().child("Blog Images");
        final uploadTask =
        StorageReference.child("${datekey.toString()}.jpg").putFile(sampleImage);
        var url = await (await uploadTask.onComplete).ref.getDownloadURL();
       widget.post.body=_mystory;
       widget.post.image=url.toString();
        blogservice().updateData(widget.post.id, widget.post);
      } else {
        widget.post.body=_mystory;
        blogservice().updateData(widget.post.id, widget.post);
      }
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      changeType = widget.post != null ? ChangeType.updatecurrentpost: ChangeType.addnewpost;
    });

  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Paint your history"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              changeType == ChangeType.addnewpost
                  ? makeStartAddPostWidget():makeUpdatePostWidget(),
            ],
          ),
        ),
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
                    addPost();
                  },
                )
              ],
            )),
      ),
    );
  }
  Widget makeStartAddPostWidget(){
    return Center(
        child:  sampleImage == null
            ? Text("Select your image")
            : beginUploadImage());
  }
  Widget makeUpdatePostWidget(){
    setState(() {
      _mystory=widget.post.body;
    });

    return Container(
        child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
               sampleImage == null? Image.network(widget.post.image): Image.file(sampleImage,
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width),
                SizedBox(
                  height: 15.0,
                ),
                TextFormField(initialValue: widget.post.body ,
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
            )),
    );
  }
}


