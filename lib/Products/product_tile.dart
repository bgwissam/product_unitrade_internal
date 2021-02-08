import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:Products/Products/product_form.dart';
import 'package:Products/models/products.dart';
import 'package:Products/models/user.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/loading.dart';
import 'package:Products/shared/strings.dart';
import 'package:cache_image/cache_image.dart';

class ProductTile extends StatefulWidget {
  final PaintMaterial product;
  final WoodProduct woodProduct;
  final Lights lightProduct;
  final Accessories accessoriesProduct;
  final UserData user;
  final String productBrand;
  final String productType;
  final String productName;
  final String productPack;
  final String length;
  final String width;
  final String thickness;
  final String productColor;
  final List<String> productImage;
  final List<String> cartList;
  final Function callback;
  final Function writeToFile;
  final Function callbackCart;
  final List<dynamic> roles;
  ProductTile(
      {this.product,
      this.woodProduct,
      this.lightProduct,
      this.accessoriesProduct,
      this.user,
      this.productBrand,
      this.productType,
      this.productName,
      this.productPack,
      this.length,
      this.width,
      this.thickness,
      this.productColor,
      this.productImage,
      this.callback,
      this.writeToFile,
      this.cartList,
      this.callbackCart,
      this.roles});
  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool isAdmin = false;
  bool isPriceAdmin = false;
  String userId;
  String imageUrl;
  List<String> paintList = [];
  List<String> woodList = [];
  String placeHolderImage = 'assets/images/placeholder.png';
  @override
  void initState() {
    super.initState();
  }

  //check if the current user is an Admin or not
  Future getCurrentUser() async {
    userId = widget.user.uid;
    DatabaseService databaseService = DatabaseService(uid: widget.user.uid);
    var result = await databaseService.unitradeCollection
        .document(userId)
        .get()
        .then((value) {
      return value.data['roles'];
    });
    print('The result is: $result');
    return result;
  }

