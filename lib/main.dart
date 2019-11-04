import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'Authentification.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'MainPage.dart';
import 'Post.dart';
import 'RoutingPage.dart';
import 'api/blogservice.dart';


void main() => runApp(MaterialApp(title: "Draft",
  theme: new ThemeData.light(),
  home: RoutingPage(auth: new Auth(), ),
));
