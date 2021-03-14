import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:Products/Products/product_form.dart';
import 'package:Products/models/products.dart';
import 'package:Products/models/user.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/loading.dart';
import 'package:Products/shared/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductTile extends StatefulWidget {
  final PaintMaterial product;
  final WoodProduct woodProduct;
  final SolidProduct solidProduct;
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
      this.solidProduct,
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
    if (result.contains('isSuperAdmin')) isAdmin = true;
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
            //Product Name
            widget.product.productName.isNotEmpty
                ? Text(
                    '${widget.product.itemCode} - ${widget.product.productName}',
                    textAlign: TextAlign.center,
                    style: textStyle4)
                : Text(''),
            //Packing field
            widget.product.productPack != null
                ? Text(
                    '${widget.product.productPack.toString()} ${widget.product.productPackUnit}',
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  )
                : Text(''),
            //Price field
            widget.product.productPrice != null
                ? Text(
                    '${widget.product.productPrice} SR',
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  )
                : Text(''),

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
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: widget.woodProduct.imageListUrls.isEmpty
                            ? 'assets/images/no_image.png'
                            : widget.woodProduct.imageListUrls[0],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            Image.asset(placeHolderImage),
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
            //Wood product name and item code
            widget.woodProduct.productName != null
                ? Text(
                    '${widget.woodProduct.itemCode} - ${widget.woodProduct.productName}',
                    style: textStyle4,
                    textAlign: TextAlign.center,
                  )
                : Text(''),
            //wood product dimensions
            widget.woodProduct.length != null
                ? Text(
                    '${widget.woodProduct.length} x ${widget.woodProduct.width} x ${widget.woodProduct.thickness} mm',
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  )
                : Text(''),

            //Wood product price
            widget.woodProduct.productPrice != null
                ? Text(
                    '${widget.woodProduct.productPrice} SR',
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  )
                : Text(''),

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
                    solidProduct: widget.solidProduct, roles: widget.roles)));
      },
      child: Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: widget.solidProduct.imageListUrls != null
                  ? Container(
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: widget.solidProduct.imageListUrls.isNotEmpty
                            ? widget.solidProduct.imageListUrls[0]
                            : 'assets/images/no_image.png',
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            Image.asset(placeHolderImage),
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
            //Wood solid surface name and item code
            widget.solidProduct.productName != null
                ? Text(
                    '${widget.solidProduct.itemCode} - ${widget.solidProduct.productName}',
                    style: textStyle4,
                    textAlign: TextAlign.center,
                  )
                : Text(''),
            //wood solid surface dimensions
            widget.solidProduct.length != null
                ? Text(
                    '${widget.solidProduct.length} x ${widget.solidProduct.width} x ${widget.solidProduct.thickness} mm',
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  )
                : Text(
                    '${widget.solidProduct.productPack} ml',
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  ),

            //Wood solid surface price
            widget.solidProduct.productPrice != null
                ? Text(
                    '${widget.solidProduct.productPrice} SR',
                    style: textStyle5,
                    textAlign: TextAlign.center,
                  )
                : Text(''),
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
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: widget.lightProduct.imageListUrls[0] ?? '',
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
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
    List<String> specs = [];
    specs.clear();
    //Fill the available specs for each item as accessories have many specs that needs to be shown
    if (widget.accessoriesProduct.closingType != null)
      specs.add('${widget.accessoriesProduct.closingType}');
    if (widget.accessoriesProduct.length != null ||
        widget.accessoriesProduct.itemSide != null)
      specs.add(
          '${widget.accessoriesProduct.length} mm - ${widget.accessoriesProduct.itemSide}');
    if (widget.accessoriesProduct.angle != null)
      specs.add('${widget.accessoriesProduct.angle}');
    if (widget.accessoriesProduct.extensionType != null)
      specs.add('${widget.accessoriesProduct.extensionType}');
    if (widget.accessoriesProduct.productPrice != null)
      specs.add('${widget.accessoriesProduct.productPrice} SR');

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
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl:
                            widget.accessoriesProduct.imageListUrls.isNotEmpty
                                ? widget.accessoriesProduct.imageListUrls[0]
                                : 'assets/images/no_image.png',
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            Image.asset(placeHolderImage),
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
            //Accessories item code and product name
            widget.accessoriesProduct.productName != null
                ? Text(
                    '${widget.accessoriesProduct.itemCode} - ${widget.accessoriesProduct.productName}',
                    style: textStyle4,
                    textAlign: TextAlign.center,
                  )
                : Text(''),

            //loop over accesories specs
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: specs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(
                    specs[index],
                    textAlign: TextAlign.center,
                    style: textStyle5,
                  );
                },
              ),
            ),

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
