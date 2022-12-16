import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app_api_course_abdallah_mansour_design/components/constants.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/components/exception.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/helpers/cache_helper.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/models/cart_change_model.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/models/cart_model.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/models/cart_update_mode.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/models/categories_model.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/models/change_favorites_model.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/models/favorite_model.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/models/shop_login_model.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/screens/settings_screen.dart';
import '../models/home_model.dart';
import '../screens/categories_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/products_screen.dart';

class ShopLayoutProvider extends ChangeNotifier {
  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoriteScreen(),
    const SettingsScreen()
  ];

  void changeBottom(int index) {
    currentIndex = index;
    notifyListeners();
  }

  bool isLoading = false;

  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  Map<int, bool> inCart = {};

  Future<void> getHomeData() async {
    isLoading = true;
    notifyListeners();

    try {
      final resposne = await http.get(Uri.parse('${baseUrl}home'), headers: {
        'Content-Type': 'application/json',
        'lang': 'en',
        "Authorization": CacheHelper.getData(key: 'token') ?? '',
      });

      homeModel = HomeModel.fromJson(json.decode(resposne.body));

      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id!: element.inFavorite!,
        });
        inCart.addAll({
          element.id!: element.inCart!,
        });
      });

      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print(error.toString());
    }
  }

  CategoriesModel? categoriesModel;

  Future<void> getCategories() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}categories'), headers: {
        'Content-Type': 'application/json',
        'lang': 'en',
      });

      categoriesModel = CategoriesModel.fromJson(json.decode(response.body));
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  ChangeFavoriteModel? changeFavoriteModel;

  Future<ChangeFavoriteModel> changeFavorite(int productId) async {
    try {
      favorites[productId] = !favorites[productId]!;
      notifyListeners();
      final response = await http.post(Uri.parse('${baseUrl}favorites'),
          body: json.encode({
            'product_id': productId,
          }),
          headers: {
            'Content-Type': 'application/json',
            'lang': 'en',
            'Authorization': CacheHelper.getData(key: 'token')
          });

      changeFavoriteModel =
          ChangeFavoriteModel.fromJson(json.decode(response.body));

      if (!changeFavoriteModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }

      notifyListeners();

      return changeFavoriteModel!;
    } catch (e) {
      print(e.toString());
      favorites[productId] = !favorites[productId]!;
      notifyListeners();
      throw HttpException('Something went Wrong we are so sorry');
    }
  }

  FavoritesModel? favoritesModel;

  bool isFavoritesModelLoading = false;

  Future<void> getFavorites() async {
    isFavoritesModelLoading = true;
    notifyListeners();
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}favorites'), headers: {
        'Content-Type': 'application/json',
        'lang': 'en',
        'Authorization': CacheHelper.getData(key: 'token'),
      });

      favoritesModel = FavoritesModel.fromJson(json.decode(response.body));
      isFavoritesModelLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      isFavoritesModelLoading = false;
      notifyListeners();
      throw HttpException('Something went wrong we are so sorry');
    }
  }

  ShopLoginModel? userModel;
  bool isUserProfileModelLoading = false;

  Future<void> getUserData() async {
    isFavoritesModelLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('${baseUrl}profile'), headers: {
        'Content-Type': 'application/json',
        'lang': 'en',
        'Authorization': CacheHelper.getData(key: 'token'),
      });

      userModel = ShopLoginModel.fromjson(json.decode(response.body));
      isFavoritesModelLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      isFavoritesModelLoading = false;
      notifyListeners();
      throw HttpException('Something Went Wrong');
    }
  }

  ProductModel findById(int id) {
    return homeModel!.data!.products.firstWhere((element) => element.id == id);
  }

  CartModel? cartModel;
  bool isCartDataLoading = false;

  Future<void> getCart() async {
    isCartDataLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('${baseUrl}carts'), headers: {
        'Connection': 'keep-alive',
        'Content-Type': 'application/json',
        'lang': 'en',
        'Authorization': CacheHelper.getData(key: 'token'),
      });
      cartModel = CartModel.fromJson(json.decode(response.body));
      isCartDataLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      isCartDataLoading = false;
      notifyListeners();
    }
  }

  CartChangeModel? cartChangeModel;

  Future<CartChangeModel> changeCart(int productId) async {
    try {
      inCart[productId] = !inCart[productId]!;
      notifyListeners();
      final response = await http.post(Uri.parse('${baseUrl}carts'),
          body: json.encode({
            'product_id': productId,
          }),
          headers: {
            'Content-Type': 'application/json',
            'lang': 'en',
            'Authorization': CacheHelper.getData(key: 'token')
          });

      cartChangeModel = CartChangeModel.fromJson(json.decode(response.body));

      if (!cartChangeModel!.status!) {
        inCart[productId] = !inCart[productId]!;
      } else {
        getCart();
      }

      notifyListeners();

      return cartChangeModel!;
    } catch (e) {
      print(e);
      inCart[productId] = !inCart[productId]!;
      notifyListeners();
      throw HttpException('Something went Wrong we are so sorry');
    }
  }

  CartUpdateModel? cartUpdateModel;

  Future<CartUpdateModel> updateCart(int cartId, int quantity) async {
    try {
      final response = await http.put(Uri.parse('${baseUrl}carts/$cartId'),
          body: json.encode({
            "quantity": quantity,
          }),
          headers: {
            'Content-Type': 'application/json',
            'lang': 'en',
            'Authorization': CacheHelper.getData(key: 'token')
          });
      cartUpdateModel = CartUpdateModel.fromJson(json.decode(response.body));

      if (cartUpdateModel!.status!) {
        getCart();
      }

      notifyListeners();
      return cartUpdateModel!;
    } catch (e) {
      print(e);
      throw HttpException('Something Went Wrong');
    }
  }
}
