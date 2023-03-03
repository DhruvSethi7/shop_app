import 'package:flutter/material.dart';
import '../Provider/cart.dart';
class CartList extends StatelessWidget {
  const CartList({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: cart.cartquantity,
        itemBuilder: ((context, index) {
          return Container(
            height: 100,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80,
                    margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                    padding: EdgeInsets.all(2),
                    child: Image.network(
                      cart.items.values.toList()[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text('${cart.items.values.toList()[index].title}',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(
                          height: 5,
                        ),
                        Text('\$${cart.items.values.toList()[index].price}')
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          cart.deleteitem(cart.items.keys.toList()[index]);
                        }, icon: Icon(Icons.delete)),
                        VerticalDivider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Column(
                        children: [
                          IconButton(onPressed:(){
                            cart.increasequantity(cart.items.keys.toList()[index]);
                          }, icon:Icon(Icons.add_rounded)),
                          Text('${cart.items.values.toList()[index].quantity}'),
                          IconButton(onPressed: (){
                             cart.decreasequantity(cart.items.keys.toList()[index]);
                          }, icon:Icon(Icons.remove))
                        ],
                      ),
                    )          
                      ],
                    ),
                  )
            
                ],
              ),
            ),
          );
        }));
  }
}
