import 'package:Products/Products/products_grid.dart';
import 'package:Products/models/user.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter/material.dart';

class ProductType extends StatefulWidget {
  final String productType;
  final String brandName;
  final UserData user;
  final List<dynamic> roles;
  ProductType({this.productType, this.brandName, this.user, this.roles});
  @override
  _ProductTypeState createState() => _ProductTypeState();
}

class _ProductTypeState extends State<ProductType> {

  void initState() {
    super.initState();
  }
  double sizedBoxDistance = 25.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PRODUCT_TYPE),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _buildProductType(),
    );
  }

  Widget _buildProductType() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //PU Paint 
            widget.productType == COATINGS
                ? Container(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsGrid(
                                    user: widget.user,
                                    roles: widget.roles,
                                    brandName: widget.brandName,
                                    productType: TAB_PAINT_TEXT,
                                    categoryType: PU_BUTTON,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500]),
                            borderRadius: BorderRadius.circular(25.0)),
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Center(
                            child: Text(
                          PU_BUTTON,
                          style: textStyle8,
                        )),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //NC Paint
            widget.productType == COATINGS
                ? Container(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsGrid(
                                    user: widget.user,
                                    roles: widget.roles,
                                    brandName: widget.brandName,
                                    productType: TAB_PAINT_TEXT,
                                    categoryType: NC_BUTTON,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500]),
                            borderRadius: BorderRadius.circular(25.0)),
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Center(
                            child: Text(
                          NC_BUTTON,
                          style: textStyle8,
                        )),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Stain
            widget.productType == COATINGS
                ? Container(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsGrid(
                                    user: widget.user,
                                    roles: widget.roles,
                                    productType: TAB_PAINT_TEXT,
                                    brandName: widget.brandName,
                                    categoryType: STAIN,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500]),
                            borderRadius: BorderRadius.circular(25.0)),
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Center(
                            child: Text(
                          STAIN,
                          style: textStyle8,
                        )),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Thinner
            widget.productType == 'COATING'
                ? Container(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsGrid(
                                    user: widget.user,
                                    roles: widget.roles,
                                    productType: TAB_PAINT_TEXT,
                                    brandName: widget.brandName,
                                    categoryType: THINNER,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500]),
                            borderRadius: BorderRadius.circular(25.0)),
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Center(
                            child: Text(
                          THINNER,
                          style: textStyle8,
                        )),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Exterior Paint
            widget.productType == 'COATING'
                ? Container(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsGrid(
                                    user: widget.user,
                                    roles: widget.roles,
                                    productType: TAB_PAINT_TEXT,
                                    brandName: widget.brandName,
                                    categoryType: EXT_BUTTON,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500]),
                            borderRadius: BorderRadius.circular(25.0)),
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Center(
                            child: Text(
                          EXT_BUTTON,
                          style: textStyle8,
                        )),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Acrylic Paint
            widget.productType == 'COATING'
                ? Container(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsGrid(
                                    user: widget.user,
                                    roles: widget.roles,
                                    productType: TAB_PAINT_TEXT,
                                    brandName: widget.brandName,
                                    categoryType: AC_BUTTON,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500]),
                            borderRadius: BorderRadius.circular(25.0)),
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Center(
                            child: Text(
                          AC_BUTTON,
                          style: textStyle8,
                        )),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Special Paint
            widget.productType == 'COATING'
                ? Container(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsGrid(
                                    user: widget.user,
                                    roles: widget.roles,
                                    productType: TAB_PAINT_TEXT,
                                    brandName: widget.brandName,
                                    categoryType: SPECIAL_PRODUCT,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500]),
                            borderRadius: BorderRadius.circular(25.0)),
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Center(
                            child: Text(
                          SPECIAL_PRODUCT,
                          style: textStyle8,
                        )),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Glue
            widget.productType == 'ADHESIVE'
                ? Container(
                    child: InkWell(
                       onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsGrid(
                                    user: widget.user,
                                    roles: widget.roles,
                                    productType: TAB_PAINT_TEXT,
                                    brandName: widget.brandName,
                                    categoryType: GLUE_BUTTON,
                                  ))),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[500]),
                            borderRadius: BorderRadius.circular(25.0)),
                        width: MediaQuery.of(context).size.width,
                        height: 120.0,
                        child: Center(
                            child: Text(
                          GLUE_BUTTON,
                          style: textStyle8,
                        )),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: sizedBoxDistance,
            ),
          ],
        ),
      ),
    );
  }
}
