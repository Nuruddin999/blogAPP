import 'package:flutter/material.dart';

import 'Authentification.dart';
import 'DialogBox.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final Authentification auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DialogBox dialog = new DialogBox();
  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String uid = await widget.auth.signIn(_email, _password);
          print("Logged in   $uid");
          if (uid.isNotEmpty) {
            widget.onSignedIn();
          }
        } else {
          String uid = await widget.auth.signUp(_email, _password);
          print("Registered in   $uid");
          if (uid.isNotEmpty) {
            _scaffoldKey.currentState.showSnackBar( SnackBar(
              content: Text("Success! "),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            ));

            widget.onSignedIn();
          }
        }
      } catch (e, stack) {
        print(stack);
        _scaffoldKey.currentState.showSnackBar( SnackBar(
          content: Text("Error, check internet or login and password"),
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

  gotToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  gotToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Start your journey")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: createInputFields() + createButonss())),
        ),
      ),
    );
  }

  List<Widget> createInputFields() {
    return [
      SizedBox(height: 10.0),
      logo(),
      SizedBox(height: 10.0),
      TextFormField(
        decoration: InputDecoration(labelText: "name"),
        validator: (value) {
          return value.isEmpty ? 'Name is  required' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(height: 10.0),
      TextFormField(
          decoration: InputDecoration(labelText: "password"),
          obscureText: true,
          validator: (value) {
            return value.isEmpty ? 'Password is required' : null;
          },
          onSaved: (value) {
            return _password = value;
          })
    ];
  }

  List<Widget> createButonss() {
    if (_formType == FormType.login) {
      return [
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text("Login", style: TextStyle(fontSize: 20.0)),
          color: Colors.purple[700],
          textColor: Colors.white,
          onPressed: () {
            submit();
          },
        ),
        FlatButton(
          child: Text("New to us ? Create Accaunt",
              style: TextStyle(fontSize: 20.0)),
          textColor: Colors.grey[400],
          onPressed: () {
            gotToRegister();
          },
        )
      ];
    } else {
      return [
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text("Create accaunt", style: TextStyle(fontSize: 20.0)),
          color: Colors.purple[700],
          textColor: Colors.white,
          onPressed: () {
            submit();
          },
        ),
        FlatButton(
          child: Text("Allready with us ? Login",
              style: TextStyle(fontSize: 20.0)),
          textColor: Colors.grey[400],
          onPressed: () {
            gotToLogin();
          },
        )
      ];
    }
  }

  Widget logo() {
    return Hero(
        tag: "Author",
        child: CircleAvatar(
            radius: MediaQuery.of(context).size.width / 4,
            backgroundColor: Colors.transparent,
            child: Image.asset("assets/pencil.png")));
  }
}
