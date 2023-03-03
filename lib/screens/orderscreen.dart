import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/appDrawer.dart';
import '../Provider/orders.dart';
import '../widgets/orderitem.dart' as widget;

class OrderScreen extends StatelessWidget {
  static const routeName='/orderscreen';
  @override
  Widget build(BuildContext context) {
    print('building orders');
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        drawer: appDrawer(),
        body: Container(
            height: 500,
            width: double.infinity,
            child: FutureBuilder(
                future: Provider.of<Orders>(context, listen: false)
                    .getOrdersfromServer(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasError) {
                     return Center(child: Text('An error Occured'),);
                    } 
                    else {
                      return Consumer<Orders>(
                        builder: ((context, orderobj, child) =>
                        ListView.builder(
                            itemCount: orderobj.orders.length,
                            itemBuilder: (context, index) {
                              return widget.OrderItem(orderobj.orders[index]);
                            }) ),
                      );
                    }
                  }
                })));
  }
}
