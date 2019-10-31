import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentification.dart';
import 'LoginPage.dart';
import 'MainPage.dart';

class RoutingPage extends StatefulWidget {
  final Authentification auth;

  RoutingPage({this.auth});

  @override
  _RoutingPageState createState() => _RoutingPageState();
}

enum AuthStatus { signed, notsigned }

class _RoutingPageState extends State<RoutingPage> {
  AuthStatus status = AuthStatus.notsigned;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getStatus().then((receivedstatus) {
      setState(() {
        status =
            receivedstatus == null ? AuthStatus.notsigned : AuthStatus.signed;
      });
    });
  }

  void _signedIn() {
    setState(() {
      status = AuthStatus.signed;
    });
  }

  void _signedOut() {
    setState(() {
      status = AuthStatus.notsigned;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AuthStatus.notsigned:
        return new LoginPage(auth: widget.auth, onSignedIn: _signedIn);
      case AuthStatus.signed:
        return new MainPage(auth: widget.auth, onSignedOut: _signedOut);
    }
    return null;
  }
}
