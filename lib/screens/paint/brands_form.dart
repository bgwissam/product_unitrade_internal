import 'dart:collection';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:Products/models/products.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/dropdownLists.dart';
import 'package:Products/shared/loading.dart';
import 'package:Products/shared/strings.dart';

class BrandsForm extends StatefulWidget {
  Brands brand;
  BrandsForm({this.brand});
  @override
  _BrandsFormState createState() => _BrandsFormState();
}

class _BrandsFormState extends State<BrandsForm> {
  final _formKey = GlobalKey<FormState>();
  String brandName;
  String countryOfOrigin;
  String currentImageUrl;
  Division _division;
  String divisionStr;
  Map<String, String> categoryStr = new HashMap();
  List<dynamic> category;
  String divisionType;
  List<Division> _divisionList = Division.getDivision();
  List<DropdownMenuItem<Division>> _buildDivisionList;
  bool loading = false;
  String error;
  //A string buffer to hold added or edited categories
  StringBuffer categories;
  //container width
  num containerWidth = 300.0;
  num dropdownListWidth = 250.0;
  //file name
  File image;
  String _imageUrl;
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(
        maxHeight: 600.0, maxWidth: 1800.0, source: ImageSource.gallery);

    setState(() {
      image = tempImage;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.brand != null) {
      brandName = widget.brand.brand;
      countryOfOrigin = widget.brand.countryOrigin;
      currentImageUrl = widget.brand.image;
      category = widget.brand.category;
    } else {
      category = [];
    }
    _buildDivisionList = buildDivisionMenu(_divisionList);
  }

  //displays the category list in a string
  StringBuffer _displayCategoryList() {
    var categoryString = StringBuffer();

    if (category.length > 0) {
      category.forEach((element) {
        categoryString.write('$element, ');
      });
    }
    return categoryString;
  }
  //sets the list of strings into a list of categories
  StringBuffer _setCategoryList(String categoryString) {
    categories = StringBuffer();
    if(categoryString != null){
      categories.write(categoryString);
    }
    return categories;
  }

  //Convert the string buffer to List<String>
  List<dynamic> _convertCategoryToList() {
    category = [];
    if(categories != null){
      var spliCategories = categories.toString().split(',');
      spliCategories.forEach((element) {
        if(element != ' ' || element != ',')
          category.add(element);
      });
    }
    return category;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(ADD_BRAND),
              backgroundColor: Colors.amber[400],
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: new Form(
                key: _formKey,
                child: _buildBrandForm(),
              ),
            ));
  }

  Widget _buildBrandForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: containerWidth,
            child: TextFormField(
              initialValue: brandName != null ? brandName : '',
              textCapitalization: TextCapitalization.characters,
              decoration: textInputDecoration.copyWith(labelText: 'Brand Name'),
              validator: (val) => val.isEmpty ? 'Brand name is required' : null,
              onChanged: (val) {
                setState(() {
                  brandName = val;
                });
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: containerWidth,
            child: TextFormField(
              initialValue: countryOfOrigin != null ? countryOfOrigin : null,
              textCapitalization: TextCapitalization.characters,
              decoration:
                  textInputDecoration.copyWith(labelText: 'Country of Origin'),
              validator: (val) =>
                  val.isEmpty ? 'Country of origin is required' : null,
              onChanged: (val) {
                setState(() {
                  countryOfOrigin = val;
                });
              },
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Set division of Brands
          Container(
            width: containerWidth,
            alignment: Alignment.center,
            child: new DropdownButton(
              items: _buildDivisionList,
              value: _division,
              onChanged: (Division val) {
                setState(() {
                  _division = val;
                  divisionStr = val.divisionName;
                });
              },
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Set categories
          Container(
            width: containerWidth,
            child: TextFormField(
              initialValue:
                  category.length == 0 ? null : _displayCategoryList().toString(),
              textCapitalization: TextCapitalization.characters,
              decoration: textInputDecoration.copyWith(
                  labelText: 'Categories',
                  hintText: 'Use a comma for more than one category'),
              validator: (val) =>
                  val.isEmpty ? 'Categories are required' : null,
              onChanged: (val) {
                setState(() {
                  _setCategoryList(val);
                });
              },
            ),
          ),
          //Check if there's a current image
          Container(
            child:
                currentImageUrl == null ? null : Image.network(currentImageUrl),
          ),
          //Add brand image
          SizedBox(
            height: 15.0,
          ),

          Container(
            child: image == null ? Text('Select an image') : enableUpload(),
          ),
          RaisedButton(
            onPressed: getImage,
            child: new Icon(Icons.add),
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            color: Colors.amber[400],
            child: Text('Save', style: buttonStyle),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                setState(() {
                  loading = true;
                });
                if (widget.brand == null) {
                  category = _convertCategoryToList();
                  await uploadFileImage(image);
                  dynamic result = await DatabaseService().addBrandData(
                      brandName: brandName,
                      countryOfOrigin: countryOfOrigin,
                      category: category,
                      division: divisionStr,
                      imageUrl: _imageUrl);
                  if (result == null) {
                    setState(() {
                      loading = false;
                      error = 'Failed to add this brand';
                    });
                  }
                } else {
                  await uploadFileImage(image);
                  dynamic result = await DatabaseService().updateBrandData(
                      uid: widget.brand.uid,
                      brandName: brandName,
                      countryOfOrigin: countryOfOrigin,
                      category: category,
                      division: divisionStr,
                      imageUrl: _imageUrl);
                  if (result == null) {
                    setState(() {
                      loading = false;
                      error = 'Failed to update this brand';
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

  //dropdownlist menu for caregory
  List<DropdownMenuItem<Category>> buildCategoryMenu(List categoryList) {
    List<DropdownMenuItem<Category>> items = [];
    for (Category category in categoryList) {
      if (divisionType == category.divisionName) {
        items.add(DropdownMenuItem(
          value: category,
          child: new Container(
            child: Text(category.categoryName),
            width: dropdownListWidth,
          ),
        ));
      }
    }
    return items;
  }

  //File upload widget
  Widget enableUpload() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Image.file(image, height: 80.0, width: 300.0),
          ],
        ),
      ),
    );
  }

  //upload the image file to firebase storage
  Future uploadFileImage(File image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('http://image/${Path.basename(image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(image);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    _imageUrl = downloadUrl.toString();
  }
}
