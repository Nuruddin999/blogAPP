import 'dart:convert';

import 'package:http/http.dart';

import '../Post.dart';
import '../User.dart';

class blogservice {
  String url = "http://10.0.2.2:3000/blogs";
  String userurl = "http://10.0.2.2:3000/users";

  Future<List<Post>> getAllData() async {
    List<Post> list = [];
    Response response = await get(url);
    var data = jsonDecode(response.body);
    for (var item in data) {
      Post post = Post(
          accaunt: item['accaunt'],
          body: item['body'],
          image: item['image'],
          id: item['id'].toString(),
      time: item['time'],
      date: item['date']);
      list.add(post);
    }
    for (var post in list) {
      print(post.toString());
    }

    return list;
  }

  Future<Post> getData(String number) async {
    Response response = await get("$url/$number");

    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      throw new Exception("Error whil creating post");
    } else {
      var post = jsonDecode(response.body);
      print(Post.fromJson(post));
      return Post.fromJson(post);
    }
  }

  Future<bool> deleteData(String number) async {
    Response response = await delete("$url/$number");
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      return false;
      throw new Exception("Error whil creating post");
    } else {
      return true;
      print("Post deleted");
    }
  }

  Future<bool> addData(Post p) async {
    Response response = await post(url, body: p.toMap());
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      return false;
      throw new Exception("Error whil creating post");
    } else {
      return true;
      print("Post created");
    }
  }

  Future<bool> updateData(String number, Post post) async {
    Response response = await put("$url/$number", body: post.toMap());
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      return false;
      throw new Exception("Error whil creating post");
    } else {
      return true;
      print("Post updated");
    }
  }

  Future<void> createUser(User u) async {
    //Check if user allready exists:
    List<User> list = [];
    bool isexists=false;
   Response response = await get(userurl);
    var data = jsonDecode(response.body);
    for (var item in data) {
      User user = User(
        email: item['email'],
      );
      list.add(user);
    }
    for (var user in list) {
      if (u.email == user.email) {
        print("This user allready exists");
        isexists=true;
     break;
      }
  }
    if(isexists==false){
      response = await post(userurl, body: u.toMap());
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        throw new Exception("Error whil creating post");
      } else {
        print(response.body);
      }
    }
}
}
