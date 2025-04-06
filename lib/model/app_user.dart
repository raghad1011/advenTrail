
class AppUser {
  // String? id;
  String? userName;
  String? email; // email

  AppUser({
    // this.id,
    this.userName,
    this.email,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    userName = json['userName'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id']=id;
    data['userName'] = userName;
    data['email'] = email;
    return data;
  }
}
