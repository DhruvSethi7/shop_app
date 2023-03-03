import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:provider/provider.dart';
import '../Provider/products.dart';
class EditProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  EditProductItem(this.id,this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
   final Scaffoldobj=ScaffoldMessenger.of(context);//ham context ko save kr rhe h kyki future function h toh shyad baad m future change hojyga mtlb context change hojyga
  final productsobject=Provider.of<Products>(context,listen: false);
   return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName,arguments:id);
                  },
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  onPressed: () async {
                    try{
                    await productsobject.removeProduct(id);
                    }
                    catch(_){
                      Scaffoldobj.removeCurrentSnackBar();
                      Scaffoldobj.showSnackBar(SnackBar(content: Text('Failed to delete Product')));
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                )
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
