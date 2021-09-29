import 'dart:convert';

import 'package:ecommerce_products_manager/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachcartItems {
  static final CachcartItems _singleton = CachcartItems._internal();
  factory CachcartItems() {
    return _singleton;
  }
  CachcartItems._internal();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, Product> tmp = Map<String, Product>();

  Future<Map<String, Product>> getCartItems() async {
    final SharedPreferences pref = await _prefs;
    var keys = pref.getKeys().toList();

    keys.forEach((element) {
      if (element.contains('cart')) {
        tmp[element] =
            new Product.fromJson(jsonDecode(pref.getString(element)));
      }
    });
    return tmp;
  }

  Future<bool> checkIfCachedInCartItem(Product product) async {
    final SharedPreferences pref = await _prefs;
    bool result = pref.containsKey('cart' + product.productId);
    if (result) {
      return true;
    } else
      return false;
  }

  void addProductToCart(Product product) async {
    final SharedPreferences prefs = await _prefs;
    final result = prefs.get('cart' + product.productId);

    if (result != null) {
      //if the product already exist in the cart we ++ the quantity
      Product tmp = new Product.fromJson(jsonDecode(result));
      tmp.quantity = tmp.quantity + 1;
      await prefs.setString('cart' + tmp.productId, jsonEncode(tmp));
    } else {
      await prefs.setString('cart' + product.productId, jsonEncode(product));
    }
  }

  void deleteItemFromCart(Product product) async {
    final SharedPreferences pref = await _prefs;
    pref.remove('cart' + product.productId);
  }

  Future<void> clearCart() async {
    final SharedPreferences prefs = await _prefs;
    var keys = prefs.getKeys().toList();
    keys.forEach((element) {
      if (element.contains('cart')) {
        prefs.remove(element);
      }
    });
  }

  Future<double> getTotalPrice() async {
    var cartItems = await getCartItems();
    var products = cartItems.values;
    var totalPrice = 0.0;
    products.forEach((element) {
      totalPrice = totalPrice +
          (element.price - (element.price * element.promo)) * element.quantity;
    });

    return totalPrice;
  }
}
