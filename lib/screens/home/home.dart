import 'dart:io';
import 'package:Products/Products/product_type.dart';
import 'package:algolia/algolia.dart';
import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Products/Products/product_form.dart';
import 'package:Products/drawer/profile_drawer.dart';
import 'package:Products/models/cart_functions.dart';
import 'package:Products/models/user.dart';
import 'package:Products/screens/paint/brands.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/loading.dart';
import 'package:Products/shared/strings.dart';
import 'package:image_ink_well/image_ink_well.dart';
import 'package:Products/models/products.dart';
import 'package:Products/shared/functions.dart';

class Home extends StatefulWidget {
  final String userId;
  Home({this.userId});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  PaintMaterial paintProducts;
  WoodProduct woodSolidProducts;
  Accessories accessoriesProducts;
  Lights lightProducts;
  TabController _tabController;
  bool isSearching = false;
  bool isTyping = false;
  UserData user;
  bool isAdmin;
  bool isPriceAdmin;
  String searchWord = '';
  int cartLength = 0;
  //set size for sized box
  var distanceBetweenInkWells = 25.0;
  var distanceBetweenInkWellLabel = 5.0;
  //search bar varialbles
  List<AlgoliaObjectSnapshot> _results = new List();
  LoadFile currentFile = new LoadFile();
  //set a variable for the cart list
  List<String> cartList = new List();
  Directory document;
  File file;
  String placeHolderImage = 'assets/images/placeholder.png';
  String firstName;
  String lastName;
  String emailAddress;
  String company;
  String phoneNumber;
  String countryOfResidence;
  String cityOfResidence;
  //This search method will perform a search of several indices in the algolia database, the return
  //result will be listed in our listview builder
  Future _search() async {
    setState(() {});

    Algolia algolia = Algolia.init(
        applicationId: 'EINFBWASYK',
        apiKey: '86ddd40b6747ad6183a42935a26c9c4a');

    List<AlgoliaObjectSnapshot> queryPaint =
        (await (algolia.instance.index('paint').search(searchWord))
                .getObjects())
            .hits;
    // List<AlgoliaObjectSnapshot> queryWood =
    //     (await (algolia.instance.index('wood').search(searchWord)).getObjects())
    //         .hits;
    // List<AlgoliaObjectSnapshot> querySolid =
    //     (await (algolia.instance.index('solid_surface').search(searchWord))
    //             .getObjects())
    //         .hits;

    // List<AlgoliaObjectSnapshot> queryAccessories =
    //     (await (algolia.instance.index('accessories').search(searchWord))
    //             .getObjects())
    //         .hits;

    // List<AlgoliaObjectSnapshot> queryLights =
    //     (await (algolia.instance.index('light').search(searchWord))
    //             .getObjects())
    //         .hits;

    return Future.delayed(const Duration(milliseconds: 600))
        .then((value) => _results = queryPaint
            //  +
            //     queryWood +
            //     querySolid +
            //     queryAccessories +
            //     queryLights
            );
  }

