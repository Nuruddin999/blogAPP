import 'package:flutter/material.dart';
import 'Authentification.dart';
import 'LoginPage.dart';
import 'MainPage.dart';
class RoutingPage extends StatefulWidget {
  final Authentification auth;
  RoutingPage({this.auth});
  @override
  _RoutingPageState createState() => _RoutingPageState();
}

enum AuthStatus{
  signed, notsigned
}
class _RoutingPageState extends State<RoutingPage> {
  AuthStatus status=AuthStatus.notsigned;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
