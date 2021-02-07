import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Products/Products/product_form.dart';
import 'package:Products/Products/product_list.dart';
import 'package:Products/models/cart_functions.dart';
import 'package:Products/models/products.dart';
import 'package:Products/models/user.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/strings.dart';

class ProductsGrid extends StatefulWidget {

  final String productType;
  final String brandName;
  final String categoryType;
  final Function callBackUpdate;
  final UserData user;
  final List<dynamic> roles;
  ProductsGrid(
      {
      this.productType,
      this.brandName,
      this.categoryType,
      this.callBackUpdate,
      this.user,
      this.roles});
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductsGrid> {
  List<String> cartList = [];
  List<String> paintProduct = [];
  List<String> woodProduct = [];
  LoadFile currentFile = new LoadFile();
  Directory document;
  File file;
  int cartLength = 0;
  var result;
  String productColorMain = 'clear';
  @override
  void initState() {
    print('user roles ${widget.roles}');
    super.initState();
  }

  void productColorCallback(String productColor) {
    setState(() {
      productColorMain = productColor;
    });
  }

  //function to add new products
  void _addNewProduct() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductForm(
                  roles: widget.roles,
                )));
  }

  //read data from your file
  Future readCartList() async {
    try {
      if (file.existsSync()) {
        Future<List<String>> currentContent = file.readAsLines();
        currentContent.then((value) => print(value));
      } else {
        print('couldn\'t read file');
      }
    } catch (e) {
      print('couldn\'t read data from the local storage file due to: $e');
    }
  }

//return the build widget for all products
  Widget productBuild() {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(PRODUCTS),
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 0.0,
          actions: <Widget>[
            widget.roles.contains('isAdmin')
                ? FlatButton.icon(
                    onPressed: () => _addNewProduct(),
                    icon: new IconTheme(
                        data: new IconThemeData(color: Colors.white),
                        child: Icon(Icons.menu)),
                    label: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
          ],
        ),
        body: Container(
          child: ProductList(
            roles: widget.roles,
            productBrand: widget.brandName,
            productType: widget.productType,
            productCategory: widget.categoryType,
            productColorCallback: productColorCallback,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.categoryType) {
      case PU_BUTTON:
        {
          
         return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                  brandName: widget.brandName,
                  productType: widget.productType,
                  productCategory: widget.categoryType,
                  productColor: productColorMain),
              child: productBuild());
        }
        break;
      case NC_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                  brandName: widget.brandName,
                  productType: widget.productType,
                  productCategory: widget.categoryType,
                  productColor: productColorMain),
              child: productBuild());
        }
        break;
      case STAIN:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                  brandName: widget.brandName,
                  productType: widget.productType,
                  productCategory: widget.categoryType),
              child: productBuild());
        }
        break;
      case AC_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                  brandName: widget.brandName,
                  productType: widget.productType,
                  productCategory: widget.categoryType,
                  productColor: productColorMain),
              child: productBuild());
        }
        break;
      case THINNER:
        {
          return StreamProvider<List<PaintMaterial>>.value(
              value: DatabaseService().paintProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType,
              ),
              child: productBuild());
        }
        break;
      case EXT_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
            value: DatabaseService().paintProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType,
                productColor: productColorMain),
            child: productBuild(),
          );
        }
        break;
      case SPECIAL_PRODUCT:
        {
          return StreamProvider<List<PaintMaterial>>.value(
            value: DatabaseService().paintProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
        break;
      case GLUE_BUTTON:
        {
          return StreamProvider<List<PaintMaterial>>.value(
            value: DatabaseService().paintProducts(
                brandName: widget.brandName,
                productType: widget.productType,
                productCategory: widget.categoryType),
            child: productBuild(),
          );
        }
      default:
        {
          return Container(
            child: Center(child: Text('An unexpected Error occured in productGrid occurred')),
          );
        }
    }
  }
}
