import 'dart:async';
import 'dart:typed_data';
import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Products/models/cart_functions.dart';
import 'package:Products/models/products.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/dropdownLists.dart';
import 'package:Products/shared/loading.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:Products/Products/product_validators.dart';

class ProductForm extends StatefulWidget {
  final PaintMaterial paintProducts;
  final WoodProduct woodProduct;
  final SolidProduct solidProduct;
  final Lights lightProduct;
  final Accessories accessoriesProduct;
  final Brands brands;
  final List<dynamic> roles;

  // final bool isAdmin;
  // final bool isPriceAdmin;
  final List<String> cartList;

  ProductForm({
    this.paintProducts,
    this.brands,
    this.woodProduct,
    this.solidProduct,
    this.lightProduct,
    this.accessoriesProduct,
    this.roles,
    // this.isAdmin,
    // this.isPriceAdmin,
    this.cartList,
  });
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  ProductValidators productValidators = new ProductValidators();
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  var productPack;
  var productPrice;
  var productCost;
  String productPackUnit;
  String productDescription;
  List<String> productTags;
  String paintImageUrl;
  var width;
  var length;
  var thickness;
  String dimensions;
  String watt;
  String voltage;
  var angle;
  String closingType;
  String productColor;
  String productImageUrl;
  List<dynamic> imageUrls;
  List<String> _brandList = [];
  String error = 'No Error detected';
  bool loading = false;
  //Options for the accessories tap
  String extensionType;
  String flapStrength;
  String itemSide;
  List<String> _runnersExtension = AccessoriesOptions.extensions();
  List<String> _runnerClosing = AccessoriesOptions.closing();
  List<String> _flapStrength = AccessoriesOptions.flapStrenght();
  List<String> _itemSide = AccessoriesOptions.itemSide();

  ValueNotifier<bool> itemAdded = ValueNotifier<bool>(false);
  bool tagsListChanged = false;
  //check if current image is edited
  bool editCurrentImage = false;
  StringBuffer tags;
  List<dynamic> tagsList = [];
  //Image file
  File image;
  //PDF File variables
  File pdfResult;
  File pdfFile;
  bool loadingPath;
  String pdfFileName;
  //Images file variables
  List<File> images;
  String _imageUrl;
  String _pdfUrl;
  //Firebase store variables
  Firestore fb = Firestore.instance;
  List<dynamic> imageListUrls = [];
  LoadFile currentFile = new LoadFile();
  //holds the type of the product
  List<String> type;
  //holds the category of each type
  List<String> category;
  //hold the paint Images list
  List<List<String>> paintImages;
  //container width
  num containerWidth = 300.0;
  num containerheight = 500.0;
  num dropdownListWidth = 250.0;
  String placeHolderImage = 'assets/images/placeholder.png';
  Future getLoadedImages;
  String zeroValue = '0';
  //Filtering doubles
  RegExp regExp = new RegExp(r'^[a-zA-Z]');
  //will upload new images to the database
  Future getImages(int index) async {
    var tempImage = await ImagePicker().getImage(
        maxHeight: 600.0, maxWidth: 1800.0, source: ImageSource.gallery);
    return tempImage;
  }

  //will edit current images and upload new ones
  Future updateCurrentImages(int index) async {
    var tempImage = await ImagePicker().getImage(
        maxHeight: 600.0, maxWidth: 600.0, source: ImageSource.gallery);
    setState(() {
      if (tempImage != null) {
        editCurrentImage = true;
        imageListUrls[index] = tempImage;
      }
      return tempImage;
    });
  }

