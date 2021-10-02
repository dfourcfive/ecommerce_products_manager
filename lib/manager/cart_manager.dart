import 'dart:convert';

import 'package:ecommerce_products_manager/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartManager {
  static final CartManager _singleton = CartManager._internal();
  factory CartManager() {
    return _singleton;
  }
  CartManager._internal();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Map<String, Product> tmp = Map<String, Product>();

  /**
   * get products from the cart
   */
  Future<List<Product>> getCartItems() async {
    final SharedPreferences pref = await _prefs;
    var keys = pref.getKeys().toList();

    keys.forEach((element) {
      if (element.contains('cart')) {
        tmp[element] =
            new Product.fromJson(jsonDecode(pref.getString(element)));
      }
    });
    var products = tmp.values;
    return products;
  }

  /**
   * Check if the product exist in the cart
   * return true if exist , false otherwise
   */
  Future<bool> exist(Product product) async {
    final SharedPreferences pref = await _prefs;
    bool result = pref.containsKey('cart' + product.productId);
    if (result) {
      return true;
    } else
      return false;
  }

  /**
   * Add product to the cart
   */
  Future<void> addProductToCart(Product product) async {
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

  /**
   * Remove a product from the cart
   * return true if removed successfully
   * return false otherwise
   */
  Future<bool> deleteItemFromCart(Product product) async {
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
   * remove all products from the cart
   */
  Future<void> clearCart() async {
    final SharedPreferences prefs = await _prefs;
    var keys = prefs.getKeys().toList();
    keys.forEach((element) {
      if (element.contains('cart')) {
        prefs.remove(element);
      }
    });
  }

  /**
   * Returns Total price of the products in the cart
   * 
   * this method calculate the total price of products 
   * accordingly to their quantites and promo
   */
  Future<double> getTotalPrice() async {
    var products = await getCartItems();
    var totalPrice = 0.0;
    products.forEach((element) {
      totalPrice = totalPrice +
          (element.price - (element.price * element.promo)) * element.quantity;
    });

    return totalPrice;
  }
}
