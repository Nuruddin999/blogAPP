class Hashtag {
  String id;
  String postId;
  String name;

  Hashtag({this.id, this.postId, this.name});

  factory Hashtag.fromJson(Map<String, dynamic> json) {
    return Hashtag(
      id: json['id'],
      name: json['name'],
      postId: json['post id'],
    );
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map['name'] = name;
    map['post id'] = postId;
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
  @override
  String toString() {
    return "$name  $postId";
  }
}
