import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier{
  final double price;
  final String id;
  final String description;
  final String title;
  bool isFavourite;
  final String imageUrl;
  Product({
    @required this.title,
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    @required this.price,
    this.isFavourite=false
  });
  void toggleFavourite(String authToken,String userId)async{
    isFavourite=!isFavourite;
    final url=Uri.parse('https://shop-app-816ac-default-rtdb.asia-southeast1.firebasedatabase.app/UserFavourites/$userId/$id.json?auth=$authToken');
    await http.put(url,body: jsonEncode(isFavourite) );
    notifyListeners();
  }
}