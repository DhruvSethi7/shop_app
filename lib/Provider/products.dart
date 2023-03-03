import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Models/httpdeleteerror.dart';
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String UserId;
  Products(this.authToken,this._items,this.UserId); 
  Future<void> removeProduct(String id) async{
    final url=Uri.parse('https://shop-app-816ac-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final response= await http.delete(url);//http.delete does not throw any error thats why hame custom error bnake throw krna haien
    if(response.statusCode>=400){
       throw HttpDeleteException('Delete karne mein dikkat hein');
    }
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavs {
    return [..._items.where((element) => element.isFavourite == true).toList()];
  }

  Product findbyId(id) {
    return _items.firstWhere((element) {
      return element.id == id;
    });
  }
  
  Future<void> fetchDataFromServer() async{
   var url=Uri.parse('https://shop-app-816ac-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
   final response= await http.get(url);
   url=Uri.parse('https://shop-app-816ac-default-rtdb.asia-southeast1.firebasedatabase.app/UserFavourites/$UserId.json?auth=$authToken');
   final responseData=jsonDecode(response.body) as Map<String,dynamic>;
    final responseUser=await http.get(url);
   final responseUserData=jsonDecode(responseUser.body);
   List<Product> loadedProducts=[];
   responseData.forEach((prodId,prodData)=>loadedProducts.add(Product(
      title:prodData['title'],
      description: prodData['description'],
      id: prodId,
      imageUrl: prodData['imageUrl'],
      price: prodData['price'],
      isFavourite:responseUserData!=null?responseUserData[prodId]??false:false//here 2 situation manle user ne kbhi favourite kra nahi ,user hi first time h
   )));
   _items=loadedProducts;
   notifyListeners();
  }
  Future<void> addProduct(Product product) async{
    final url=Uri.parse('https://shop-app-816ac-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try{
    final response=await http.post(url,body:jsonEncode({
    'imageUrl':product.imageUrl,
    'price':product.price,
    'description':product.description,
    'title':product.title,
     }));
     final newProduct = Product(
      id: jsonDecode(response.body)['name'],
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      title: product.title,
    );
    _items.add(newProduct);
    notifyListeners();
  }
  catch(error){throw error;}
  }
  void upDateProduct(Product product){
    final productId=product.id;
    final url=Uri.parse('https://shop-app-816ac-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json?auth=$authToken');
    http.patch(url,body:jsonEncode({
      'title':product.title,
      'price':product.price,
      'description':product.description,
       'imageUrl':product.imageUrl
    }));
    var index=_items.indexWhere((element) => element.id==product.id);
    _items[index]=product;
    notifyListeners();
  }
}
