
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
class DescriptionTextWidget extends StatefulWidget {
  final String text;

  DescriptionTextWidget({@required this.text});

  @override
  _DescriptionTextWidgetState createState() => new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;
List<TextSpan> gethashtags(List<String> words){
  List<TextSpan> child=[];
  for (var word in words){
    if (word.startsWith("#")){
      child.add(TextSpan(text: "$word ",style:TextStyle(color: Colors.cyan),recognizer: new TapGestureRecognizer()..onTap=()=>print(word)));
    }
    else{
      child.add(TextSpan(text: "$word ", style: TextStyle(color: Colors.black26)));
print(word);
    }
  }
  return child;
}
  @override
  void initState() {
    super.initState();

    if (widget.text.length > 50) {
      firstHalf = widget.text.substring(0, 50);
      secondHalf = widget.text.substring(50, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> words =firstHalf.split(" ");
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.isEmpty ? new RichText(text: TextSpan(children: gethashtags(words)))
          : new Column(
        children: <Widget>[
/*          new RichText(text: flag ? TextSpan(children: gethashtags(words),text: "..."): TextSpan(children: gethashtags(words + secondhalf)),maxLines: 5,),*/
        flag ? RichText(text: TextSpan(children: gethashtags(words)),) : RichText(text: TextSpan(children: gethashtags(words)+gethashtags(secondHalf.split(" "))),),
          new InkWell(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  flag ? "show more" : "show less",
                  style: new TextStyle(color: Colors.blue),
                  maxLines: 5,
                ),
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ],
      ),
    );
  }
}