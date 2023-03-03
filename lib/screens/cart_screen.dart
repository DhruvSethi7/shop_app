import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/screens/order_screen.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/screens/orderscreen.dart';
import '../Provider/cart.dart';
import '../Provider/orders.dart';
import '../widgets/cartList.dart';
class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isOrdering=false;
  @override
  Widget build(BuildContext context) {
    final order=Provider.of<Orders>(context,listen: false);
    final cart = Provider.of<Cart>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(cart.quantity!=0) Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              height: 300,
              width: double.infinity,
              child: CartList(cart: cart),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              height: 50,
              decoration: BoxDecoration(border:Border.all(color: Colors.black),borderRadius: BorderRadius.circular(5)),
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: 15,),
                  Text('Cart Subtotal',),
                  Spacer(),
                  Text('\$${cart.total().toStringAsFixed(2)}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  SizedBox(width: 15,)
                ],
              ),
            ),
            InkWell(
              // splashColor: Colors.deepPurple,
              onTap:cart.items.length>0?() async{
                setState(() {
                  isOrdering=true;});  
                await order.addOrder(cart.total().toString(),cart.items.values.toList());
                isOrdering=false;
                Navigator.of(context).pushNamed(OrderScreen.routeName);
                cart.clearcart();
              }:null,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                height: 50,
                decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(15)  
                ),
                
                alignment:Alignment.center,
                child:isOrdering?CircularProgressIndicator(color: Colors.white,):Text('Checkout',style: TextStyle(fontSize: 20,color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