  //get the first name of the user
  Future _getUserData() async {
    await DatabaseService()
        .unitradeCollection
        .document(widget.userId)
        .get()
        .then((value) {
      setState(() {
        firstName = value.data['firstName'];
        lastName = value.data['lastName'];
        company = value.data['company'];
        phoneNumber = value.data['phoneNumber'];
        countryOfResidence = value.data['countryOfResidence'];
        cityOfResidence = value.data['cityOfResidence'];
        emailAddress = value.data['emailAddress'];
        isPriceAdmin = value.data['isPriceAdmin'];
        isAdmin = value.data['isAdmin'];
        if (firstName != null) {
          firstName = firstName.capitalize();
        }
        if (lastName != null) {
          lastName = lastName.capitalize();
        }
        if (company != null) {
          company = company.capitalize();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    print(isAdmin);
    _tabController = new TabController(length: 1, vsync: this);
  }

  //get the size of the cart
  Future getCartDetails() async {
    await currentFile.loadDocument().then((value) {
      cartList = value;
    });
    setState(() {
      cartLength = cartList.length;
    });
    _callBackUpdate(cartLength);
  }

  //update the cart size after additional of product and if Back buttom is pressed to go back to home page
  _callBackUpdate(int cartSize) async {
    setState(() {
      cartLength = cartSize;
    });
  }

  //obtains the ID of the current user
  Future getCurrentUser() async {
    DatabaseService databaseService = DatabaseService(uid: widget.userId);
    await databaseService.unitradeCollection
        .document(widget.userId)
        .get()
        .then((value) {
      isAdmin = value.data['isAdmin'];
      isPriceAdmin = value.data['isPriceAdmin'];
    });
    return isAdmin;
  }

  //Dailog box for exsiting app
  Future onBackPressed() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(EXIT_APP_TITLE),
            content: Text(EXIT_APP_CONTENT),
            actions: [
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(ALERT_NO),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: Text(ALERT_YES),
              ),
            ],
          );
        });
  }

  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackPressed();
        return true;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent,
              elevation: 0.0,
              title: Text(UNITRADE_PRODUCTS),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    getCartDetails();
                    setState(() {
                      this.isSearching = !this.isSearching;
                    });
                  },
                ),
              ],
              bottom: TabBar(
                labelColor: Colors.deepPurpleAccent,
                isScrollable: true,
                unselectedLabelColor: Colors.white,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  color: Colors.white,
                ),
                onTap: (index) {
                  currentTabIndex = index;
                  setState(() {
                    isSearching = false;
                  });
                },
                tabs: [
                  new Tab(
                    text: TAB_COATINGS_AND_ADHESIVES,
                  ),
                  // new Tab(
                  //   text: TAB_WOOD_TEXT,
                  // ),
                  // new Tab(text: TAB_SS_TEXT),
                  // new Tab(
                  //   text: TAB_LIGHT_TEXT,
                  // ),
                  // new Tab(text: TAB_ACCESSORIES_TEXT)
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              )),
          drawer: ProfileDrawer(
            userId: widget.userId,
            firstName: firstName,
            lastName: lastName,
            emailAddress: emailAddress,
            company: company,
            phoneNumber: phoneNumber,
            countryOfResidence: countryOfResidence,
            cityOfResidence: cityOfResidence,
          ),
          body: !isSearching
              ? TabBarView(
                  children: [
                    _buildPaintWidget(),
                    // _buildWoodWiget(),
                    // _buildSolidSurfaceWiget(),
                    // _buildLightingWiget(),
                    // _buildAccessoriesWiget(),
                  ],
                  controller: _tabController,
                )
              : _buildSearchingTextField()),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Build the search text field
  Widget _buildSearchingTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  hintText: SEARCH,
                ),
                onChanged: (value) {
                  setState(() {
                    searchWord = value;
                    _search();
                    isTyping = true;
                  });
                  getCartDetails();
                },
              ),
              !isTyping ? Container() : _buildSearchProductListView(),
            ],
          ),
        ),
      ),
    );
  }

  //build the Listview for the search text field
  Widget _buildSearchProductListView() {
    if (searchWord.isEmpty) {
      if (_results.isNotEmpty) _results.clear();
      return Container();
    } else {
      return _buildSearchResults();
    }
  }

  //Build the list view for search results
  Widget _buildSearchResults() {
    return FutureBuilder(
        future: _search(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (_results.isNotEmpty) {
                return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15.0,
                      );
                    },
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _results == null ? 0 : _results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        contentPadding: new EdgeInsets.all(5.0),
                        leading: _results[index]
                                .data['imageListUrls']
                                .isNotEmpty
                            ? new Container(
                                child: FadeInImage(
                                  fit: BoxFit.contain,
                                  placeholder: AssetImage(placeHolderImage),
                                  width: 80.0,
                                  height: 80.0,
                                  image: CacheImage(
                                      _results[index].data['imageListUrls'][0]),
                                ),
                              )
                            : _results[index].data['imageLocalUrl'] != null
                                ? Image.asset(
                                    _results[index].data['imageLocalUrl'])
                                : SizedBox(
                                    height: 15.0,
                                  ),
                        title: Text(
                          _results[index].data['productName'].toString(),
                          style: textStyle1,
                        ),
                        onTap: () {
                          woodSolidProducts = new WoodProduct();
                          paintProducts = new PaintMaterial();
                          accessoriesProducts = new Accessories();
                          lightProducts = new Lights();
                          mapProductToType(
                              _results[index].data['productType'], index);
                          //open the product form when clicking on a certain result
                          if (_results[index].data['productType'] ==
                              TAB_PAINT_TEXT) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm(
                                          paintProducts: paintProducts,
                                          isAdmin: isAdmin ?? false,
                                          isPriceAdmin: isPriceAdmin ?? false,
                                        )));
                          } else if (_results[index].data['productType'] ==
                                  TAB_WOOD_TEXT ||
                              _results[index].data['productType'] ==
                                  TAB_SS_TEXT) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm(
                                          woodProduct: woodSolidProducts,
                                          isAdmin: isAdmin ?? false,
                                          isPriceAdmin: isPriceAdmin ?? false,
                                          cartList: cartList,
                                        )));
                          } else if (_results[index].data['productType'] ==
                              TAB_ACCESSORIES_TEXT) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm(
                                          accessoriesProduct:
                                              accessoriesProducts,
                                          isAdmin: isAdmin ?? false,
                                          isPriceAdmin: isPriceAdmin ?? false,
                                          cartList: cartList,
                                        )));
                          } else if (_results[index].data['productType'] ==
                              TAB_LIGHT_TEXT) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm(
                                          lightProduct: lightProducts,
                                          isAdmin: isAdmin ?? false,
                                          isPriceAdmin: isPriceAdmin ?? false,
                                          cartList: cartList,
                                        )));
                          }
                        },
                      );
                    });
              } else {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: Text('No data was found for your search results'),
                );
              }
            } else if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Text('Error was found, contact administrator'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Loading(),
            );
          } else {
            return Container(
              child: Text('Unknown Result'),
            );
          }
          return Container(
            child: Text('Unknown Result'),
          );
        });
  }

  //Map each product to its class type and set its values from the result array
  void mapProductToType(var productType, int index) {
    switch (productType) {
      case TAB_PAINT_TEXT:
        {
          //set the records of the class
          paintProducts.uid = _results[index].objectID;
          paintProducts.productName = _results[index].data['productName'];
          paintProducts.productType = _results[index].data['productType'];
          paintProducts.productCategory =
              _results[index].data['productCategory'];
          paintProducts.productBrand = _results[index].data['productBrand'];
          paintProducts.productPackUnit =
              _results[index].data['productPackUnit'];
          paintProducts.color = _results[index].data['color'];
          paintProducts.description = _results[index].data['description'];
          paintProducts.productTags = _results[index].data['tags'];
          paintProducts.imageListUrls = _results[index].data['imageListUrls'];
        }
        break;
      case TAB_WOOD_TEXT:
        {
          //set all the records of the class
          woodSolidProducts.uid = _results[index].objectID;
          woodSolidProducts.productName = _results[index].data['productName'];
          woodSolidProducts.productType = _results[index].data['productType'];
          woodSolidProducts.productCategory =
              _results[index].data['productCategory'];
          woodSolidProducts.productBrand = _results[index].data['productBrand'];
          woodSolidProducts.length = _results[index].data['length'];
          woodSolidProducts.width = _results[index].data['width'];
          woodSolidProducts.thickness = _results[index].data['thickness'];
          woodSolidProducts.color = _results[index].data['color'];
          woodSolidProducts.description = _results[index].data['description'];
          woodSolidProducts.productTags = _results[index].data['tags'];
          woodSolidProducts.imageListUrls =
              _results[index].data['imageListUrls'];
        }
        break;
      case TAB_SS_TEXT:
        {
          //set all the records of the class
          woodSolidProducts.uid = _results[index].objectID;
          woodSolidProducts.productName = _results[index].data['productName'];
          woodSolidProducts.productType = _results[index].data['productType'];
          woodSolidProducts.productCategory =
              _results[index].data['productCategory'];
          woodSolidProducts.productBrand = _results[index].data['productBrand'];
          woodSolidProducts.length = _results[index].data['length'];
          woodSolidProducts.width = _results[index].data['width'];
          woodSolidProducts.thickness = _results[index].data['thickness'];
          woodSolidProducts.color = _results[index].data['color'];
          woodSolidProducts.description = _results[index].data['description'];
          woodSolidProducts.productTags = _results[index].data['tags'];
          woodSolidProducts.imageListUrls =
              _results[index].data['imageListUrls'];
        }
        break;
      case TAB_ACCESSORIES_TEXT:
        {
          //set all the records of the class
          accessoriesProducts.uid = _results[index].objectID;
          accessoriesProducts.productName = _results[index].data['productName'];
          accessoriesProducts.productType = _results[index].data['productType'];
          accessoriesProducts.productCategory =
              _results[index].data['productCategory'];
          accessoriesProducts.productBrand =
              _results[index].data['productBrand'];
          accessoriesProducts.length = _results[index].data['length'];
          accessoriesProducts.angle = _results[index].data['length'];
          accessoriesProducts.closingType = _results[index].data['closingType'];
          accessoriesProducts.color = _results[index].data['color'];
          accessoriesProducts.description = _results[index].data['description'];
          accessoriesProducts.productTags = _results[index].data['tags'];
          accessoriesProducts.imageListUrls =
              _results[index].data['imageListUrls'];
        }
        break;
      case TAB_LIGHT_TEXT:
        {
          //set all the records of the class
          lightProducts.uid = _results[index].objectID;
          lightProducts.productName = _results[index].data['productName'];
          lightProducts.productType = _results[index].data['productType'];
          lightProducts.productCategory =
              _results[index].data['productCategory'];
          lightProducts.productBrand = _results[index].data['productBrand'];
          lightProducts.voltage = _results[index].data['voltage'];
          lightProducts.watt = _results[index].data['watt'];
          lightProducts.dimensions = _results[index].data['dimensions'];
          lightProducts.color = _results[index].data['color'];
          lightProducts.description = _results[index].data['description'];
          lightProducts.productTags = _results[index].data['tags'];
          lightProducts.imageListUrls = _results[index].data['imageListUrls'];
        }
        break;
    }
  }

  //paint products widget build
  Widget _buildPaintWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            //Sayerlack Inkwell
            Container(
              height: 120.0,
              child: InkWell(
                onTap: () {
                  if (isAdmin != null || isPriceAdmin != null)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductType(
                                  productType: 'COATING',
                                  brandName: 'SAYERLACK',
                                  isAdmin: isAdmin,
                                )));
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 150.0,
                  child: Image.asset('assets/images/brands/sayerlack_logo.jpg'),
                ),
              ),
            ),
            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //EVI Inkwell
            Container(
              height: 120.0,
              child: InkWell(
                onTap: () {
                  if (isAdmin != null)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductType(
                                  productType: 'COATING',
                                  brandName: 'EVI',
                                  isAdmin: isAdmin,
                                )));
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 120.0,
                  child: Image.asset('assets/images/brands/evi_logo.jpg'),
                ),
              ),
            ),

            SizedBox(
              height: distanceBetweenInkWells,
            ),
            //Unicol Inkwell
            Container(
              height: 120.0,
              child: InkWell(
                onTap: () {
                  if (isAdmin != null)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductType(
                                  productType: 'ADHESIVE',
                                  brandName: 'UNICOL',
                                  isAdmin: isAdmin,
                                )));
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(25.0)),
                  width: MediaQuery.of(context).size.width,
                  height: 150.0,
                  child: Image.asset('assets/images/brands/unicol_logo.png'),
                ),
              ),
            ),

            SizedBox(
              height: distanceBetweenInkWells,
            ),
          ],
        ),
      ),
    );
  }

  //wood products widget build
  Widget _buildWoodWiget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Column(
            children: [
              //MDF Wood
              ImageInkWell(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrandList(
                                divisionType: TAB_WOOD_TEXT,
                                categoryType: MDF_BUTTON,
                                isAdmin: isAdmin,
                                callBackUpdate: _callBackUpdate,
                              )));
                },
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                image: AssetImage('assets/Ink_well/mdf.png'),
              ),
              SizedBox(
                height: distanceBetweenInkWellLabel,
              ),
              Text(MDF_BUTTON, style: textStyle1),
            ],
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
          Column(
            children: [
              //Chip board
              ImageInkWell(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrandList(
                                divisionType: TAB_WOOD_TEXT,
                                categoryType: CHIP_BUTTON,
                                isAdmin: isAdmin,
                                callBackUpdate: _callBackUpdate,
                              )));
                },
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                image: AssetImage('assets/Ink_well/chipboard.png'),
              ),
              SizedBox(
                height: distanceBetweenInkWellLabel,
              ),
              Text(CHIP_BUTTON, style: textStyle1),
            ],
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
          Column(
            children: [
              //Hard Wood
              ImageInkWell(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrandList(
                                divisionType: TAB_WOOD_TEXT,
                                categoryType: SOLID_BUTTON,
                                isAdmin: isAdmin,
                                callBackUpdate: _callBackUpdate,
                              )));
                },
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                image: AssetImage('assets/Ink_well/hardwood.png'),
              ),
              SizedBox(
                height: distanceBetweenInkWellLabel,
              ),
              Text(SOLID_BUTTON, style: textStyle1),
            ],
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
          Column(
            children: [
              //Fire resistant
              ImageInkWell(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrandList(
                                divisionType: TAB_WOOD_TEXT,
                                categoryType: FIRE_BUTTON,
                                isAdmin: isAdmin,
                                callBackUpdate: _callBackUpdate,
                              )));
                },
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                image: AssetImage('assets/Ink_well/fire_resistant.png'),
              ),
              SizedBox(
                height: distanceBetweenInkWellLabel,
              ),
              Text(FIRE_BUTTON, style: textStyle1),
            ],
          ),
        ],
      ),
    );
  }

  //Solid Surface products
  Widget _buildSolidSurfaceWiget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Column(
            children: [
              //Acylic Solid Surface
              ImageInkWell(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrandList(
                                divisionType: TAB_SS_TEXT,
                                categoryType: COR_BUTTON,
                                isAdmin: isAdmin,
                                callBackUpdate: _callBackUpdate,
                              )));
                },
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                image: AssetImage('assets/Ink_well/acrylic_solid.png'),
              ),
              SizedBox(
                height: distanceBetweenInkWellLabel,
              ),
              Text(
                COR_BUTTON,
                style: textStyle1,
              ),
            ],
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
          Column(
            children: [
              //Modified Acyrlic Solid Surface
              ImageInkWell(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrandList(
                                divisionType: TAB_SS_TEXT,
                                categoryType: MON_BUTTON,
                                isAdmin: isAdmin,
                                callBackUpdate: _callBackUpdate,
                              )));
                },
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                image: AssetImage('assets/Ink_well/modified_acylic.png'),
              ),
              SizedBox(
                height: distanceBetweenInkWellLabel,
              ),
              Text(MON_BUTTON, style: textStyle1),
            ],
          )
        ],
      ),
    );
  }

  //Accessories
  Widget _buildAccessoriesWiget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Column(
            children: [
              ImageInkWell(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrandList(
                                divisionType: TAB_ACCESSORIES_TEXT,
                                categoryType: SALICE_BUTTON,
                                isAdmin: isAdmin,
                                callBackUpdate: _callBackUpdate,
                              )));
                },
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                image: AssetImage('assets/Ink_well/accessories.png'),
              ),
              SizedBox(
                height: distanceBetweenInkWellLabel,
              ),
              Text(
                SALICE_BUTTON,
                style: textStyle1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Lighting
  Widget _buildLightingWiget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Column(
            children: [
              ImageInkWell(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrandList(
                                divisionType: TAB_LIGHT_TEXT,
                                categoryType: HAFELE_BUTTON,
                                isAdmin: isAdmin,
                                callBackUpdate: _callBackUpdate,
                              )));
                },
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                image: AssetImage('assets/Ink_well/lighting.png'),
              ),
              SizedBox(
                height: distanceBetweenInkWellLabel,
              ),
              Text(
                HAFELE_BUTTON,
                style: textStyle1,
              )
            ],
          ),
        ],
      ),
    );
  }
}
