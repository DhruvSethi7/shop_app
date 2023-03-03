import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Provider/orders.dart' as provider;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  // const OrderItem({Key key}) : super(key: key);
  final provider.OrderItem item;
  OrderItem(this.item);
  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expand=false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          ListTile(
            leading: Text('\$'+widget.item.total.toString()),
            title:
                Text(DateFormat('dd MM yyyy hh:mm').format(widget.item.time)),
           trailing: IconButton(icon: expand?Icon(Icons.expand_less):Icon(Icons.expand_more),onPressed:(){
            setState(() {
              expand=!expand;
            });
           } ,),     
          ),
          if(expand)
          Container(
            height: 50,
            width: double.infinity,
            child:ListView(
              children:widget.item.products.map((product){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(product.title),
                    Text(product.quantity.toString() +'*'+product.price.toString())
                  ],
                );
              }).toList(),
            ) ,
          )
        ],
      ),
    );
  }
}
