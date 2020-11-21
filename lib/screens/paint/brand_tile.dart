import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Products/Products/products_grid.dart';
import 'package:Products/models/products.dart';
import 'package:Products/models/user.dart';
import 'package:Products/screens/paint/brands_form.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/loading.dart';
import 'package:Products/shared/strings.dart';

class BrandTile extends StatefulWidget {
  final String divisionType;
  final String categoryType;
  final Brands brand;
  final Map<String, String> categories;
  final BrandsForm brandsForm;
  final User user;
  final Function callBackUpdate;
  BrandTile(
      {this.brand,
      this.brandsForm,
      this.divisionType,
      this.categoryType,
      this.categories,
      this.user,
      this.callBackUpdate});

  @override
  _BrandTileState createState() => _BrandTileState();
}

class _BrandTileState extends State<BrandTile> {
  bool isAdmin = false;
  String userId;
  String placeHolderImage = 'assets/images/placeholder.png';
  @override
  void initState() {
    super.initState();
  }

  //check if the current user is an Admin or not
  Future getCurrentUser() async {
    userId = widget.user.uid;

    DatabaseService databaseService = DatabaseService(uid: widget.user.uid);

    await databaseService.unitradeCollection
        .document(userId)
        .get()
        .then((value) {
      isAdmin = value.data['isAdmin'];
    });

    return isAdmin;
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image brandImage;
    return brandImage;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.brand.division == widget.divisionType) {
      return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductsGrid(
                      isAdmin: isAdmin,
                      productType: widget.divisionType,
                      brandName: widget.brand.brand,
                      categoryType: widget.categoryType,
                      callBackUpdate: widget.callBackUpdate,
                      user: widget.user,
                    ))),
        child: FutureBuilder(
            future: getCurrentUser(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData)
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: isAdmin
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]),
                              borderRadius: BorderRadius.circular(15.0)),
                          child: FutureBuilder(
                            future: _getImage(context, widget.brand.image),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  child: new Column(
                                    children: [
                                      FadeInImage(
                                        fit: BoxFit.contain,
                                        image: CacheImage(widget.brand.image),
                                        placeholder:
                                            AssetImage(placeHolderImage),
                                        height: 150.0,
                                        width: 300.0,
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          new Text(widget.brand.brand),
                                          new Text(' - '),
                                          new Text(widget.brand.countryOrigin),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                      Container(
                                        child:
                                            _buildUpdateDeleteButton(context),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  height: 90.0,
                                  width:
                                      MediaQuery.of(context).size.width / 1.25,
                                  child: Loading(),
                                );
                              }
                              return Container();
                            },
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: FutureBuilder(
                            future: _getImage(context, widget.brand.image),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  child:  FadeInImage(
                                        fit: BoxFit.contain,
                                        image: CacheImage(widget.brand.image),
                                        placeholder:
                                            AssetImage(placeHolderImage),
                                        height: 150.0,
                                      ),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Container(
                                  height: 90.0,
                                  width:
                                      MediaQuery.of(context).size.width / 1.25,
                                  child: Loading(),
                                );
                              return Container();
                            },
                          ),
                        ),
                );
              else {
                return Loading();
              }
            }),
      );
    } else
      return Container(
        height: 0.0,
        width: 0.0,
        child: Text('No data exist for this category'),
      );
  }

  Row _buildUpdateDeleteButton(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BrandsForm(brand: widget.brand)));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(ALERT_DELETE_BRAND),
                  content: Text(ALERT_DELETE_BRAND_CONTENT),
                  actions: [
                    new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(ALERT_NO)),
                    new FlatButton(
                        onPressed: () async {
                          await DatabaseService().deleteBrandData(
                              widget.brand.uid, widget.brand.image);
                          Navigator.of(context).pop();
                        },
                        child: Text(ALERT_YES))
                  ],
                );
              });
        },
      ),
    ]);
  }
}
