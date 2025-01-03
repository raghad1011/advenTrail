class AppUser {
  String? userName;
  String? emal;

  AppUser({this.userName, this.emal});

  AppUser.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    emal = json['emal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['emal'] = this.emal;
    return data;
  }
}
