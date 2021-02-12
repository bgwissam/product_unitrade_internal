import 'dart:io';
import 'package:Products/Products/product_type.dart';
import 'package:algolia/algolia.dart';
import 'package:async/async.dart';
import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Products/Products/product_form.dart';
import 'package:Products/drawer/profile_drawer.dart';
import 'package:Products/models/cart_functions.dart';
import 'package:Products/models/user.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/loading.dart';
import 'package:Products/shared/strings.dart';
import 'package:Products/models/products.dart';
import 'package:Products/shared/functions.dart';

class Home extends StatefulWidget {
  final String userId;
  final bool isActive;
  final String firstName;
  Home({this.userId, this.isActive, this.firstName});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  PaintMaterial paintProducts;
  WoodProduct woodProduct;
  SolidProduct solidProduct;
  Accessories accessoriesProducts;
  Lights lightProducts;
  TabController _tabController;
  bool isSearching = false;
  bool isTyping = false;
  UserData user;
  List<dynamic> roles;
  String searchWord = '';
  int cartLength = 0;
  //set size for sized box
  var distanceBetweenInkWells = 25.0;
  var distanceBetweenInkWellLabel = 5.0;
  //search bar varialbles
  List<AlgoliaObjectSnapshot> _results = [];
  LoadFile currentFile = new LoadFile();
  //set a variable for the cart list
  List<String> cartList = [];
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
  //Controller for text field
  AsyncMemoizer _memoizer = AsyncMemoizer();
  TextEditingController _searchTextField = new TextEditingController();
  //This search method will perform a search of several indices in the algolia database, the return
  //result will be listed in our listview builder
  _fetchSearchData() {
    print(isTyping);
    return isTyping
        ? this._memoizer.runOnce(() async {
            return _search();
          })
        : _search();
  }

  Future _search() async {
    Algolia algolia = Algolia.init(
        applicationId: 'EINFBWASYK',
        apiKey: '86ddd40b6747ad6183a42935a26c9c4a');

    List<AlgoliaObjectSnapshot> queryPaint =
        (await (algolia.instance.index('paint').search(searchWord))
                .getObjects())
            .hits;
    List<AlgoliaObjectSnapshot> queryWood =
        (await (algolia.instance.index('wood').search(searchWord)).getObjects())
            .hits;
    List<AlgoliaObjectSnapshot> querySolid =
        (await (algolia.instance.index('solid_surface').search(searchWord))
                .getObjects())
            .hits;

    List<AlgoliaObjectSnapshot> queryAccessories =
        (await (algolia.instance.index('accessories').search(searchWord))
                .getObjects())
            .hits;

    return Future.delayed(const Duration(milliseconds: 600)).then((value) =>
        _results = queryPaint + queryWood + querySolid + queryAccessories);
  }

