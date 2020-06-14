class User{
  final String id;
  final String name;
  final String email;
  final String authToken;
  List items = [];

  User({this.id,this.name,this.email,this.items, this.authToken});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id : json["user"]["_id"],
      name : json["user"]["name"],
      email : json["user"]["email"],
      items : json["user"]["mycart"],
      authToken: json["token"],
    );
  }
}