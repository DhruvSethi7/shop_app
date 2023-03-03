import 'package:flutter/material.dart';

class CartItem with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;
  CartItem({
    this.imageUrl,
    this.id,
    this.price,
    this.quantity,
    this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartitems =
      {}; //here our map string keys refers to product id's of overview screen

  Map<String, CartItem> get items {
    return {..._cartitems};
  }

  int get cartquantity {
    return _cartitems.length;
  }

  int get quantity {
    int quantity = 0;
    _cartitems.forEach((key, value) {
      quantity += value.quantity;
    });
    return quantity;
  }

  void clearcart() {
    _cartitems = {};
    notifyListeners();
  }

  String itemimageUrl(key) {
    return _cartitems[key].imageUrl;
  }

  void addCart(String title, String productid, double price, String imageUrl) {
    if (_cartitems.containsKey(productid)) {
      _cartitems.update(
          productid,
          (existingitem) => CartItem(
              title: title,
              id: existingitem.id,
              price: price,
              imageUrl: existingitem.imageUrl,
              quantity: existingitem.quantity + 1));
    } else {
      _cartitems.putIfAbsent(
          productid,
          () => CartItem(
              title: title,
              price: price,
              id: DateTime.now().toString(),
              quantity: 1,
              imageUrl: imageUrl));
    }
    notifyListeners();
  }

  void deleteitem(String productId) {
    _cartitems.removeWhere((key, value) => key == productId);
    notifyListeners();
  }

  void increasequantity(String productId) {
    _cartitems.update(
        productId,
        (existingItem) => CartItem(
            imageUrl: existingItem.imageUrl,
            id: existingItem.id,
            price: existingItem.price,
            quantity: existingItem.quantity + 1,
            title: existingItem.title));
    notifyListeners();
  }

  void decreasequantity(String productId) {
    _cartitems.update(
        productId,
        (existingItem) => CartItem(
            imageUrl: existingItem.imageUrl,
            id: existingItem.id,
            price: existingItem.price,
            quantity: existingItem.quantity > 1
                ? existingItem.quantity - 1
                : existingItem.quantity,
            title: existingItem.title));
    notifyListeners();
  }

  void removeCart(String productId) {
    if (!_cartitems.containsKey(productId)) return;
    if (_cartitems[productId].quantity > 1) {
      _cartitems.update(
        productId,
        (existingitem) => CartItem(
          id: existingitem.id,
          imageUrl: existingitem.imageUrl,
          price: existingitem.price,
          quantity: existingitem.quantity - 1,
          title: existingitem.title,
        ),
      );
    }
    else{
      _cartitems.remove(productId);
    }
    notifyListeners();
  }

  double total() {
    double sum = 0.0;
    _cartitems.forEach((key, value) {
      sum += value.price * value.quantity;
    });
    return sum;
  }
}