  Future<Widget> _getImage(BuildContext context, String imageUrl) async {
    Image productImage;
    return productImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getCurrentUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                //returns container for normal non-admin users
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: FutureBuilder(
                  future: _getImage(context, imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      switch (widget.productType) {
                        case TAB_PAINT_TEXT:
                          return _buildPaintList();
                          break;
                        case TAB_WOOD_TEXT:
                          return _buildWoodList();
                          break;
                        case TAB_SS_TEXT:
                          return _buildSolidSurfaceList();
                          break;
                        case TAB_LIGHT_TEXT:
                          return _buildLightList();
                          break;
                        case TAB_ACCESSORIES_TEXT:
                          return _buildAccessoriesList();
                          break;
                        default:
                          return Container();
                          break;
                      }
                    }
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container(
                        height: 90.0,
                        width: MediaQuery.of(context).size.width / 1.25,
                        child: Container(),
                      );
                    return Container();
                  },
                ),
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }

  //return container paint
  Widget _buildPaintList() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    paintProducts: widget.product, roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: [
            //Image field
            widget.product.imageLocalUrl != null
                ? Expanded(
                    flex: 4,
                    child: Image.asset(
                      widget.product.imageLocalUrl ?? '',
                    ),
                  )
                : Expanded(
                    flex: 4,
                    child: Image.asset('assets/images/no_image.png'),
                  ),
            SizedBox(
              width: 10.0,
            ),
            Divider(
              color: Colors.black,
              indent: 10.0,
              endIndent: 10.0,
            ),
            //Product name field
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  '${widget.product.itemCode} - ${widget.product.productName}',
                  style: textStyle4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //Packing field
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.product.productPack.toString(),
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    widget.product.productPackUnit,
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            //Price field
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  '${widget.product.productPrice.toString()} SR',
                  style: textStyle5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            !isAdmin
                ? Container()
                : Expanded(flex: 1, child: _buildUpdateDeleteButton(context))
          ],
        ),
      ),
    );
  }

  //return container wood
  Widget _buildWoodList() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    woodProduct: widget.woodProduct, roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: widget.woodProduct.imageListUrls != null
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: CacheImage(
                            widget.woodProduct.imageListUrls.isEmpty
                                ? 'assets/images/no_image.png'
                                : widget.woodProduct.imageListUrls[0]),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Expanded(
                      flex: 4,
                      child: Text('No Image'),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.black,
              indent: 10.0,
              endIndent: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: new Text(
                  widget.woodProduct.productName,
                  style: textStyle4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: new Text(
                  'Thickness: ${widget.woodProduct.thickness} mm',
                  style: textStyle5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            !isAdmin ? Container() : _buildUpdateDeleteButton(context)
          ],
        ),
      ),
    );
  }

  //return container solid surface
  Widget _buildSolidSurfaceList() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    woodProduct: widget.woodProduct, roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.woodProduct.imageListUrls != null
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: CacheImage(
                            widget.woodProduct.imageListUrls.isNotEmpty
                                ? widget.woodProduct.imageListUrls[0]
                                : 'assets/image/no_logo.png'),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Container(
                      child: Text('No Image'),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: 140.0,
                  child: Text(
                    widget.woodProduct.productName,
                    style: textStyle4,
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: new Text(
                  'Thickness: ${widget.woodProduct.thickness.toString()} mm',
                  style: textStyle5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            !isAdmin ? Container() : _buildUpdateDeleteButton(context)
          ],
        ),
      ),
    );
  }

  //return container lights
  Widget _buildLightList() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    lightProduct: widget.lightProduct,
                    roles: widget.user.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.lightProduct.imageListUrls != null
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: CacheImage(
                            widget.lightProduct.imageListUrls[0] ?? ''),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Container(
                      child: Text('No Image'),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: 140.0,
                  child: Text(
                    widget.lightProduct.productName,
                    style: textStyle4,
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: new Text(
                  '${widget.lightProduct.watt} W',
                  style: textStyle5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            !isAdmin ? Container() : _buildUpdateDeleteButton(context)
          ],
        ),
      ),
    );
  }

  //return container accessories
  Widget _buildAccessoriesList() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductForm(
                    accessoriesProduct: widget.accessoriesProduct,
                    roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.accessoriesProduct.imageListUrls != null
                  ? Container(
                      child: FadeInImage(
                        fit: BoxFit.contain,
                        image: CacheImage(
                            widget.accessoriesProduct.imageListUrls.isNotEmpty
                                ? widget.accessoriesProduct.imageListUrls[0]
                                : 'assets/images/no_image.png'),
                        placeholder: AssetImage(placeHolderImage),
                        height: 150,
                        width: 150,
                      ),
                    )
                  : Container(
                      child: Text('No Image'),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                  width: 140.0,
                  child: Text(
                    widget.accessoriesProduct.productName,
                    style: textStyle4,
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    widget.accessoriesProduct.length != null
                        ? Container(
                            child: Text(
                              '${widget.accessoriesProduct.length} mm',
                              style: textStyle5,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                    widget.accessoriesProduct.angle != null
                        ? Container(
                            child: Text(
                              '${widget.accessoriesProduct.angle} degrees',
                              style: textStyle5,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                  ],
                )),
            !isAdmin ? Container() : _buildUpdateDeleteButton(context)
          ],
        ),
      ),
    );
  }

  //Build the edit and delete buttons
  Widget _buildUpdateDeleteButton(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(ALERT_DELETE_PRODUCT),
                  content: Text(ALERT_DELETE_PRODUCT_CONTENT +
                      widget.productType +
                      ALERT_PRODUCT),
                  actions: [
                    new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(ALERT_NO)),
                    new FlatButton(
                        onPressed: () async {
                          if (widget.productType == TAB_PAINT_TEXT)
                            await DatabaseService().deletePaintProduct(
                                uid: widget.product.uid,
                                imageUids: widget.product.imageListUrls);
                          else if (widget.productType == TAB_WOOD_TEXT)
                            await DatabaseService().deleteWoodProduct(
                                uid: widget.woodProduct.uid,
                                imageUids: widget.woodProduct.imageListUrls);
                          else if (widget.productType == TAB_SS_TEXT)
                            await DatabaseService().deletesolidSurfaceProduct(
                                uid: widget.woodProduct.uid,
                                imageUids: widget.woodProduct.imageListUrls);
                          else if (widget.productType == TAB_LIGHT_TEXT)
                            await DatabaseService().deleteLightsProduct(
                                uid: widget.lightProduct.uid,
                                imageUids: widget.lightProduct.imageListUrls);
                          else if (widget.productType == TAB_ACCESSORIES_TEXT)
                            await DatabaseService().deleteAccessoriesProduct(
                                uid: widget.accessoriesProduct.uid,
                                imageUids:
                                    widget.accessoriesProduct.imageListUrls);

                          Navigator.of(context).pop();
                        },
                        child: Text(ALERT_YES))
                  ],
                );
              });
        },
      ),
    );
  }
}
