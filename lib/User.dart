class User {
  String email = null;
  String password = null;
  String id=null;

  User({this.email, this.password,this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email'], password: json['password'], id:json['id'].toString());
  }

  Map toMap() {
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}
