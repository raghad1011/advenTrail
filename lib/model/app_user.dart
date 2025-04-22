
class AppUser {
  String? id;
  String? name;
  String? email;

  AppUser({
    this.id,
    this.name,
    this.email,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']=id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
