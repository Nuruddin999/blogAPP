import 'dart:async';
import 'dart:convert';

class Post {
  String id;
  String accaunt;
  String image;
  String body;
  String date;
  String time;
  int like;


  Post({this.body, this.accaunt, this.image, this.id, this.date, this.time,this.like});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        body: json['body'],
        accaunt: json['accaunt'],
        image: json['image'],
        id: json['id'].toString(),
        time: json['time'],
        date: json['date'],
      like: json['like'],
   );
  }

  Post.fromJsonList(Map json)
      : id = json['id'].toString(),
        accaunt = json['accaunt'],
        body = json['body'],
        image = json['image'],
        time = json['time'],
        date = json['date'];

  Map toMap() {
    var map = Map<String, dynamic>();
    map['accaunt'] = accaunt;
    map['image'] = image;
    map['body'] = body;
    map['time']=time;
    map['date']=date;
    if (id != null) {
      map['id'] = id.toString();
    }
    map['like'] = like.toString();

    return map;
  }

  @override
  String toString() {
    return "$id  $accaunt $body $image $like";
  }
}
