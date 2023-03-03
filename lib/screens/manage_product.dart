import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Provider/products.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/widgets/appDrawer.dart';
import 'package:shop_app/widgets/editProductItem.dart';
class ManageProduct extends StatefulWidget {
  static const routeName='/manageproduct';
  const ManageProduct({Key key}) : super(key: key);

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  Future<void> _onRefresh() async{
    await Provider.of<Products>(context,listen: false).fetchDataFromServer();
  }
  @override
  Widget build(BuildContext context) {
    final product=Provider.of<Products>(context);
    return Scaffold(
      appBar:AppBar(title:const Text('Manage Product'),actions: [
        IconButton(onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        }, icon:Icon(Icons.add))
      ],),
      drawer: const appDrawer(),
      body: Padding(padding: EdgeInsets.all(15),
      child:RefreshIndicator(
        onRefresh:_onRefresh,
        child: ListView.builder(itemCount:product.items.length ,itemBuilder: (ctx,i){
          return EditProductItem(product.items[i].id,product.items[i].title, product.items[i].imageUrl);
        }),
      ),),
    );
  }
}