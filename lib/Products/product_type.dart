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
      body: selectUnitType(widget.productType),
    );
  }

  selectUnitType(String type) {
    switch (type) {
      case COATINGS:
        return _buildPaintUnit();
        break;
      case ADHESIVE:
        return _buildAdhesiveUnit();
        break;
      case WOOD:
        return _buildWoodUnit();
        break;
      case SOLID_SURFACE:
        return _buildSolidSurface();
        break;
    }
  }

  //build both paint units Sayerlack and EVI as they have common product range
  Widget _buildPaintUnit() {
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
          ],
        ),
      ),
    );
  }

  //build the single adhesive unit
  Widget _buildAdhesiveUnit() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
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
          ],
        ),
      ),
    );
  }

  //Build Wood business Unit
  Widget _buildWoodUnit() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //MDF Button
            Container(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsGrid(
                              user: widget.user,
                              roles: widget.roles,
                              brandName: widget.brandName,
                              productType: TAB_WOOD_TEXT,
                              categoryType: MDF_BUTTON,
                            ))),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Center(
                      child: Text(
                    MDF_BUTTON,
                    style: textStyle8,
                  )),
                ),
              ),
            ),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Firerated products
            Container(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsGrid(
                              user: widget.user,
                              roles: widget.roles,
                              brandName: widget.brandName,
                              productType: TAB_WOOD_TEXT,
                              categoryType: FIRE_BUTTON,
                            ))),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Center(
                      child: Text(
                    FIRE_BUTTON,
                    style: textStyle8,
                  )),
                ),
              ),
            ),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Formica products
            Container(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsGrid(
                              user: widget.user,
                              roles: widget.roles,
                              brandName: widget.brandName,
                              productType: TAB_WOOD_TEXT,
                              categoryType: HPL_BUTTON,
                            ))),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Center(
                      child: Text(
                    HPL_BUTTON,
                    style: textStyle8,
                  )),
                ),
              ),
            ),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Chipboard
            Container(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsGrid(
                              user: widget.user,
                              roles: widget.roles,
                              brandName: widget.brandName,
                              productType: TAB_WOOD_TEXT,
                              categoryType: CHIP_BUTTON,
                            ))),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Center(
                      child: Text(
                    CHIP_BUTTON,
                    style: textStyle8,
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Build Solid Surface business Unit
  Widget _buildSolidSurface() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            //Acrylic based Products
             Container(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsGrid(
                              user: widget.user,
                              roles: widget.roles,
                              brandName: widget.brandName,
                              productType: TAB_SS_TEXT,
                              categoryType: COR_BUTTON,
                            ))),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Center(
                      child: Text(
                    COR_BUTTON,
                    style: textStyle8,
                  )),
                ),
              ),
            ),
            SizedBox(
              height: sizedBoxDistance,
            ),
            //Modified Acrylic
             Container(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsGrid(
                              user: widget.user,
                              roles: widget.roles,
                              brandName: widget.brandName,
                              productType: TAB_SS_TEXT,
                              categoryType: MON_BUTTON,
                            ))),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Center(
                      child: Text(
                    MON_BUTTON,
                    style: textStyle8,
                  )),
                ),
              ),
            ),
            SizedBox(
              height: sizedBoxDistance,
            ),

          ],
        ),
      ),
    );
  }
}
