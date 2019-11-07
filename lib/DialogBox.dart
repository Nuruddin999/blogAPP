import 'package:flutter/material.dart';

class DialogBox {
  information(BuildContext context, String title, String description) {
    return  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog( backgroundColor: Colors.deepPurple,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(width: 14.0,),
                new Text("$title \n  $description",style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        );
      },
    );
  }
}
