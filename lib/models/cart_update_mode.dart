class CartUpdateModel {
  bool? status;
  String? message;

  CartUpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
