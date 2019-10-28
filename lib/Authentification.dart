import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DialogBox.dart';
import 'User.dart';

abstract class Authentification {
  Future<String> signIn(String email, String password);
  Future<String>signUp(String email, String password);
  Future<String> getStatus();
  Future<void>logOut();
}

class Auth implements Authentification {
  final String userurl = "http://10.0.2.2:3000/users";
  Future<String> signIn(String email, String password) async {
    String result;
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
          password: item['password']
        );
        list.add(user);
        for (var user in list) {
          if (email == user.email && password == user.password) {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
          sharedPreferences.setString("status", "signedin");
          result= await getStatus();
          }
        }
      }
    }
    print(result);
    return result;
  }

  Future<String> signUp(String email, String password) async {
    String result="";
    //Check if user allready exists:
    List<User> list = [];
    bool isexists = false;
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
        isexists = true;
        break;
      }
    }
    if (isexists == false) {
      response = await post(userurl,
          body: new User(email: email, password: password).toMap());
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        throw new Exception("Error whil creating post");
      } else {
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
       sharedPreferences.setString("status", "signedin");
       result =await sharedPreferences.get("status");
      }
    } else {
     result=null;
    }
    print(result);
    return result;
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("status").then((result)=>print(result));
  }

  Future<String> getStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String status = sharedPreferences.getString("status");
    return status;
  }
}//
