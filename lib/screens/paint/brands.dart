import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Products/models/products.dart';
import 'package:Products/screens/paint/brand_list.dart';
import 'package:Products/services/database.dart';
import 'brands_form.dart';

class BrandList extends StatelessWidget {
  final String divisionType;
  final String categoryType;
  final bool isAdmin;
  final Function callBackUpdate;
  BrandList(
      {this.divisionType,
      this.categoryType,
      this.isAdmin,
      this.callBackUpdate});
  @override
  Widget build(BuildContext context) {
    //will create the panel in which we can add a brand
    void _addNewBrand() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandsForm(),
          ));
    }

    return StreamProvider<List<Brands>>.value(
      value: DatabaseService().categoryBrands(categoryType),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Brands'),
          backgroundColor: Colors.amber[400],
          elevation: 0.0,
          actions: <Widget>[
            isAdmin
                ? FlatButton.icon(
                    onPressed: () => _addNewBrand(),
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
          child: BrandListProvider(
            divisionType: divisionType,
            categoryType: categoryType,
            callBackUpdate: callBackUpdate,
          ),
        ),
      ),
    );
  }
}
