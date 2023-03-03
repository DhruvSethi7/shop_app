import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/Provider/cart.dart';
import 'package:http/http.dart' as http;
class OrderItem {
  String id;
  String total;
  List<CartItem> products;
  DateTime time;
  OrderItem(this.id, this.products, this.time, this.total);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderList = [];
  final String authToken;
  Orders(this.authToken,this._orderList);
  List<OrderItem> get orders{
    return [..._orderList];
  }
  Future<void> getOrdersfromServer() async{
    final url=Uri.parse('https://shop-app-816ac-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken');
    final response=await http.get(url);
    final responseData=jsonDecode(response.body) as Map<String,dynamic>;
    if(responseData==null)return;
    List<OrderItem> loadedOrders=[];
    responseData.forEach((orderId,orderData){
      loadedOrders.add(OrderItem(orderId,
      (orderData['products'] as List<dynamic>).map((items) =>CartItem(
        id: items['id'],
        imageUrl: items['imageUrl'],
        price: items['price'],
        quantity: items['quantity'],
        title: items['title']
      )).toList()
    ,DateTime.parse(orderData['time']),
    orderData['total'],));
    }); 
    _orderList=loadedOrders;
    notifyListeners();
    }
  Future<void> addOrder(String total, List<CartItem> products) async{
    final time=DateTime.now();
    try{
      final url=Uri.parse('https://shop-app-816ac-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json?auth=$authToken');
    final response=await http.post(url,body:jsonEncode({
      'total':total,
      'time':time.toString(),
      'products':products.map((cartItem)=>{
        'id':time.toIso8601String(),
        'title':cartItem.title,
        'quantity':cartItem.quantity,
        'imageUrl':cartItem.imageUrl,
        'price':cartItem.price
      }).toList()
    }));
    _orderList.insert(
        0,
        OrderItem(
          jsonDecode(response.body)['Name'],
          products,
          time,
          total,
        ));
    notifyListeners();     
  }
  catch(error){
     throw error;
  }
}
}