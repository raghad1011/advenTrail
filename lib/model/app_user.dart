
class AppUser {
  String? id;
  String? name;
  String? email;
  String? phone;



  AppUser({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']=id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
