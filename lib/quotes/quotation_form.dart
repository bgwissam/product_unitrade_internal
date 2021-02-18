import 'package:Products/models/clients.dart';
import 'package:Products/models/products.dart';
import 'package:Products/quotes/quotation_review.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:Products/shared/dropdownLists.dart';

class QuotationForm extends StatefulWidget {
  final String userId;

  final List<double> quantity;
  final List<Clients> clients;
  final List<PaintMaterial> paintProducts;
  final List<WoodProduct> woodProducts;
  final List<SolidProduct> solidProducts;
  final List<Accessories> accessoriesProducts;

  final int numberOfProduct;

  final Map<String, String> productsWithDescription;
  QuotationForm(
      {this.userId,
      this.quantity,
      this.clients,
      this.paintProducts,
      this.woodProducts,
      this.solidProducts,
      this.accessoriesProducts,
      this.productsWithDescription,
      this.numberOfProduct});
  @override
  _QuotationFormState createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  var _formKey = GlobalKey<FormState>();

  int currentRowNumber = 1;
  //An email for the sales coordinator
  String salesCoordinatorEmailAddress = 'joel.linatoc@nesma.com';
  String clientName = '';
  String clientEmail;
  String clientPhone;
  String clientId;
  String paymentTerms;
  double totalValue;
  int rows = 0;
  int index = 0;
  //User information
  String name;
  String phoneNumber;
  String emailAddress;
  String userId;
  //Quotation item variables
  List<String> itemCode = [];
  List<String> productName = [];
  List<String> itemDescription = [];
  List<double> quantity = [];
  List<double> price = [];
  List<String> pack = [];
  List<int> discount = [];
  List<double> itemTotal = [];
  List<Map<String, dynamic>> selectedProducts = [];
  List<String> itemCodes = [];
  //create a temporary list for add price and pack for selected items
  double tempPack;
  double tempPrice;
  //dyanamic widget
  List<Widget> dynamicList = [];
  //Payment terms drop down list
  List<String> _paymentTerms = PaymentTerms.terms();

  TextEditingController _clientNameField = TextEditingController();

  var paintProducts;
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  //clear the product list if editing was needed
  Future _clearProductListFunction() async {
    if (selectedProducts.isNotEmpty) {
      itemCode.clear();
      itemDescription.clear();
      quantity.clear();
      price.clear();
      pack.clear();
      itemTotal.clear();
      selectedProducts.clear();
    }
  }

  //Get user details
  Future getUserDetails() async {
    if (widget.userId != null) {
      await DatabaseService()
          .unitradeCollection
          .document(widget.userId)
          .get()
          .then((value) {
        name = value.data['firstName'] + ' ' + value.data['lastName'];
        phoneNumber = value.data['phoneNumber'];
        emailAddress = value.data['emailAddress'];
      });
    }
    return;
  }

  //Build stream for selected client
  _getEmailAddress(String name) {
    return StreamProvider<List<Clients>>.value(
      value: DatabaseService().clientEmailByName(name: name),
      child: emailContainerBuild(name),
    );
  }

