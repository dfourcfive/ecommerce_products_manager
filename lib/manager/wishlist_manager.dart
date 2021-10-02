import 'dart:convert';

import 'package:ecommerce_products_manager/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishListManager {
  static final WishListManager _singleton = WishListManager._internal();
  factory WishListManager() {
    return _singleton;
  }
  WishListManager._internal();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, Product> tmp = Map<String, Product>();

  /**
   * get products from the cart
   */
  Future<Map<String, Product>> getWishlistItems() async {
    final SharedPreferences pref = await _prefs;
    var keys = pref.getKeys().toList();

    keys.forEach((element) {
      if (element.contains('wishlist')) {
        tmp[element] =
            new Product.fromJson(jsonDecode(pref.getString(element)));
      }
    });
    return tmp;
  }

  /**
   * Check if the product exist in the wish list
   * return true if exist , false otherwise
   */
  Future<bool> exist(Product product) async {
    final SharedPreferences pref = await _prefs;
    bool result = pref.containsKey('wishlist' + product.productId);
    if (result) {
      return true;
    } else
      return false;
  }

  /**
   * Add product to the cart
   */
  void addProductToWishlist(Product product) async {
    final SharedPreferences prefs = await _prefs;
    final result = prefs.get('wishlist' + product.productId);

    if (result != null) {
      //if the product already exist in the wishlist we ++ the quantity
      Product tmp = new Product.fromJson(jsonDecode(result));
      tmp.quantity = tmp.quantity + 1;
      await prefs.setString('wishlist' + tmp.productId, jsonEncode(tmp));
    } else {
      await prefs.setString(
          'wishlist' + product.productId, jsonEncode(product));
    }
  }

  /**
   * Remove a product from the wish List
   * return true if removed succesfuly
   * return false otherwise
   */
  Future<bool> deleteItemFromWishlist(Product product) async {
    bool productExist = await exist(product);
    if (productExist) {
      final SharedPreferences pref = await _prefs;
      await pref.remove('cart' + product.productId);
      return true;
    } else {
      return false;
    }
  }

  /**
   * remove all products from the wish list
   */
  Future<void> clearWishlist() async {
    final SharedPreferences prefs = await _prefs;
    var keys = prefs.getKeys().toList();
    keys.forEach((element) {
      if (element.contains('wishlist')) {
        prefs.remove(element);
      }
    });
  }
}
