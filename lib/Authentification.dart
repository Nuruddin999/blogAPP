import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'User.dart';

abstract class Authentification {
  signIn(String email, String password);
  signUp(String email, String password);
}

class Auth implements Authentification {
  final String userurl = "http://10.0.2.2:3000/users";

  Future<String> signIn(String email, String password) async {
    List<User> list = [];
    Response response = await get(userurl);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      throw new Exception("Error whil creating post");
    } else {
      var data = jsonDecode(response.body);
      for (var item in data) {
        User user = User(
          email: item['email'],
        );
        list.add(user);
        for (var user in list) {
          if (email == user.email && password == user.password) {
            return email;
          }
        }
      }
    }
  }
  Future<String> signUp(String email, String password) async {
    //Check if user allready exists:
    List<User> list = [];
    bool isexists=false;
    Response response = await get(userurl);
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      throw new Exception("Error whil creating post");
    } else {
      var data = jsonDecode(response.body);
      for (var item in data) {
        User user = User(
          email: item['email'],
        );
        list.add(user);
      }
    }
    for (var user in list) {
      if (email == user.email) {
        print("This user allready exists");
        isexists=true;
        break;
      }
    }
    if(isexists==false){
      response = await post(userurl, body: new User(email: email,password: password).toMap());
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