  //Will upload a PDF file to the firebase storage
  Future getPdfFiles() async {
    var result;
    try {
      result =
          await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'pdf');
    } on PlatformException catch (e) {
      print('Unsupported operation $e');
    } catch (e) {
      print('Error selecting file: $e');
    }
    if (!mounted) return;
    setState(() {
      if (result != null) {
        pdfResult = result;
      }
    });
  }

  @override
  void initState() {
    _getBrands();
    if (widget.paintProducts != null) {
      itemCode = widget.paintProducts.itemCode;
      productName = widget.paintProducts.productName;
      productBrand = widget.paintProducts.productBrand;
      productType = widget.paintProducts.productType;
      productCategory = widget.paintProducts.productCategory;
      productColor = widget.paintProducts.color;
      productPack = widget.paintProducts.productPack;
      productPackUnit = widget.paintProducts.productPackUnit;
      productPrice = widget.paintProducts.productPrice;
      _pdfUrl = widget.paintProducts.pdfUrl ?? null;
      paintImageUrl = widget.paintProducts.imageLocalUrl;
    } else if (widget.woodProduct != null) {
      productName = widget.woodProduct.productName;
      productBrand = widget.woodProduct.productBrand;
      productType = widget.woodProduct.productType;
      productCategory = widget.woodProduct.productCategory;
      itemCode = widget.woodProduct.itemCode;
      length = widget.woodProduct.length;
      width = widget.woodProduct.width;
      thickness = widget.woodProduct.thickness;
      productColor = widget.woodProduct.color;
      productPrice = widget.woodProduct.productPrice;
      _pdfUrl = widget.woodProduct.pdfUrl ?? null;
      widget.woodProduct.imageListUrls == null
          ? imageListUrls = []
          : imageListUrls =
              new List<dynamic>.from(widget.woodProduct.imageListUrls);
    } else if (widget.solidProduct != null) {
      productName = widget.solidProduct.productName;
      productBrand = widget.solidProduct.productBrand;
      productType = widget.solidProduct.productType;
      productCategory = widget.solidProduct.productCategory;
      itemCode = widget.solidProduct.itemCode;
      length = widget.solidProduct.length;
      width = widget.solidProduct.width;
      thickness = widget.solidProduct.thickness;
      productColor = widget.solidProduct.color;
      productPrice = widget.solidProduct.productPrice;
      _pdfUrl = widget.solidProduct.pdfUrl ?? null;
      widget.solidProduct.imageListUrls == null
          ? imageListUrls = []
          : imageListUrls =
              new List<dynamic>.from(widget.solidProduct.imageListUrls);
    } else if (widget.accessoriesProduct != null) {
      itemCode = widget.accessoriesProduct.itemCode;
      productName = widget.accessoriesProduct.productName;
      productBrand = widget.accessoriesProduct.productBrand;
      productType = widget.accessoriesProduct.productType;
      productCategory = widget.accessoriesProduct.productCategory;
      length = widget.accessoriesProduct.length;
      angle = widget.accessoriesProduct.angle;
      extensionType = widget.accessoriesProduct.extensionType;
      itemSide = widget.accessoriesProduct.itemSide;
      productPrice = widget.accessoriesProduct.productPrice;
      closingType = widget.accessoriesProduct.closingType;
      productColor = widget.accessoriesProduct.color;
      widget.accessoriesProduct.imageListUrls == null
          ? imageListUrls = []
          : imageListUrls =
              new List<dynamic>.from(widget.accessoriesProduct.imageListUrls);
    }
    category = CategoryList.categoryList(productType);
    paintImages = PaintImagesList.paintImagesList();
    type = Type.typeList();
    images = []..length = 5 - imageListUrls.length;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if(widget.products.imageListUrls != null)
    // imageUrls = widget.products.imageListUrls;
  }

  //drop down list menu for division
  List<DropdownMenuItem<Division>> buildDivisionMenu(List divisionList) {
    List<DropdownMenuItem<Division>> items = [];
    for (Division division in divisionList) {
      items.add(DropdownMenuItem(
          value: division,
          child: new Container(
            child: Text(division.divisionName),
            width: dropdownListWidth,
          )));
    }
    return items;
  }

  //get the current brands
  Future _getBrands() async {
    DatabaseService databaseService = DatabaseService();
    await databaseService.brandCollection
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        _brandList.add(element.data['brandName']);
      });
    });
    // _buildMenuList = buildBrandsMenu(_brandList);
    setState(() {});
    return _brandList;
  }

  //Convert tags to a dynamic list
  List<dynamic> _convertTagsToList({List<dynamic> tagsList}) {
    tagsList = [];
    if (tags != null) {
      var splitTags = tags.toString().split(',');
      splitTags.forEach((element) {
        if (element != ' ' && element != ',') tagsList.add(element.trim());
      });
    }
    return tagsList;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(ADD_PRODUCTS),
              backgroundColor: Colors.deepPurpleAccent,
              elevation: 0.0,
            ),
            body: _userAuthorizationLevel());
  }

  //Widget to check user authorization
  Widget _userAuthorizationLevel() {
    if (widget.roles.contains('isAdmin')) {
      return SingleChildScrollView(
        child: new Form(
          key: _formKey,
          child: _buildProductFormAdmin(),
        ),
      );
    } else if (widget.roles.contains('isPriceAdmin')) {
      return SingleChildScrollView(
        child: new Form(
          key: _formKey,
          child: _buildProductFormPriceAdmin(),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: new Container(
          child: _buildProductContainerUser(),
        ),
      );
    }
  }

  //Build the product form for admin users to allow editing
  Widget _buildProductFormAdmin() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: containerWidth,
            alignment: Alignment.bottomLeft,
            child: new DropdownButton<String>(
              isExpanded: true,
              isDense: true,
              value: productType,
              hint: Text(SELECT_PRODUCT_TYPE),
              onChanged: (String val) {
                setState(() {
                  productType = val;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return type.map<Widget>((String item) {
                  return Text(item, style: textStyle1);
                }).toList();
              },
              items: type.map((String item) {
                return DropdownMenuItem<String>(child: Text(item), value: item);
              }).toList(),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          //select different column depending on the product type
          Container(
            child: selectType(),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Select the category of the product
          Container(
            width: containerWidth,
            alignment: Alignment.bottomLeft,
            child: new DropdownButton<String>(
              isExpanded: true,
              isDense: true,
              value: productCategory,
              hint: Text(SELECT_PRODUCT_CATEGORY),
              onChanged: (String val) {
                setState(() {
                  productCategory = val;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return category.map<Widget>((String item) {
                  return Text(item, style: textStyle1);
                }).toList();
              },
              items: category.map((String item) {
                return DropdownMenuItem<String>(child: Text(item), value: item);
              }).toList(),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Image picker from Local images
          Container(
            width: containerWidth,
            alignment: Alignment.bottomLeft,
            child: DropdownButton<dynamic>(
              value: paintImageUrl,
              isExpanded: true,
              isDense: true,
              onChanged: (dynamic val) {
                setState(() {
                  print(val.runtimeType);
                  paintImageUrl = val;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return paintImages.map<Widget>((List<String> imageUrl) {
                  return Text(imageUrl[1] + ' ' + imageUrl[2]);
                }).toList();
              },
              items: paintImages.map((List<String> imageUrl) {
                return DropdownMenuItem(
                    value: imageUrl[0],
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(imageUrl[0]),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(imageUrl[1]),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(imageUrl[2])
                        ],
                      ),
                    ));
              }).toList(),
            ),
          ),
          //Image picker for product images
          Container(
            padding: EdgeInsets.all(8.0),
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return index < imageListUrls.length
                    ? Container(
                        margin: const EdgeInsets.all(4.0),
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(border: Border.all()),
                        child: InkWell(
                          child: !editCurrentImage
                              ? FadeInImage(
                                  fit: BoxFit.contain,
                                  image: CacheImage(imageListUrls[index]),
                                  placeholder: AssetImage(placeHolderImage),
                                  height: 150.0,
                                  width: 150.0,
                                )
                              : Image.file(
                                  imageListUrls[index],
                                  fit: BoxFit.contain,
                                  width: 200.0,
                                  height: 200.0,
                                ),
                          onTap: () async {
                            updateCurrentImages(index);
                          },
                        ),
                      )
                    //image picker for new product images
                    : Container(
                        margin: const EdgeInsets.all(4.0),
                        width: 150,
                        height: 200,
                        decoration: BoxDecoration(border: Border.all()),
                        child: InkWell(
                          child: images[index - imageListUrls.length] == null
                              ? new Icon(Icons.add,
                                  size: 72, color: Colors.grey)
                              : showSelectedImage(index - imageListUrls.length),
                          onTap: () async {
                            getImages(index - imageListUrls.length);
                          },
                        ),
                      );
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          //Show current PDF File Data sheet
          _pdfUrl != null
              ? FlatButton(
                  padding: EdgeInsets.all(15.0),
                  color: Colors.red[200],
                  height: 40.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.black)),
                  child: Text(TDS),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFFileViewer(
                          pdfUrl: _pdfUrl,
                          productName: productName,
                        ),
                      )))
              : SizedBox(),
          //Upload file PDF (Data sheet)
          Container(
            margin: EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            decoration: BoxDecoration(border: Border.all()),
            child: InkWell(
              child: Center(child: Text('Upload PDF')),
              onTap: () async => getPdfFiles(),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          //Uploaded PDF file
          pdfResult != null
              ? Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    pdfResult.toString(),
                    style: textStyle4,
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          //Will validate the current field and save the product edited or added to the database
          RaisedButton(
            color: Colors.amber[400],
            child: Text(SAVE, style: buttonStyle),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                var result;
                DatabaseService databaseService = DatabaseService();
                setState(() {
                  loading = true;
                });
                if (widget.paintProducts == null &&
                    widget.woodProduct == null &&
                    widget.lightProduct == null &&
                    widget.accessoriesProduct == null) {
                  //convert the tags string buffer to list
                  if (tagsListChanged) tagsList = _convertTagsToList();
                  //upload the image
                  await uploadFileImage(images, pdfResult);
                  //add the paint product to the database
                  if (productType == TAB_PAINT_TEXT)
                    result = await databaseService.addPaintProduct(
                        itemCode: itemCode,
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        productPack: productPack,
                        productPrice: productPrice,
                        productPackUnit: productPackUnit,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls,
                        imageLocalUrl: paintImageUrl,
                        pdfUrl: _pdfUrl);
                  //variable for adding a wood product
                  else if (productType == TAB_WOOD_TEXT)
                    result = await databaseService.addWoodProduct(
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        length: length,
                        width: width,
                        thickness: thickness,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls);
                  //variable for adding a solid surface product
                  else if (productType == TAB_SS_TEXT)
                    result = await databaseService.addSolidSurfaceProduct(
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        length: length,
                        width: width,
                        thickness: thickness,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls);
                  //variable for adding a lights products
                  else if (productType == TAB_LIGHT_TEXT)
                    result = await databaseService.addLightsProduct(
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        dimensions: dimensions,
                        watt: watt,
                        voltage: voltage,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls);
                  //variable for adding accessories products
                  else if (productType == TAB_ACCESSORIES_TEXT)
                    result = await databaseService.addAccessoriesProduct(
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        length: length,
                        angle: angle,
                        closingType: closingType,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls);

                  if (result == null) {
                    setState(() {
                      loading = false;
                      error = 'Failed to add this product';
                    });
                  }
                } else {
                  //check if the tag list was edited
                  if (tagsListChanged) tagsList = _convertTagsToList();
                  //check if the image picker was selected
                  await uploadFileImage(images, pdfResult);

                  if (productType == TAB_PAINT_TEXT) {
                    result = await DatabaseService().updatePaintProduct(
                        uid: widget.paintProducts.uid,
                        itemCode: itemCode,
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        productPack: productPack,
                        productPrice: productPrice,
                        productPackUnit: productPackUnit,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls,
                        imageLocalUrl: paintImageUrl,
                        pdfUrl: _pdfUrl);
                  } else if (productType == TAB_WOOD_TEXT)
                    result = await DatabaseService().updateWoodProduct(
                        uid: widget.woodProduct.uid,
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        itemCode: itemCode,
                        length: length,
                        width: width,
                        thickness: thickness,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls);
                  else if (productType == TAB_SS_TEXT)
                    result = await DatabaseService().updateSolidSurfaceProduct(
                        uid: widget.woodProduct.uid,
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        length: length,
                        width: width,
                        thickness: thickness,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls);
                  else if (productType == TAB_LIGHT_TEXT) {
                    result = await DatabaseService().updateLightsProduct(
                        uid: widget.lightProduct.uid,
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        dimensions: dimensions,
                        watt: watt,
                        voltage: voltage,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls);
                  } else if (productType == TAB_ACCESSORIES_TEXT)
                    result = await databaseService.updateAccessoriesProduct(
                        uid: widget.paintProducts.uid,
                        productName: productName,
                        productBrand: productBrand,
                        productType: productType,
                        length: length,
                        angle: angle,
                        closingType: closingType,
                        productCategory: productCategory,
                        color: productColor,
                        imageListUrls: imageListUrls);

                  if (result == null) {
                    setState(() {
                      loading = false;
                      error = 'Failed to update this product';
                    });
                  }
                }
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }

  //Build the product form for price admin users who are capable of changing the price onlu
  Widget _buildProductFormPriceAdmin() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //select different column depending on the product type
          Container(
            child: selectType(),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Set new price
          Container(
            child: TextFormField(
              initialValue: widget.paintProducts.productPrice.toString(),
              decoration: textInputDecoration.copyWith(labelText: 'New Price'),
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val.isEmpty ? 'Price should not be empty' : null,
              onChanged: (val) {
                productPrice = double.parse(val);
              },
            ),
          ),
          //Will validate the current field and save the product edited or added to the database
          RaisedButton(
            color: Colors.amber[400],
            child: Text(UPDATE_PRICE, style: buttonStyle),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                var result;
                DatabaseService databaseService = DatabaseService();
                setState(() {
                  loading = true;
                });
                if (widget.paintProducts != null) {
                  if (productType == TAB_PAINT_TEXT) {
                    result = await databaseService.updatePaintPriceField(
                      uid: widget.paintProducts.uid,
                      productPrice: productPrice,
                    );
                  }

                  if (result == null) {
                    setState(() {
                      loading = false;
                      error = 'Failed to update this product';
                    });
                  }
                }
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }

  //Build the product Container details
  Widget _buildProductContainerUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          selectType(),
        ],
      ),
    );
  }

  //Image upload widget
  Widget showSelectedImage(int index) {
    return Container(
        child: Image.file(
      images[index],
      height: 200.0,
      width: 200.0,
    ));
  }

  //if no image was found an empty container will be returned
  Widget noImageContainer() {
    return Container(
      height: 260.0,
      width: 260.0,
      child: Image.asset('assets/images/no_image.png'),
    );
  }

  //upload the image file to firebase storage
  Future uploadFileImage(List<File> images, File pdfFile) async {
    StorageReference storageReference;
    String folderNameImages;
    String folderNameTDS;
    //select the image folder in Firebase storage depending on product type
    switch (productType) {
      case TAB_PAINT_TEXT:
        folderNameImages = 'paint_image';
        folderNameTDS = 'paint_TDS';
        break;
      case TAB_WOOD_TEXT:
        folderNameImages = 'wood_image';
        break;
      case TAB_SS_TEXT:
        folderNameImages = 'solid_image';
        break;
      case TAB_LIGHT_TEXT:
        folderNameImages = 'lights_image';
        break;
      case TAB_ACCESSORIES_TEXT:
        folderNameImages = 'accessories_image';
        break;
      default:
        folderNameImages = 'unknown_image';
    }
    //check if there's a current image that was edited and upload it to the storage and get the url
    if (editCurrentImage) {
      for (var index = 0; index < imageListUrls.length; index++) {
        if (imageListUrls[index] is File) {
          storageReference = FirebaseStorage.instance.ref().child(
              '$folderNameImages/${Path.basename(imageListUrls[index].path)}');
          StorageUploadTask uploadTask =
              storageReference.putFile(imageListUrls[index]);
          var downloadUrl =
              await (await uploadTask.onComplete).ref.getDownloadURL();
          _imageUrl = downloadUrl.toString();
          imageListUrls.removeAt(index);
          imageListUrls.add(_imageUrl);
        }
      }
      editCurrentImage = false;
    }
    //Save all new images added to the list into firebase storage and get url
    if (images != null)
      for (var image in images) {
        if (image != null) {
          storageReference = FirebaseStorage.instance
              .ref()
              .child('$folderNameImages/${Path.basename(image.path)}');
          StorageUploadTask uploadTask = storageReference.putFile(image);

          var downloadUrl =
              await (await uploadTask.onComplete).ref.getDownloadURL();
          _imageUrl = downloadUrl.toString();
          imageListUrls.add(_imageUrl);
        }
      }

    //save PDF File if file doesn't exist
    if (pdfFile != null) {
      storageReference = FirebaseStorage.instance
          .ref()
          .child('$folderNameTDS/${Path.basename(pdfFile.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(pdfFile);

      var downLoadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      _pdfUrl = downLoadUrl.toString();
    }
  }

  //Future to get image from firebase storage
  // Future<List<Widget>> _getImage(
  //     BuildContext context, List<dynamic> images) async {
  //   List<Image> m;
  //   for (var image in images)
  //     await FireStorageService.loadFromStorage(context, image)
  //         .then((downloadurl) {
  //       m.add(downloadurl);
  //     });

  //   return m;
  // }

  //Widget to select the type of product category
  Widget selectType() {
    switch (productType) {
      case TAB_PAINT_TEXT:
        return _buildPaintWidget();
        break;
      case TAB_WOOD_TEXT:
        return _buildWoodWidget();
        break;
      case TAB_SS_TEXT:
        return _buildSolidWidget();
        break;
      case TAB_LIGHT_TEXT:
        return _buildLightWidget();
        break;
      case TAB_ACCESSORIES_TEXT:
        return _buildAccessoriesWidget();
        break;
      default:
        return null;
    }
  }

//builds the paint widget product details
  Widget _buildPaintWidget() {
    //return product paint form for admin users
    return widget.roles.contains('isAdmin')
        ? Column(
            children: <Widget>[
              //Name field
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue: productName != null ? productName : '',
                  textCapitalization: TextCapitalization.characters,
                  style: textStyle1,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Product Name'),
                  validator: (val) =>
                      val.isEmpty ? 'Product name is required' : null,
                  onChanged: (val) {
                    setState(() {
                      productName = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              //Item Code field
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue: itemCode != null ? itemCode : '',
                  textCapitalization: TextCapitalization.characters,
                  style: textStyle1,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Item Code'),
                  validator: (val) =>
                      val.isEmpty ? 'Item code is required' : null,
                  onChanged: (val) {
                    setState(() {
                      itemCode = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              //Packing field
              Row(
                children: [
                  //Packing quantity
                  Container(
                    width: containerWidth / 2,
                    child: TextFormField(
                      initialValue:
                          productPack != null ? productPack.toString() : '',
                      keyboardType: TextInputType.number,
                      style: textStyle1,
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Product pack'),
                      validator: (val) =>
                          val.isEmpty ? 'Product pack is required' : null,
                      onChanged: (val) {
                        setState(() {
                          productPack = double.parse(val);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  //packing unit
                  Container(
                    width: containerWidth / 2,
                    child: TextFormField(
                      initialValue:
                          productPackUnit != null ? productPackUnit : '',
                      style: textStyle1,
                      decoration: textInputDecoration.copyWith(
                          labelText: 'Product pack unit'),
                      validator: (val) =>
                          val.isEmpty ? 'Product pack is required' : null,
                      onChanged: (val) {
                        setState(() {
                          productPackUnit = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Price field
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue:
                      productPrice != null ? productPrice.toString() : '',
                  keyboardType: TextInputType.number,
                  style: textStyle1,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Product price'),
                  // validator: (val) =>
                  //     val == 0.0 ? 'Product price is required' : 0.0,
                  onChanged: (val) {
                    setState(() {
                      productPrice = double.parse(val);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              //Colour field
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue: productColor != null ? productColor : '',
                  textCapitalization: TextCapitalization.characters,
                  style: textStyle1,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Product colour'),
                  validator: (val) =>
                      val.isEmpty ? 'Product colour is required' : null,
                  onChanged: (val) {
                    setState(() {
                      productColor = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              //Drop down button for brands list
              Container(
                width: containerWidth,
                alignment: Alignment.bottomLeft,
                child: new DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  value: productBrand,
                  hint: Text('Select the product brand'),
                  onChanged: (String val) {
                    setState(() {
                      productBrand = val;
                    });
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return _brandList.map<Widget>((String item) {
                      return Text(item, style: textStyle1);
                    }).toList();
                  },
                  items: _brandList.map((String item) {
                    return DropdownMenuItem<String>(
                        child: Text(item), value: item);
                  }).toList(),
                ),
              ),
            ],
          )
        //Return paint product details for non-admin users
        : Column(
            children: <Widget>[
              paintImageUrl != null
                  //returns the images of the product
                  ? Container(height: 270.0, child: Image.asset(paintImageUrl))
                  : Container(
                      child: noImageContainer(),
                    ),
              SizedBox(
                height: 20.0,
              ),
              //product name field
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_NAME),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(productName != null ? productName : '',
                        style: labelTextStyle2),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Item Code
              itemCode != null ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(ITEM_CODE),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(itemCode, style: labelTextStyle,),
                  )
                ],
              ) : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              //product packing field
              Row(
                children: [
                  Expanded(flex: 2, child: Text(PRODUCT_PACKAGE)),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productPack != null
                          ? '$productPack $productPackUnit'
                          : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //product price
              Row(
                children: [
                  Expanded(flex: 2, child: Text(PRODUCT_PRICE)),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productPack != null ? '$productPrice' : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //product colour
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_COLOUR),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productColor != null ? productColor : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //product brand
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_BRAND),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productBrand != null ? productBrand : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Product Price
               productPrice != null
                  ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(PRODUCT_PRICE),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            productPrice.toString() + ' SR',
                            style: labelTextStyle4,
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              //Show current PDF File Data sheet
              _pdfUrl != null
                  ? FlatButton(
                      padding: EdgeInsets.all(15.0),
                      color: Colors.red[200],
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.black)),
                      child: Text(TDS),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFFileViewer(
                              pdfUrl: _pdfUrl,
                              productName: productName,
                            ),
                          )))
                  : SizedBox(),
            ],
          );
  }

//builds the wood wiget product details
  Widget _buildWoodWidget() {
    return widget.roles.contains('isAdmin')
        ? Column(children: <Widget>[
            Container(
              width: containerWidth,
              child: TextFormField(
                initialValue: productName != null ? productName : '',
                textCapitalization: TextCapitalization.characters,
                style: textStyle1,
                decoration:
                    textInputDecoration.copyWith(labelText: PRODUCT_NAME),
                validator: (val) =>
                    val.isEmpty ? PRODUCT_NAME_VALIDATION : null,
                onChanged: (val) {
                  setState(() {
                    productName = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Item Code field
            Container(
              width: containerWidth,
              child: TextFormField(
                initialValue: itemCode != null ? itemCode : '',
                textCapitalization: TextCapitalization.characters,
                style: textStyle1,
                decoration:
                    textInputDecoration.copyWith(labelText: PRODUCT_CODE),
                validator: (val) =>
                    val.isEmpty ? PRODUCT_CODE_VALIDATION : null,
                onChanged: (val) {
                  setState(() {
                    itemCode = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Product Length
            Container(
              width: containerWidth,
              child: TextFormField(
                initialValue: length != null ? length.toString() : zeroValue,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.deny(regExp)],
                style: textStyle1,
                decoration:
                    textInputDecoration.copyWith(labelText: PRODUCT_LENGHT),
                validator: (val) =>
                    productValidators.productLengthValidator(val),
                onChanged: (val) {
                  setState(() {
                    length = double.parse(val);
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Product Width
            Container(
              width: containerWidth,
              child: TextFormField(
                initialValue: width != null ? width.toString() : zeroValue,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.deny(regExp)],
                style: textStyle1,
                decoration:
                    textInputDecoration.copyWith(labelText: PRODUCT_WIDTH),
                validator: (val) =>
                    productValidators.productWidthValidator(val),
                onChanged: (val) {
                  setState(() {
                    width = double.parse(val);
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Product Thickness
            Container(
              width: containerWidth,
              child: TextFormField(
                initialValue:
                    thickness != null ? thickness.toString() : zeroValue,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.deny(regExp)],
                style: textStyle1,
                decoration:
                    textInputDecoration.copyWith(labelText: PRODUCT_THICKNESS),
                validator: (val) =>
                    productValidators.productThicknessValidator(val),
                onChanged: (val) {
                  setState(() {
                    thickness = double.parse(val);
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              width: containerWidth,
              child: TextFormField(
                initialValue: productColor != null ? productColor : '',
                textCapitalization: TextCapitalization.characters,
                decoration:
                    textInputDecoration.copyWith(labelText: 'Product colour'),
                validator: (val) =>
                    val.isEmpty ? 'Product colour is required' : null,
                onChanged: (val) {
                  setState(() {
                    productColor = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Drop down button for brands list
            Container(
              width: containerWidth,
              alignment: Alignment.bottomLeft,
              child: new DropdownButton<String>(
                isExpanded: true,
                isDense: true,
                value: productBrand,
                hint: Text('Select the product brand'),
                onChanged: (String val) {
                  setState(() {
                    productBrand = val;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return _brandList.map<Widget>((String item) {
                    return Text(item, style: textStyle1);
                  }).toList();
                },
                items: _brandList.map((String item) {
                  return DropdownMenuItem<String>(
                      child: Text(item), value: item);
                }).toList(),
              ),
            ),
          ])
        : Column(
            children: <Widget>[
              //Product Images
              widget.woodProduct.imageListUrls != null
                  ? Container(
                      height: 270,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.woodProduct.imageListUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200])),
                            child: Image(
                              fit: BoxFit.contain,
                              image: CacheImage(
                                  widget.woodProduct.imageListUrls[index]),
                              height: 260.0,
                              width: 260.0,
                            ),
                          );
                        },
                      ))
                  : noImageContainer(),
              SizedBox(
                height: 20.0,
              ),
              //Product Name
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_NAME),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(productName != null ? productName : '',
                        style: labelTextStyle2),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Item Code
              itemCode != null ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(ITEM_CODE),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(itemCode, style: labelTextStyle,),
                  )
                ],
              ) : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              //Product Dimensions
              Row(
                children: [
                  Expanded(flex: 2, child: Text(PRODUCT_PACKAGE)),
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Text(
                            length != null ? length.toString() : '',
                            style: labelTextStyle,
                          ),
                          Text(
                            ' x ',
                            style: labelTextStyle,
                          ),
                          Text(
                            width != null ? width.toString() : '',
                            style: labelTextStyle,
                          ),
                          Text(
                            ' x ',
                            style: labelTextStyle,
                          ),
                          Text(
                            thickness != null ? thickness.toString() : '',
                            style: labelTextStyle,
                          ),
                          Text(
                            'mm',
                            style: labelTextStyle,
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Product Color
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_COLOUR),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productColor != null ? productColor : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Product Brand
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_BRAND),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productBrand != null ? productBrand : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Product Price
               productPrice != null
                  ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(PRODUCT_PRICE),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            productPrice.toString() + ' SR',
                            style: labelTextStyle4,
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              //Product Description
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_DESC),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productDescription != null ? productDescription : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              //Show current PDF File Data sheet
              _pdfUrl != null
                  ? FlatButton(
                      padding: EdgeInsets.all(15.0),
                      color: Colors.red[200],
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.black)),
                      child: Text(TDS),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFFileViewer(
                              pdfUrl: _pdfUrl,
                              productName: productName,
                            ),
                          )))
                  : SizedBox(),
            ],
          );
  }

//builds the solid surface widget product details
  Widget _buildSolidWidget() {
    return widget.roles.contains('isAdmin')
        ? Column(
            children: <Widget>[
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue: productName != null ? productName : '',
                  textCapitalization: TextCapitalization.characters,
                  style: textStyle1,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Product Name'),
                  validator: (val) =>
                      val.isEmpty ? 'Product name is required' : null,
                  onChanged: (val) {
                    setState(() {
                      productName = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                width: containerWidth,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: length != 0.0 ? length.toString() : '',
                        textCapitalization: TextCapitalization.characters,
                        style: textStyle1,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Length'),
                        validator: (val) =>
                            val.isEmpty ? 'Length are required' : null,
                        onChanged: (val) {
                          setState(() {
                            length = double.parse(val);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: width != 0.0 ? width.toString() : '',
                        textCapitalization: TextCapitalization.characters,
                        style: textStyle1,
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Width'),
                        validator: (val) =>
                            val.isEmpty ? 'Width are required' : null,
                        onChanged: (val) {
                          setState(() {
                            width = double.parse(val);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue:
                            thickness != 0.0 ? thickness.toString() : '',
                        textCapitalization: TextCapitalization.characters,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Thickness'),
                        validator: (val) =>
                            val.isEmpty ? 'Thickness are required' : null,
                        onChanged: (val) {
                          setState(() {
                            thickness = double.parse(val);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue: productColor != null ? productColor : '',
                  textCapitalization: TextCapitalization.characters,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Product colour'),
                  validator: (val) =>
                      val.isEmpty ? 'Product colour is required' : null,
                  onChanged: (val) {
                    setState(() {
                      productColor = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              //Drop down button for brands list
              Container(
                width: containerWidth,
                alignment: Alignment.bottomLeft,
                child: new DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  value: productBrand,
                  hint: Text('Select the product brand'),
                  onChanged: (String val) {
                    setState(() {
                      productBrand = val;
                    });
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return _brandList.map<Widget>((String item) {
                      return Text(item, style: textStyle1);
                    }).toList();
                  },
                  items: _brandList.map((String item) {
                    return DropdownMenuItem<String>(
                        child: Text(item), value: item);
                  }).toList(),
                ),
              ),
            ],
          )
        //Non-admin user
        : Column(
            children: <Widget>[
              widget.solidProduct.imageListUrls != null
              //Product Images
                  ? Container(
                      height: 270,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.solidProduct.imageListUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200])),
                            child: Image(
                              fit: BoxFit.contain,
                              image: CacheImage(
                                  widget.solidProduct.imageListUrls[index]),
                              height: 260.0,
                              width: 260.0,
                            ),
                          );
                        },
                      ))
                  : noImageContainer(),
              SizedBox(
                height: 20.0,
              ),
              //Product Name
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_NAME),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(productName != null ? productName : '',
                        style: labelTextStyle2),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Item Code
              itemCode != null ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(ITEM_CODE),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(itemCode, style: labelTextStyle,),
                  )
                ],
              ) : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              //Product Dimensions
              Row(
                children: [
                  Expanded(flex: 2, child: Text(PRODUCT_PACKAGE)),
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Text(
                            length != 0.0 ? length.toString() : '',
                            style: labelTextStyle,
                          ),
                          Text(
                            ' x ',
                            style: labelTextStyle,
                          ),
                          Text(
                            width != 0.0 ? width.toString() : '',
                            style: labelTextStyle,
                          ),
                          Text(
                            ' x ',
                            style: labelTextStyle,
                          ),
                          Text(
                            thickness != 0.0 ? thickness.toString() : '',
                            style: labelTextStyle,
                          ),
                          Text(
                            'mm',
                            style: labelTextStyle,
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Product Color
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_COLOUR),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productColor != null ? productColor : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Product Brand
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_BRAND),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productBrand != null ? productBrand : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Product Price
               productPrice != null
                  ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(PRODUCT_PRICE),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            productPrice.toString() + ' SR',
                            style: labelTextStyle4,
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              //Product Description
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_DESC),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productDescription != null ? productDescription : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Show current PDF File Data sheet
              _pdfUrl != null
                  ? FlatButton(
                      padding: EdgeInsets.all(15.0),
                      color: Colors.red[200],
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.black)),
                      child: Text(TDS),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFFileViewer(
                              pdfUrl: _pdfUrl,
                              productName: productName,
                            ),
                          )))
                  : SizedBox(),
            ],
          );
  }

//builds the lights widget product details
  Widget _buildLightWidget() {
    if (widget.roles.contains('isAdmin')) {
      for (var item in widget.cartList)
        if (!item.contains(widget.lightProduct.uid)) {
          itemAdded.value = false;
        } else {
          itemAdded.value = true;
          break;
        }
    }
    return widget.roles.contains('isAdmin')
        ? Column(
            children: <Widget>[
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue: productName != null ? productName : '',
                  textCapitalization: TextCapitalization.characters,
                  style: textStyle1,
                  decoration:
                      textInputDecoration.copyWith(labelText: PRODUCT_NAME),
                  validator: (val) =>
                      val.isEmpty ? PRODUCT_NAME_VALIDATION : null,
                  onChanged: (val) {
                    setState(() {
                      productName = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue: dimensions != null ? dimensions : '',
                  textCapitalization: TextCapitalization.characters,
                  style: textStyle1,
                  decoration: textInputDecoration.copyWith(
                      labelText: PRODUCT_DIMENSIOS),
                  validator: (val) =>
                      val.isEmpty ? PRODUCT_DIMENSIONS_VALIDATION : null,
                  onChanged: (val) {
                    setState(() {
                      dimensions = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                width: containerWidth,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: watt != null ? watt : '',
                        textCapitalization: TextCapitalization.characters,
                        style: textStyle1,
                        decoration:
                            textInputDecoration.copyWith(labelText: WATT),
                        validator: (val) =>
                            val.isEmpty ? WATT_VALIDATION : null,
                        onChanged: (val) {
                          setState(() {
                            watt = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        initialValue: voltage != null ? voltage : '',
                        textCapitalization: TextCapitalization.characters,
                        decoration:
                            textInputDecoration.copyWith(labelText: VOLTAGE),
                        validator: (val) =>
                            val.isEmpty ? VOLTAGE_VALIDATION : null,
                        onChanged: (val) {
                          setState(() {
                            voltage = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                width: containerWidth,
                child: TextFormField(
                  initialValue: productColor != null ? productColor : '',
                  textCapitalization: TextCapitalization.characters,
                  decoration:
                      textInputDecoration.copyWith(labelText: PRODUCT_COLOUR),
                  validator: (val) =>
                      val.isEmpty ? PRODUCT_COLOUR_VALIDATION : null,
                  onChanged: (val) {
                    setState(() {
                      productColor = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              //Drop down button for brands list
              Container(
                width: containerWidth,
                alignment: Alignment.bottomLeft,
                child: new DropdownButton<String>(
                  isExpanded: true,
                  isDense: true,
                  value: productBrand,
                  hint: Text(SELECT_PRODUCT_BRAND),
                  onChanged: (String val) {
                    setState(() {
                      productBrand = val;
                    });
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return _brandList.map<Widget>((String item) {
                      return Text(item, style: textStyle1);
                    }).toList();
                  },
                  items: _brandList.map((String item) {
                    return DropdownMenuItem<String>(
                        child: Text(item), value: item);
                  }).toList(),
                ),
              ),
            ],
          )
        : Column(
            children: <Widget>[
              widget.lightProduct.imageListUrls != null
                  ? Container(
                      height: 270,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.lightProduct.imageListUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200])),
                            child: Image(
                              fit: BoxFit.contain,
                              image: CacheImage(
                                  widget.lightProduct.imageListUrls[index]),
                              height: 260.0,
                              width: 260.0,
                            ),
                          );
                        },
                      ))
                  : noImageContainer(),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_NAME),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(productName != null ? productName : '',
                        style: labelTextStyle2),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(flex: 2, child: Text(PRODUCT_DIMENSIOS)),
                  Expanded(
                    flex: 3,
                    child: Text(
                      dimensions != null ? dimensions : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(flex: 2, child: Text(WATT)),
                  Expanded(
                    flex: 3,
                    child: Text(
                      watt != null ? watt : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(flex: 2, child: Text(VOLTAGE)),
                  Expanded(
                    flex: 3,
                    child: Text(
                      voltage != null ? voltage : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_COLOUR),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productColor != null ? productColor : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_BRAND),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productBrand != null ? productBrand : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_DESC),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      productDescription != null ? productDescription : '',
                      style: labelTextStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      elevation: 2.0,
                      color: !itemAdded.value
                          ? Colors.green[200]
                          : Colors.red[200],
                      splashColor: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: !itemAdded.value
                          ? Text(ADD_TO_CART)
                          : Text(REMOVE_FROM_CART),
                      onPressed: () async {
                        setState(() {
                          itemAdded.value = !itemAdded.value;
                        });
                        if (itemAdded.value) {
                          //add the item to the cart list if it doesn't already exist.
                          widget.cartList
                              .add('light ${widget.lightProduct.uid}');
                          await currentFile.writeToDocument(widget.cartList);
                          await currentFile.loadDocument();
                        } else {
                          //check if the cart list contains the product
                          //remove the product from the index position, since the item won't match
                          //if the product has quantity added.
                          int index = 0;
                          for (var item = 0;
                              item < widget.cartList.length;
                              item++) {
                            if (widget.cartList[item]
                                .contains(widget.lightProduct.uid)) {
                              index = item;
                              break;
                            }
                          }
                          widget.cartList.removeAt(index);
                          await currentFile.writeToDocument(widget.cartList);
                          await currentFile.loadDocument();
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          );
  }

//builds the accessories widget product details
  Widget _buildAccessoriesWidget() {
    return widget.roles.contains('isAdmin')
        ? Container(
            child: Column(
              children: <Widget>[
                //Product Name
                Container(
                  child: TextFormField(
                    initialValue: productName != null ? productName : '',
                    textCapitalization: TextCapitalization.characters,
                    style: textStyle1,
                    decoration:
                        textInputDecoration.copyWith(labelText: PRODUCT_NAME),
                    validator: (val) =>
                        val.isEmpty ? PRODUCT_NAME_VALIDATION : null,
                    onChanged: (val) {
                      setState(() {
                        productName = val;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                //Item Code field
                Container(
                  child: TextFormField(
                    initialValue: itemCode != null ? itemCode : '',
                    textCapitalization: TextCapitalization.characters,
                    style: textStyle1,
                    decoration:
                        textInputDecoration.copyWith(labelText: PRODUCT_CODE),
                    validator: (val) =>
                        val.isEmpty ? PRODUCT_CODE_VALIDATION : null,
                    onChanged: (val) {
                      setState(() {
                        itemCode = val;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                productCategory != HINGES
                    ? Row(
                        children: [
                          //Product Length
                          productCategory != FLAP
                              ? Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: TextFormField(
                                    initialValue: length != null
                                        ? length.toString()
                                        : zeroValue,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: textStyle1,
                                    decoration: textInputDecoration.copyWith(
                                        labelText: PRODUCT_LENGHT),
                                    onChanged: (val) {
                                      setState(() {
                                        length = double.parse(val);
                                      });
                                    },
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: 6.0,
                          ),
                          productCategory != FLAP
                              ? Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: extensionType,
                                      hint: Text(EXTENSION_TYPE),
                                      onChanged: (String val) {
                                        setState(() {
                                          extensionType = val;
                                        });
                                      },
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return _runnersExtension
                                            .map((item) => Text(
                                                  item,
                                                  style: textStyle1,
                                                ))
                                            .toList();
                                      },
                                      items: _runnersExtension
                                          .map((item) => DropdownMenuItem(
                                                child: Text(item),
                                                value: item,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                )
                              :
                              //Flap strenght mechanism
                              Flexible(
                                  flex: 1,
                                  fit: FlexFit.loose,
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: flapStrength,
                                      hint: Text(FLAP_STENGTH),
                                      onChanged: (String val) {
                                        setState(() {
                                          flapStrength = val;
                                        });
                                      },
                                      selectedItemBuilder:
                                          (BuildContext context) {
                                        return _flapStrength
                                            .map((item) => Text(
                                                  item,
                                                  style: textStyle1,
                                                ))
                                            .toList();
                                      },
                                      items: _flapStrength
                                          .map((item) => DropdownMenuItem(
                                                child: Text(item),
                                                value: item,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Flexible(
                            flex: 1,
                            fit: FlexFit.loose,
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: closingType,
                                hint: Text(CLOSING_TYPE),
                                onChanged: (String val) {
                                  setState(() {
                                    closingType = val;
                                  });
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return _runnerClosing
                                      .map((item) => Text(
                                            item,
                                            style: textStyle1,
                                          ))
                                      .toList();
                                },
                                items: _runnerClosing
                                    .map((item) => DropdownMenuItem(
                                          child: Text(item),
                                          value: item,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          //Product Angle
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue: angle != null
                                        ? angle.toString()
                                        : zeroValue,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(regExp),
                                    ],
                                    style: textStyle1,
                                    decoration: textInputDecoration.copyWith(
                                        labelText: PRODUCT_ANGLE),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val != null)
                                          angle = double.parse(val);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                //Closing type
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue:
                                        closingType != null ? closingType : '',
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: textInputDecoration.copyWith(
                                        labelText: PRODUCT_CLOSING_TYPE),
                                    validator: (val) => val.isEmpty
                                        ? PRODUCT_CLOSING_TYPE_VALIDATION
                                        : null,
                                    onChanged: (val) {
                                      setState(() {
                                        closingType = val;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                SizedBox(
                  height: 15.0,
                ),
                productCategory == HINGES
                    ?
                    //Product Colour
                    Container(
                        child: TextFormField(
                          initialValue:
                              productColor != null ? productColor : '',
                          textCapitalization: TextCapitalization.characters,
                          decoration: textInputDecoration.copyWith(
                              labelText: PRODUCT_COLOUR),
                          validator: (val) =>
                              val.isEmpty ? PRODUCT_COLOUR_VALIDATION : null,
                          onChanged: (val) {
                            setState(() {
                              productColor = val;
                            });
                          },
                        ),
                      )
                    :
                    //Product Side
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: itemSide,
                          hint: Text(ITEM_SIDE),
                          onChanged: (String val) {
                            setState(() {
                              itemSide = val;
                            });
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return _itemSide
                                .map((item) => Text(
                                      item,
                                      style: textStyle1,
                                    ))
                                .toList();
                          },
                          items: _itemSide
                              .map((item) => DropdownMenuItem(
                                    child: Text(item),
                                    value: item,
                                  ))
                              .toList(),
                        ),
                      ),
                SizedBox(
                  height: 15.0,
                ),
                //Price field
                Container(
                  child: TextFormField(
                    initialValue: productPrice != null
                        ? productPrice.toString()
                        : zeroValue,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(regExp),
                    ],
                    style: textStyle1,
                    decoration:
                        textInputDecoration.copyWith(labelText: PRODUCT_PRICE),
                    validator: (val) =>
                        productValidators.productPriceValidator(val),
                    onChanged: (val) {
                      setState(() {
                        productPrice = double.parse(val);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                //Drop down button for brands list
                Container(
                  alignment: Alignment.bottomLeft,
                  child: new DropdownButton<String>(
                    isExpanded: true,
                    isDense: true,
                    value: productBrand,
                    hint: Text(SELECT_PRODUCT_BRAND),
                    onChanged: (String val) {
                      setState(() {
                        productBrand = val;
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return _brandList.map<Widget>((String item) {
                        return Text(item, style: textStyle1);
                      }).toList();
                    },
                    items: _brandList.map((String item) {
                      return DropdownMenuItem<String>(
                          child: Text(item), value: item);
                    }).toList(),
                  ),
                ),
              ],
            ),
          )
          //Non-admin users
        : Column(
            children: <Widget>[
              widget.accessoriesProduct.imageListUrls != null
                  ? Container(
                      height: 270,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            widget.accessoriesProduct.imageListUrls.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[200])),
                            child: Image(
                              fit: BoxFit.contain,
                              image: CacheImage(widget
                                  .accessoriesProduct.imageListUrls[index]),
                              height: 260.0,
                              width: 260.0,
                            ),
                          );
                        },
                      ))
                  : noImageContainer(),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(PRODUCT_NAME),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(productName != null ? productName : '',
                        style: labelTextStyle2),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              //Item Code
              itemCode != null ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(ITEM_CODE),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(itemCode, style: labelTextStyle,),
                  )
                ],
              ) : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              length != null
                  ? Row(
                      children: [
                        Expanded(flex: 2, child: Text(PRODUCT_LENGHT)),
                        Expanded(
                          flex: 3,
                          child: Text(
                            length.toString(),
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              angle != null
                  ? Row(
                      children: [
                        Expanded(flex: 2, child: Text(PRODUCT_ANGLE)),
                        Expanded(
                          flex: 3,
                          child: Text(
                            angle.toString(),
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              productColor != null
                  ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(PRODUCT_COLOUR),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            productColor,
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              productBrand != null
                  ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(PRODUCT_BRAND),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            productBrand,
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              productPrice != null
                  ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(PRODUCT_PRICE),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            productPrice.toString() + ' SR',
                            style: labelTextStyle4,
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              extensionType != null
                  ? Row(children: [
                      Expanded(
                        flex: 2,
                        child: Text(EXTENSION_TYPE),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          extensionType,
                          style: labelTextStyle,
                        ),
                      )
                    ])
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              closingType != null
                  ? Row(children: [
                      Expanded(
                        flex: 2,
                        child: Text(CLOSING_TYPE),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          closingType,
                          style: labelTextStyle,
                        ),
                      )
                    ])
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              itemSide != null
                  ? Row(children: [
                      Expanded(
                        flex: 2,
                        child: Text(ITEM_SIDE),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          itemSide,
                          style: labelTextStyle,
                        ),
                      )
                    ])
                  : SizedBox.shrink(),
              SizedBox(
                height: 15.0,
              ),
              productDescription != null
                  ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(PRODUCT_DESC),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            productDescription != null
                                ? productDescription
                                : '',
                            style: labelTextStyle,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
                SizedBox(
                  height: 15.0,
                ),
                //Show current PDF File Data sheet
              _pdfUrl != null
                  ? FlatButton(
                      padding: EdgeInsets.all(15.0),
                      color: Colors.red[200],
                      height: 40.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.black)),
                      child: Text(TDS),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFFileViewer(
                              pdfUrl: _pdfUrl,
                              productName: productName,
                            ),
                          )))
                  : SizedBox(),
            ],
          );
  }
}

class PDFFileViewer extends StatefulWidget {
  final String pdfUrl;
  final String productName;
  PDFFileViewer({this.pdfUrl, this.productName});
  @override
  _PDFFileViewerState createState() => _PDFFileViewerState();
}

class _PDFFileViewerState extends State<PDFFileViewer> {
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";
  File pdfFile;
  Directory dir;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  bool fileReady = false;
  String fileName;
  String url;
  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
        fileReady = true;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();

    try {
      url = widget.pdfUrl;
      fileName = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      dir = await getApplicationDocumentsDirectory();

      pdfFile = File("${dir.path}/$fileName");
      await pdfFile.writeAsBytes(bytes, flush: true);
      completer.complete(pdfFile);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technical Data Sheet',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            widget.productName,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _sharePage(context, fileName))
          ],
        ),
        body: Center(
          child: fileReady
              ? Builder(
                  builder: (context) {
                    return Stack(
                      children: [
                        PDFView(
                          filePath: remotePDFpath,
                          enableSwipe: true,
                          swipeHorizontal: true,
                          autoSpacing: false,
                          pageFling: true,
                          pageSnap: true,
                          defaultPage: currentPage,
                          fitPolicy: FitPolicy.BOTH,
                          preventLinkNavigation:
                              false, // if set to true the link is handled in flutter
                          onRender: (_pages) {
                            setState(() {
                              pages = _pages;
                              isReady = true;
                            });
                          },
                          onError: (error) {
                            setState(() {
                              print('there is an error 1');
                              errorMessage = error.toString();
                            });
                            print(error.toString());
                          },
                          onPageError: (page, error) {
                            setState(() {
                              print('there is an error 2');
                              errorMessage = '$page: ${error.toString()}';
                            });
                            print('$page: ${error.toString()}');
                          },
                          onViewCreated: (PDFViewController pdfViewController) {
                            _controller.complete(pdfViewController);
                          },
                          onLinkHandler: (String uri) {
                            print('goto uri: $uri');
                          },
                          onPageChanged: (int page, int total) {
                            print('page change: $page/$total');
                            setState(() {
                              currentPage = page;
                            });
                          },
                        ),
                        errorMessage.isEmpty
                            ? !isReady
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container()
                            : Center(
                                child: Text(errorMessage),
                              )
                      ],
                    );
                  },
                )
              : Container(),
        ),
      ),
    );
  }

  _sharePage(BuildContext context, String fileName) async {
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The RaisedButton's RenderObject
    // has its position and size after it's built.
    //final RenderBox box = context.findRenderObject();
    if (url.isNotEmpty) {
      print(url);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      // final ByteData bytes = await rootBundle.load(dir.path);
      await Share.file('TDS', 'TDS.pdf', bytes, 'file/pdf',
          text: 'Optional Text');
    }
  }
}
