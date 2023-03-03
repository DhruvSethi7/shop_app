import 'package:flutter/material.dart';
import '../screens/orderscreen.dart';
import '../screens/manage_product.dart';
import '../Provider/auth.dart';
import 'package:provider/provider.dart';
class appDrawer extends StatelessWidget {
  const appDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          Container(
            color: Colors.purple,
            height: 150,
            width: double.infinity,
            child: Text('Namaste',style: TextStyle(fontSize: 40),),
            alignment: Alignment.center,
          ),
         Divider(), 
         ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          leading: Icon(Icons.shop),
          title: Text('Shop',style: TextStyle(fontWeight: FontWeight.bold),),
         ),
         Divider(), 
         ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          },
          leading: Icon(Icons.payment),
          title: Text('Orders',style: TextStyle(fontWeight: FontWeight.bold),),
         ),
         Divider(), 
         ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(ManageProduct.routeName);
          },
          leading: Icon(Icons.edit),
          title: Text('Manage Products',style: TextStyle(fontWeight: FontWeight.bold),),
         ),
          Divider(), 
         ListTile(
          onTap: () {
            Navigator.of(context).pop();
            Provider.of<Auth>(context,listen: false).logout();
          },
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout',style: TextStyle(fontWeight: FontWeight.bold),),
         )
        ],
      ),
    );
  }
}
