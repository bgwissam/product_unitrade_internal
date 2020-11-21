import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Products/models/products.dart';
import 'package:Products/models/user.dart';
import 'package:Products/screens/paint/brand_tile.dart';
import 'package:Products/shared/strings.dart';

class BrandListProvider extends StatefulWidget {
  final String divisionType;
  final String categoryType;
  final UserData user;
  final Brands brand;
  final Function callBackUpdate;
  BrandListProvider({this.divisionType, this.categoryType, this.brand, this.user, this.callBackUpdate});
  @override
  _BrandListState createState() => _BrandListState();
}

class _BrandListState extends State<BrandListProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final brands = Provider.of<List<Brands>>(context) ?? [];
    final user = Provider.of<User>(context) ?? [];
    if(brands.isNotEmpty)
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: brands.length ?? 0,
        itemBuilder: (context, index) {
          return BrandTile(
            brand: brands[index],
            user: user,
            divisionType: widget.divisionType,
            categoryType: widget.categoryType,
            callBackUpdate: widget.callBackUpdate,
          );
        });
    else 
      return Container(
          child: Center(child: Text(EMPTY_BRAND_LIST)),
        );
  }
}
