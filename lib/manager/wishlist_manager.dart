import 'dart:convert';

import 'package:ecommerce_products_manager/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachwishlistItems {
  static final CachwishlistItems _singleton = CachwishlistItems._internal();
  factory CachwishlistItems() {
    return _singleton;
  }
  CachwishlistItems._internal();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, Product> tmp = Map<String, Product>();

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

  Future<bool> checkIfCachedInWishlistItem(Product product) async {
    final SharedPreferences pref = await _prefs;
    bool result = pref.containsKey('wishlist' + product.productId);
    if (result) {
      return true;
    } else
      return false;
  }

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

  void deleteItemFromWishlist(Product product) async {
    final SharedPreferences pref = await _prefs;
    pref.remove('wishlist' + product.productId);
  }

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
