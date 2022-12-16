class ShopLoginModel {
  late bool status;
  late String? message;
  late UserData? data;

  ShopLoginModel(this.status, this.message, this.data);

  ShopLoginModel.fromjson(Map<String, dynamic> json) {
    status = json['status'];
    message = json["message"];
    data = json['data'] != null ? UserData.fromJson(json["data"]) : null;
  }
}

class UserData {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String image;
  late int? points;
  late int? credits;
  late String token;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    this.points,
    this.credits,
    required this.token,
  });

  //named constructor

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    points = json['points'];
    credits = json['credits'];
    token = json['token'];
  }
}
