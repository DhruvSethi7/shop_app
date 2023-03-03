import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/product.dart';




import 'package:shop_app/Provider/products.dart';
class ProductDetail extends StatelessWidget {
  static const routeName='productDetail';

  @override
  Widget build(BuildContext context) {
    final String Productid=ModalRoute.of(context).settings.arguments;
    final productsobject=Provider.of<Products>(context);
    final loadeproduct=productsobject.items.where((element) => element.id==Productid).toList()[0];
    return Scaffold(
      appBar: AppBar(
        title: Text((productsobject.items)[0].title),
      ),
      body: Column(
        children: [
          Container(
          height: 400,
          width: double.infinity,
          child: Image.network(loadeproduct.imageUrl,fit: BoxFit.cover,),
        ),
        SizedBox(height:10),
        Text('\$${loadeproduct.price}'),
        ],
      ),
    );
  }
}
