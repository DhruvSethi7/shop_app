import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import '../Provider/product.dart';
import '../Provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'editproduct';
  // const EditProduct({Key key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _Imagecontoller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var editproduct = Product(
      id: null,
      description: '',
      imageUrl: '',
      price: 0.0,
      title: '',
      isFavourite:false);
  bool isLoading = false;

  Future<void> formsubmit() async {
    bool allgood = _formkey.currentState.validate();
    if (allgood == false) return;
    _formkey.currentState.save();
    setState(() {
      isLoading = true;
    });
    if (editproduct.id != null) {
      Provider.of<Products>(context, listen: false).upDateProduct(editproduct);
      Navigator.of(context).pop();
    } 
    else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editproduct);
      } 
      catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('An error occured'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'))
                ],
              );
            });
      }
      finally {
        isLoading = false;
        Navigator.of(context).pop();
      }
    }
    ;
  }

  bool edit = false;
  bool init = true;
  var initvalues = {
    'title': '',
    'price': '',
    'imageUrl': '',
    'description': ''
  };
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (init) {
      String productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        edit = true;
        editproduct =
            Provider.of<Products>(context, listen: false).findbyId(productId);
        initvalues['title'] = editproduct.title;
        initvalues['price'] = editproduct.price.toString();
        initvalues['description'] = editproduct.description;
        // initvalues['imageUrl']=editproduct.imageUrl;
        _Imagecontoller.text = editproduct.imageUrl;
      }
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: edit ? Text('Edit Product') : Text('Add Product'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: initvalues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          //_formkey.currentstate. is used
                          if (value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          //this is called when formsubmit is called _formkey.currentstate.save is used
                          editproduct = Product(
                              title: value,
                              description: editproduct.description,
                              id: editproduct.id,
                              imageUrl: editproduct.imageUrl,
                              price: editproduct.price,
                              isFavourite: editproduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: initvalues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter value';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter valid value';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editproduct = Product(
                              title: editproduct.title,
                              description: editproduct.description,
                              id: editproduct.id,
                              imageUrl: editproduct.imageUrl,
                              price: double.parse(value),
                              isFavourite: editproduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        initialValue: initvalues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter description';
                          if (value.length < 10)
                            return 'Please enter description greater then 10 characters';
                          return null;
                        },
                        onSaved: (value) {
                          editproduct = Product(
                              title: editproduct.title,
                              description: value,
                              id: editproduct.id,
                              imageUrl: editproduct.imageUrl,
                              price: editproduct.price,
                              isFavourite: editproduct.isFavourite);
                        },
                      ),
                      TextFormField(
                        // initialValue:_Imagecontoller.text,
                        decoration: InputDecoration(
                          labelText: 'Enter imageUrl',
                        ),
                        controller: _Imagecontoller,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        onFieldSubmitted: (_) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value.isEmpty) return 'Please enter imageUrl';
                          return null;
                        },
                        onSaved: (value) {
                          editproduct = Product(
                              title: editproduct.title,
                              description: editproduct.description,
                              id: editproduct.id,
                              imageUrl: value,
                              price: editproduct.price,
                              isFavourite: editproduct.isFavourite);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        alignment: Alignment.center,
                        width: 200,
                        height: 200,
                        child: _Imagecontoller.text != ''
                            ? FittedBox(
                                child: Image.network(
                                _Imagecontoller.text,
                                fit: BoxFit.cover,
                              ))
                            : Text('Add ImageUrl'),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                          onPressed: formsubmit, child: Text('Submit'))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
