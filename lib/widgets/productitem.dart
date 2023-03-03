import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/auth.dart';

import '../screens/product_detail.dart';
import '../Provider/product.dart';
import '../Provider/cart.dart';

class productItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetail.routeName, arguments: product.id);
      },
      child: GridTile(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
              icon: product.isFavourite
                  ? Icon(
                      Icons.favorite,
                      color: Colors.deepOrange,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: Colors.deepOrange,
                    ),
              onPressed: () {
                product.toggleFavourite(Provider.of<Auth>(context,listen: false).token,Provider.of<Auth>(context,listen: false).UserId);
              },
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addCart(
                    product.title, product.id, product.price, product.imageUrl);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();//
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added Product to cart'),
                    action: SnackBarAction(label: 'UNDO', onPressed: (){
                      cart.removeCart(product.id);
                    }),
                  ),
                );
              },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
