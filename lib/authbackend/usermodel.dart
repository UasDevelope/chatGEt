class UserModel {
  String? username;
  String? useremail;
  String? password;
  String? id;
  UserModel({this.useremail, this.username, this.id, this.password});
  factory UserModel.tojson(Map<String, dynamic> json) {
    return UserModel(
        id: json["id"],
        useremail: json["useremail"],
        username: json["username"],
        password: json["password"]);
  }
  Map<String, dynamic> fromjson() => {
        "username": username,
        "useremail": useremail,
        "id": id,
        "password": password,
      };
}
