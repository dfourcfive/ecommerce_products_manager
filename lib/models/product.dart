import 'dart:convert';

class Product {
  String barCode;
  String productId;
  String category;
  String description;
  String name;
  double price = 0;
  double promo = 0;
  int quantity = 0;
  String image;
  //for additional parametres and their values use this
  Map<String, dynamic> extra = {};
  Product(
      {this.barCode,
      this.productId,
      this.category,
      this.description,
      this.name,
      this.price,
      this.promo,
      this.quantity,
      this.image,
      this.extra});

  Product.fromJson(Map<String, dynamic> json)
      : this.barCode = json['barCode'],
        this.category = json['category'],
        this.productId = json['productId'],
        this.description = json['description'],
        this.name = json['name'],
        this.price = json['price'],
        this.promo = json['promo'],
        this.quantity = json['quantity'],
        this.image = json['image'],
        this.extra = jsonDecode(json['extra']);

  Map<String, dynamic> toJson() => {
        'barCode': barCode,
        'productId': productId,
        'category': category,
        'description': description,
        'name': name,
        'promo': promo,
        'price': price,
        'quantity': quantity,
        'image': image ?? '',
        'extra': JsonEncoder().convert(extra)
      };
}
