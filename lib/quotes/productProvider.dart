import 'package:Products/models/products.dart';
import 'package:Products/no_data/no_data.dart';
import 'package:Products/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductProvider extends StatefulWidget {
  @override
  _ProductProviderState createState() => _ProductProviderState();
}

class _ProductProviderState extends State<ProductProvider> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PaintMaterial>>.value(
      value: DatabaseService().allPaintProduct,
      child: Material(
        child: ProductProviderList(),
      ),
    );
  }
}

class ProductProviderList extends StatefulWidget {
  @override
  _ProductProviderListState createState() => _ProductProviderListState();
}

class _ProductProviderListState extends State<ProductProviderList> {
  @override
  Widget build(BuildContext context) {
    var products = Provider.of<List<PaintMaterial>>(context) ?? [];
    if(products.isNotEmpty)
    return Container(
      
    );
    else 
      return NoDataExists(
        contexttext: 'No products available!',
        title: 'Paint Products',
      );
  }
}