  //get the first name of the user
  Future _getUserData() async {
    DatabaseService databaseService = DatabaseService(uid: widget.userId);
    await databaseService.unitradeCollection
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
        roles = value.data['roles'];
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
    _searchTextField.addListener(() {
      searchWord = _searchTextField.text;
      _searchTextField.value = _searchTextField.value.copyWith(
          text: searchWord,
          selection: TextSelection(
              baseOffset: searchWord.length, extentOffset: searchWord.length),
          composing: TextRange.empty);
    });
    _getUserData();
    _tabController = new TabController(length: 4, vsync: this);
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
                  new Tab(
                    text: TAB_WOOD_TEXT,
                  ),
                  new Tab(text: TAB_SS_TEXT),
                  new Tab(text: TAB_ACCESSORIES_TEXT)
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              )),
          drawer: roles != null
              ? ProfileDrawer(
                  userId: widget.userId,
                  roles: roles,
                  firstName: firstName,
                  lastName: lastName,
                  emailAddress: emailAddress,
                  company: company,
                  phoneNumber: phoneNumber,
                  countryOfResidence: countryOfResidence,
                  cityOfResidence: cityOfResidence,
                )
              : Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 4,
                    color: Colors.transparent,
                    child: Loading(),
                  ),
                ),
          body: !isSearching
              ? TabBarView(
                  children: [
                    _buildPaintWidget(),
                    _buildWoodWiget(),
                    _buildSolidSurfaceWiget(),
                    _buildAccessoriesWiget(),
                  ],
                  controller: _tabController,
                )
              : _buildSearchingTextField()),
    );
  }

  @override
  void dispose() {
    _searchTextField.clear();
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
                controller: _searchTextField,
                onChanged: (value) {
                  setState(() {
                    isTyping = true;
                    searchWord = value;
                    Future.delayed(Duration(milliseconds: 500));
                    _search();
                  });
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
        future: _fetchSearchData(),
        builder: (context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);
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
                          woodProduct = new WoodProduct();
                          solidProduct = new SolidProduct();
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
                                          roles: roles,
                                          paintProducts: paintProducts,
                                        )));
                          } else if (_results[index].data['productType'] ==
                              TAB_WOOD_TEXT) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm(
                                          roles: roles,
                                          woodProduct: woodProduct,
                                        )));
                          } else if (_results[index].data['productType'] ==
                              TAB_ACCESSORIES_TEXT) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm(
                                          roles: roles,
                                          accessoriesProduct:
                                              accessoriesProducts,
                                        )));
                          } else if (_results[index].data['productType'] ==
                              TAB_SS_TEXT) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductForm(
                                          solidProduct: solidProduct,
                                          roles: roles,
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
          paintProducts.itemCode = _results[index].data['itemCode'];
          paintProducts.productName = _results[index].data['productName'];
          paintProducts.productType = _results[index].data['productType'];
          paintProducts.productCategory =
              _results[index].data['productCategory'];
          paintProducts.productBrand = _results[index].data['productBrand'];
          paintProducts.productPrice = _results[index].data['productPrice'];
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
          woodProduct.uid = _results[index].objectID;
          woodProduct.itemCode = _results[index].data['itemCode'];
          woodProduct.productName = _results[index].data['productName'];
          woodProduct.productType = _results[index].data['productType'];
          woodProduct.productCategory = _results[index].data['productCategory'];
          woodProduct.productBrand = _results[index].data['productBrand'];
          woodProduct.productPrice = _results[index].data['productPrice'];
          woodProduct.length = _results[index].data['length'];
          woodProduct.width = _results[index].data['width'];
          woodProduct.thickness = _results[index].data['thickness'];
          woodProduct.color = _results[index].data['color'];
          woodProduct.description = _results[index].data['description'];
          woodProduct.productTags = _results[index].data['tags'];
          woodProduct.imageListUrls = _results[index].data['imageListUrls'];
        }
        break;
      case TAB_SS_TEXT:
        {
          //set all the records of the class
          solidProduct.uid = _results[index].objectID;
          solidProduct.itemCode = _results[index].data['itemCode'];
          solidProduct.productName = _results[index].data['productName'];
          solidProduct.productType = _results[index].data['productType'];
          solidProduct.productCategory =
              _results[index].data['productCategory'];
          solidProduct.productBrand = _results[index].data['productBrand'];
          solidProduct.productPrice = _results[index].data['productPrice'];
          solidProduct.length = _results[index].data['length'];
          solidProduct.width = _results[index].data['width'];
          solidProduct.thickness = _results[index].data['thickness'];
          solidProduct.color = _results[index].data['color'];
          solidProduct.description = _results[index].data['description'];
          solidProduct.productTags = _results[index].data['tags'];
          solidProduct.imageListUrls = _results[index].data['imageListUrls'];
        }
        break;
      case TAB_ACCESSORIES_TEXT:
        {
          //set all the records of the class
          accessoriesProducts.uid = _results[index].objectID;
          accessoriesProducts.itemCode = _results[index].data['itemCode'];
          accessoriesProducts.productName = _results[index].data['productName'];
          accessoriesProducts.productType = _results[index].data['productType'];
          accessoriesProducts.productCategory =
              _results[index].data['productCategory'];
          accessoriesProducts.productBrand =
              _results[index].data['productBrand'];
          accessoriesProducts.productPrice =
              _results[index].data['productPrice'];
          accessoriesProducts.length = _results[index].data['length'];
          accessoriesProducts.angle = _results[index].data['length'];
          accessoriesProducts.closingType = _results[index].data['closingType'];
          accessoriesProducts.color = _results[index].data['color'];
          accessoriesProducts.itemSide = _results[index].data['itemSide'];
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
                  if (roles.isNotEmpty)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductType(
                                productType: COATINGS,
                                brandName: 'SAYERLACK',
                                user: user,
                                roles: roles)));
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
                  if (roles.isNotEmpty)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductType(
                                productType: COATINGS,
                                brandName: 'EVI',
                                user: user,
                                roles: roles)));
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
                  if (roles.isNotEmpty)
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductType(
                                productType: ADHESIVE,
                                brandName: 'UNICOL',
                                user: user,
                                roles: roles)));
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
        children: [
          //FINSA
          Container(
            height: 120.0,
            child: InkWell(
              onTap: () {
                if (roles.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductType(
                              productType: WOOD,
                              brandName: 'FINSA',
                              user: user,
                              roles: roles)));
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(25.0)),
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: Image.asset('assets/images/brands/finsa.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
          //SONAE
          Container(
            height: 120.0,
            child: InkWell(
              onTap: () {
                if (roles.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductType(
                              productType: WOOD,
                              brandName: 'SONEA ARAUCO',
                              user: user,
                              roles: roles)));
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(25.0)),
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: Image.asset('assets/images/brands/sonae.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
          //FORMICA
          Container(
            height: 120.0,
            child: InkWell(
              onTap: () {
                if (roles.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductType(
                              productType: WOOD,
                              brandName: 'FORMICA',
                              user: user,
                              roles: roles)));
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(25.0)),
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: Image.asset('assets/images/brands/formica.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
          //HALSPAN
          Container(
            height: 120.0,
            child: InkWell(
              onTap: () {
                if (roles.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductType(
                              productType: WOOD,
                              brandName: 'HALSPAN',
                              user: user,
                              roles: roles)));
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(25.0)),
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: Image.asset('assets/images/brands/halspan.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenInkWells,
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
        children: [
          //Corian Brand
          Container(
            height: 120.0,
            child: InkWell(
              onTap: () {
                if (roles.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductType(
                              productType: SOLID_SURFACE,
                              brandName: 'CORIAN',
                              user: user,
                              roles: roles)));
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(25.0)),
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: Image.asset('assets/images/brands/corian.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
          //SONAE
          Container(
            height: 120.0,
            child: InkWell(
              onTap: () {
                if (roles.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductType(
                              productType: SOLID_SURFACE,
                              brandName: 'MONTELLI',
                              user: user,
                              roles: roles)));
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(25.0)),
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: Image.asset('assets/images/brands/montelli.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenInkWellLabel,
          ),
        ],
      ),
    );
  }

  //Accessories
  Widget _buildAccessoriesWiget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
      child: Column(
        children: [
          //Salice
          Container(
            height: 120.0,
            child: InkWell(
              onTap: () {
                if (roles.isNotEmpty)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductType(
                              productType: ACCESSORIES,
                              brandName: 'SALICE',
                              user: user,
                              roles: roles)));
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[500]),
                    borderRadius: BorderRadius.circular(25.0)),
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: Image.asset('assets/images/brands/salice.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: distanceBetweenInkWells,
          ),
        ],
      ),
    );
  }
}
