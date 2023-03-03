import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/products.dart';

import './productitem.dart';
import '../Provider/products.dart';
import '../Provider/cart.dart' show Cart;
class ProductsGrid extends StatelessWidget {
  final bool showfav;
  ProductsGrid(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);//Provider.of<Products>(context) this is providing an object of the provider
    final products=showfav==true?productsData.showFavs:productsData.items;
    return  GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: products.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(//here we are making nested provider (Product).
            value:products[i] ,//product[i]=product 
            child:productItem(),//every productitem has its provider class
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 20,
          )
    );
  }
}
