import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DialogBox.dart';
import 'User.dart';

abstract class Authentification {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<String> getStatus();

  Future<void> logOut();
}

class Auth implements Authentification {
  final String userurl = "http://10.0.2.2:3000/users";

  bool checkResponseResult(Response response) {
    if (response.statusCode < 200 ||
        response.statusCode > 400 ||
        json == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> signIn(String email, String password) async {
    String result;
    List<User> list = [];
    Response response = await get(userurl);
    if (checkResponseResult(response)) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        User user = User(
            email: item['email'],
            password: item['password'],
            id: item['id'].toString());
        list.add(user);
        for (var user in list) {
          if (email == user.email && password == user.password) {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setString(
                "currentuser", email);
            result = await getStatus();
          }
        }
      }
    } else {
      print("Error: ${response.statusCode}");
    }
    print("Current user after sign in: $result");
    return result;
  }

  Future<String> signUp(String email, String password) async {
    String result;
    //Check if user allready exists:
    List<User> list = [];
    bool isexists = false;
    Response response = await get(userurl);
    if (checkResponseResult(response)) {
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
      if (checkResponseResult(response)) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("currentuser", email);
        result = sharedPreferences.get("currentuser");
      } else {
        print("Error: ${response.statusCode}");
      }
    }
    print("current user after sign up: $result");
    return result;
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("currentuser").then((result) => print(result));
  }

  Future<String> getStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String status = sharedPreferences.getString("currentuser");
    return status;
  }
}
//
