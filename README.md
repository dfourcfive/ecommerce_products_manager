# ecommerce_products_manager

ecommerce_products_manager is a dart/flutter package for managin and caching products for the purpose
of dealing with carts and wishlists

link to pub.dev:
https://pub.dev/packages/ecommerce_products_manager

## Installation

Run this command:
With Flutter:

```bash
 $ flutter pub add ecommerce_products_manager
```
This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):

```bash
dependencies:
  ecommerce_products_manager: 0.0.1
```
Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Import it
Now in your Dart code, you can use:
```bash
import 'package:ecommerce_products_manager/manager/cart_manager';
import 'package:ecommerce_products_manager/manager/wishlist_manager';
import 'package:ecommerce_products_manager/models/product';
```


## Usage Example 

```dart
    //
    Product yourProduct=new Product(productId:'1234',name:'example',description:'',price:10.0,promo:0.0,quantity:5);
    //
    CartManager cartManager= CartManager();
    //retrieve products from the cart
    List<Product> products=await cartManager.getCartItems();
    //check if a product exist
    bool exist=await cartManager.exist(yourProduct);
    //add a product to the cart
    await cartManager.addProductToCart(yourProduct);
    //prints true if the product removed succesfully ,prints false otherwise
    var result = await cartManager.deleteItemFromCart();
    print(result);
    //get total price of the cart
    var price = await cartManager.getTotalPrice();
    //removes all items from the cart
    await cartManager.clear();
  
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.



## License
[MIT](https://choosealicense.com/licenses/mit/)
