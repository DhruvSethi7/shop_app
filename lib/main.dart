import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/auth.dart';
import 'package:shop_app/screens/splash.dart';
import './screens/auth.dart';

import 'package:shop_app/Provider/cart.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/screens/manage_product.dart';
import 'package:shop_app/screens/orderscreen.dart';
import './Provider/orders.dart';
import './Provider/products.dart';
import './screens/cart_screen.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (context, authData, previous) => Products(authData.token,
                previous == null ? [] : previous.items, authData.UserId),
          ),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, authData, previous) =>
                Orders(authData.token, previous == null ? [] : previous.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: ((context, value, child) => MaterialApp(
                //here value is auth provider object
                title: 'Shop App',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                ),
                home: value.isAuthenticated() == true
                    ? ProductOverviewScreen()
                    :AuthScreen(),
                routes: {
                  AuthScreen.routeName: (context) => AuthScreen(),
                  ProductDetail.routeName: ((_) => ProductDetail()),
                  CartScreen.routeName: ((context) => CartScreen()),
                  OrderScreen.routeName: ((context) => OrderScreen()),
                  ManageProduct.routeName: ((context) => ManageProduct()),
                  EditProductScreen.routeName: ((context) =>
                      EditProductScreen())
                },
              )),
        ));
  }
}
