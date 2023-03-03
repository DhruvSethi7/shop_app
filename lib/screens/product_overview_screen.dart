import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/orderscreen.dart';

import '../screens/cart_screen.dart';
import '../Provider/cart.dart';
import '../widgets/appDrawer.dart';
import '../widgets/product_grid.dart';
import '../Provider/products.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = 'productoverviewscreen';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFav=false;  
  bool isInit=true;
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == 0) {
                  showFav = false;
                } else {
                  showFav = true;
                }
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('ALL PRODUCTS'),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text('FAVOURITES'),
                  value: 1,
                ),
              ];
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart))
        ],
      ),
      drawer:appDrawer(),
      body:FutureBuilder(
        future: Provider.of<Products>(context,listen: false).fetchDataFromServer(),
        builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child:CircularProgressIndicator(),);
        }
        else{
          if(snapshot.hasError){
                return Center(child: Text('An error occured'),);
          }
          else{
            return  ProductsGrid(showFav);
          }
        }
      }),
    );
  }
}