  emailContainerBuild(String name) {
    var clientEmailAddress = Provider.of<List<Clients>>(context) ?? [];
    if (clientEmailAddress != null) {
      for (var data in clientEmailAddress) {
        if (data.clientName == name) {
          clientEmail = data.email;
          clientPhone = data.clientPhoneNumber;
          clientId = data.uid;
          paymentTerms = data.paymentTerms;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(QUOTATION_FORM),
        backgroundColor: Colors.blueGrey[500],
        actions: [
          FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                totalValue = 0;
                setState(() {
                  for (var i = 0; i < itemCode.length; i++) {
                    totalValue += itemTotal[i];

                    selectedProducts.add({
                      'itemCode': itemCode[i],
                      'itemDescription': productName[i],
                      'itemPack': pack[i],
                      'quantity': quantity[i],
                      'price': price[i],
                      'itemTotal': itemTotal[i],
                    });
                  }
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuotationReview(
                              salesCordinator: salesCoordinatorEmailAddress,
                              customerName: clientName,
                              customerEmail: clientEmail,
                              customerPhone: clientPhone,
                              clientId: clientId,
                              paymentTerms: paymentTerms,
                              products: selectedProducts,
                              clearProductList: _clearProductListFunction,
                              totalValue: totalValue,
                              name: name,
                              phone: phoneNumber,
                              supplierEmail: emailAddress,
                              userId: widget.userId,
                            )));
              }
            },
            disabledColor: Colors.grey,
            splashColor: Colors.lightBlue,
            child: Text(
              NEXT_PAGE,
              style: textStyle9,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Form(
          key: _formKey,
          child: _quotationDetails(context),
        ),
      ),
    );
  }

  Widget _quotationDetails(BuildContext context) {
    //dynamic list to add more rows
    Widget dynamicRow = new Container(
      child: new ListView.builder(
        itemCount: dynamicList.length,
        itemBuilder: (_, index) => dynamicList[index],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Client name row
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(CLIENT_NAME),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _clientNameField,
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                    ),
                    keepSuggestionsOnLoading: true,
                    errorBuilder: (context, err) {
                      return Container(
                        child: Text(err),
                      );
                    },
                    suggestionsCallback: (pattern) async {
                      return getClientSuggestions(pattern);
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    autoFlipDirection: true,
                    onSuggestionSelected: (suggestions) {
                      _getEmailAddress(suggestions);
                      _clientNameField.text = suggestions;
                      clientName = suggestions;
                    },
                    validator: (val) {
                      return val.isEmpty ? CLIENT_NAME_VALIDATION : null;
                    },
                    onSaved: (value) {
                      clientName = value;
                    },
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          //Payment terms row
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(PAYMENT_TERMS),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    border: Border.all(width: 1.0, color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: paymentTerms,
                      hint: Center(
                        child: Text(
                          PAYMENT_TERMS,
                        ),
                      ),
                      onChanged: (String val) {
                        setState(() {
                          paymentTerms = val;
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return _paymentTerms
                            .map<Widget>(
                              (item) => Center(
                                child: Text(
                                  item,
                                  style: textStyle1,
                                ),
                              ),
                            )
                            .toList();
                      },
                      items: _paymentTerms
                          .map((item) => DropdownMenuItem<String>(
                                child: Center(child: Text(item)),
                                value: item,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 310,
            child: dynamicRow,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: FloatingActionButton(
                        heroTag: 'btn1',
                        child: Icon(Icons.add),
                        backgroundColor: Colors.teal,
                        onPressed: () {
                          setState(() {
                            _addTableRow();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      child: FloatingActionButton(
                        heroTag: 'btn2',
                        child: Icon(Icons.remove),
                        backgroundColor: Colors.red,
                        onPressed: () {
                          setState(() {
                            _removeTableRow();
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  //add a row to the product list
  void _addTableRow() {
    if (itemCode.length != 0) {
      itemCode = [];
      productName = [];
      itemDescription = [];
      quantity = [];
      price = [];
    }
    //product list shouldn't be more than 20 items
    if (dynamicList.length < 20) {
      index++;
      dynamicList.add(buildRows(context));
    }
  }

  //remove a row from the product list, such that at least 1 row should remain
  void _removeTableRow() {
    if (itemCode.length != 0) {
      itemCode = [];
      productName = [];
      itemDescription = [];
      quantity = [];
      price = [];
    }

    if (dynamicList.length > 1) {
      index--;
      dynamicList.removeLast();
    }
  }

  //Build row dynamically
  Widget buildRows(BuildContext context) {
    //Stream the list of products
    //TextEditing controllers for itemCode, pack, and price, to show both pack and price when selection is made
    TextEditingController _typeAheadController = TextEditingController();
    TextEditingController _packController = TextEditingController();
    TextEditingController _priceController = TextEditingController();
    TextEditingController _itemTotal = TextEditingController();
    double _quantity, _price, _originalPrice, _discount = 0;
    //calculate total per each item
    _itemTotalValue() {
      var tValue = 0.0;
      if (_quantity != null && _price != null) {
        tValue = _quantity * (_price - (_price * (_discount / 100)));
      }
      _itemTotal.text = tValue.toString();
      if (_discount != null && _quantity != null) {
        _priceController.text =
            (_price - (_price * (_discount / 100))).toString();
        print(
            'The _price: $_price and _priceController: ${_priceController.text}');
      }
    }

    //set listener on the field that will affect the item total
    _itemTotal.addListener(_itemTotalValue);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Column(children: [
          //Item code and pack row
          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              children: [
                //Code
                Expanded(
                  flex: 1,
                  child: Center(
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _typeAheadController,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: ITEM_CODE,
                          filled: true,
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                      ),
                      direction: AxisDirection.up,
                      suggestionsCallback: (pattern) async {
                        return getSuggestions(pattern);
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      autoFlipDirection: true,
                      onSuggestionSelected: (suggestions) {
                        _typeAheadController.text = suggestions;
                        //get the pack and price for each item
                        var selecteItem = suggestions.split('|');
                        switch (selecteItem[0].trim()) {
                          //Get the details of the paint product selected item
                          case COATINGS:
                            DatabaseService()
                                .paintProductbyItemCode(selecteItem[1].trim())
                                .forEach((data) {
                              data.indexWhere((element) {
                                if (element.productPack.toString() ==
                                    selecteItem[3].toString().trim()) {
                                  setState(() {
                                    _priceController.text =
                                        element.productPrice.toString();
                                    _packController.text =
                                        element.productPack.toString();
                                    _originalPrice =
                                        double.parse(_priceController.text);
                                  });
                                  return true;
                                } else {
                                  print('No matching element');
                                  return false;
                                }
                              });
                            });
                            break;
                          //Get the details of the wood product selected item
                          case WOOD:
                            DatabaseService()
                                .woodProductbyItemCode(selecteItem[1].trim())
                                .forEach((data) {
                              data.indexWhere((element) {
                                if (element.itemCode == selecteItem[1].trim()) {
                                  var dimensions =
                                      '${element.length}x${element.width}x${element.thickness}';
                                  if (dimensions.isEmpty)
                                    dimensions = 'No Pack';
                                  setState(() {
                                    _priceController.text =
                                        element.productPrice.toString();
                                    _packController.text =
                                        dimensions.toString();
                                    _originalPrice =
                                        double.parse(_priceController.text);
                                  });
                                  return true;
                                }
                                return false;
                              });
                            });
                            break;
                          //Get the details of the solid suraface selected item
                          case SOLID_SURFACE:
                            DatabaseService()
                                .solidSurfaceProductbyItemCode(
                                    selecteItem[1].trim())
                                .forEach((data) {
                              data.indexWhere((element) {
                                if (element.itemCode == selecteItem[1].trim()) {
                                  var dimensions;
                                  if (element.length == null) {
                                    dimensions = '${element.productPack} ml';
                                  } else {
                                    dimensions =
                                        '${element.length}x${element.width}x${element.thickness}';
                                  }

                                  if (dimensions.isEmpty)
                                    dimensions = 'No Pack';
                                  setState(() {
                                    _priceController.text =
                                        element.productPrice.toString();
                                    _packController.text =
                                        dimensions.toString();
                                    _originalPrice =
                                        double.parse(_priceController.text);
                                  });

                                  return true;
                                }

                                return false;
                              });
                            });
                            break;
                          //Get details for the selected product in accessories
                          case ACCESSORIES:
                            DatabaseService()
                                .accessoriesProductbyItemCode(
                                    selecteItem[1].trim())
                                .forEach((data) {
                              data.indexWhere((element) {
                                if (element.itemCode == selecteItem[1].trim()) {
                                  var dimensions = new StringBuffer();
                                  if (element.length != null)
                                    dimensions.write(element.length.toString());
                                  if (element.angle != null) {
                                    if (dimensions.isNotEmpty)
                                      dimensions.write('-');
                                    dimensions.write(element.angle.toString());
                                  }

                                  if (element.extensionType != null) {
                                    if (dimensions.isNotEmpty)
                                      dimensions.write('-');
                                    dimensions.write(
                                        element.extensionType.toString());
                                  }

                                  if (dimensions.isEmpty) {
                                    dimensions.write('No Pack');
                                  }

                                  setState(() {
                                    _priceController.text =
                                        element.productPrice.toString();
                                    _packController.text =
                                        dimensions.toString();
                                    _originalPrice =
                                        double.parse(_priceController.text);
                                  });
                                  return true;
                                }
                                return false;
                              });
                            });
                            break;
                        }
                      },
                      onSaved: (value) {
                        var _itemCode = value.split(' | ');
                        itemCode.add(_itemCode[1]);
                        productName.add(_itemCode[2]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Quantity, pack and price row
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Row(
              children: [
                //Packing
                Expanded(
                  flex: 1,
                  child: Center(
                    child: TextFormField(
                        controller: _packController,
                        enabled: false,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: ITEM_PACK,
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                        validator: (val) =>
                            val.isEmpty ? ITEM_PACK_VALIDATION : null,
                        onSaved: (val) {
                          pack.add(val);
                        }),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                //Quantity
                Expanded(
                  flex: 1,
                  child: Center(
                    child: TextFormField(
                        initialValue: '',
                        style: textStyle1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: ITEM_QUANTITY,
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                        onChanged: (val) {
                          _quantity = double.tryParse(val);

                          _priceController.text != ''
                              ? _price = _originalPrice
                              : _price = 0;
                          _itemTotalValue();
                        },
                        validator: (val) =>
                            val.isEmpty ? ITEM_QUANTITY_VALIDATION : null,
                        onSaved: (val) {
                          quantity.add(double.tryParse(val));
                        }),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                //Price
                Expanded(
                  flex: 1,
                  child: Center(
                    child: TextFormField(
                        controller: _priceController,
                        style: textStyle1,
                        enabled: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: ITEM_PRICE,
                          fillColor: Colors.grey[100],
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                        validator: (val) =>
                            val.isEmpty ? ITEM_PRICE_VALIDATION : null,
                        onSaved: (val) {
                          price.add(double.tryParse(val));
                        }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Discount field
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: TextFormField(
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[1-5]"))
                      ],
                      initialValue: '',
                      style: textStyle1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: DISCOUNT_RATE,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      onChanged: (val) {
                        val != ''
                            ? _discount = double.tryParse(val)
                            : _discount = 0;
                        _itemTotalValue();
                      },
                      onSaved: (val) {
                        _discount > 0
                            ? discount.add(int.tryParse(val))
                            : discount.add(0);
                      }),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                  flex: 1, child: Center(child: Text('%', style: textStyle1))),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: TextFormField(
                      controller: _itemTotal,
                      style: textStyle1,
                      enabled: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: ITEM_TOTAL,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      onSaved: (val) {
                        itemTotal.add(double.tryParse(val));
                      }),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    //clear controllers
    super.dispose();
  }

  //Get list of suggestions for the product list
  List<String> getSuggestions(String query) {
    List<String> matches = [];
    //Adding paint product to the input list
    matches.addAll(widget.paintProducts.map((e) =>
        COATINGS + ' | ${e.itemCode} | ${e.productName} | ${e.productPack}'));

    //Adding wood products to the input list
    matches.addAll(widget.woodProducts.map((e) =>
        WOOD +
        ' | ${e.itemCode} | ${e.productName} | ${e.length}x${e.width}x${e.thickness}'));
    //Adding solid surface products to the input list
    matches.addAll(widget.solidProducts.map((e) {
      var solidPacking;
      if (e.length == null) {
        solidPacking = '${e.productPack} ml';
      } else {
        solidPacking = '${e.length}x${e.width}x${e.thickness}';
      }

      return SOLID_SURFACE +
          ' | ${e.itemCode} | ${e.productName} | $solidPacking';
    }));
    //Adding accessories to the input list
    matches.addAll(widget.accessoriesProducts.map((e) =>
        ACCESSORIES +
        ' | ${e.itemCode} | ${e.productName} | ${e.length ?? ''} ${e.angle ?? ''} ${e.extensionType ?? ''}'));

    matches.retainWhere(
        (item) => item.toString().toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  //Get list of suggestions for the clients
  List<String> getClientSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(widget.clients.map((e) => e.clientName));
    matches.retainWhere((client) =>
        client.toString().toLowerCase().contains(query.toLowerCase()));

    return matches;
  }
}
