import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'LoginPage.dart';
import 'MainPage.dart';
import 'Post.dart';
import 'api/blogservice.dart';


void main() => runApp(MaterialApp(title: "Draft",
  theme: new ThemeData.dark(),
  home: MainPage(),
));
