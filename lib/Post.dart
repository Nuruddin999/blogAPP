import 'dart:async';
import 'dart:convert';

class Post {
  String id;
  String accaunt;
  String image;
  String title;
  String body;

  Post({this.body, this.accaunt, this.image, this.title, this.id});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        body: json['body'],
        accaunt: json['accaunt'],
        image: json['image'],
        id: json['id'].toString());
  }

  Post.fromJsonList(Map json)
      : id = json['id'],
        accaunt = json['accaunt'],
        title = json['title'],
        body = json['body'],
        image = json['image'];

  Map toMap() {
    var map = Map<String, dynamic>();
    map['accaunt'] = accaunt;
    map['image'] = image;
    map['body'] = body;
    return map;
  }

  @override
  String toString() {
    return "$id  $accaunt $body $image ";
  }
}
