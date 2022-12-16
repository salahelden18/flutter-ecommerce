import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app_api_course_abdallah_mansour_design/components/exception.dart';
import '../models/shop_login_model.dart';
import '../components/constants.dart';

class ShopLoginProvider extends ChangeNotifier {
  bool isLoading = false;
  ShopLoginModel? loginAndRegisterModel;

  Future<ShopLoginModel> userLoginOrRegister(
      {required String email,
      required String password,
      String? phone,
      String? name,
      required String endPoint}) async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await http.post(Uri.parse('$baseUrl$endPoint'),
          body: json.encode({
            'email': email,
            'password': password,
            'phone': phone,
            'name': name,
          }),
          headers: {
            'Content-Type': 'application/json',
            'lang': 'en',
          });

      loginAndRegisterModel =
          ShopLoginModel.fromjson(json.decode(response.body));
      isLoading = false;
      notifyListeners();
      return loginAndRegisterModel!;
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print(error);
      throw HttpException('Something Went wrong');
    }
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    notifyListeners();
  }
}
