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

class QuotationForm extends StatefulWidget {
  final String userId;
  final List<Clients> clients;
  final List<PaintMaterial> products;
  final Map<String, String> productsWithDescription;
  QuotationForm(
      {this.userId, this.clients, this.products, this.productsWithDescription});
  @override
  _QuotationFormState createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  var _formKey = GlobalKey<FormState>();

  int currentRowNumber = 1;
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
  List<String> itemDescription = [];
  List<double> quantity = [];
  List<double> price = [];
  List<double> pack = [];
  List<Map<String, dynamic>> selectedProducts = new List();
  List<String> itemCodes = new List();
  List<String> productNames = new List();
  //create a temporary list for add price and pack for selected items
  double tempPack;
  double tempPrice;
  //dyanamic widget
  List<Widget> dynamicList = [];

  TextEditingController _clientNameField = TextEditingController();
  TextEditingController _testController = TextEditingController();

  var paintProducts;
  @override
  void initState() {
    super.initState();
    getUserDetails();
    if (selectedProducts.isNotEmpty) {
      selectedProducts = new List();
    }
  }

  //clear the product list if editing was needed
  Future _clearProductListFunction() async {
    if (selectedProducts.isNotEmpty) {
      itemCode.clear();
      itemDescription.clear();
      quantity.clear();
      price.clear();
      pack.clear();
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
      child: emailContainerBuild(),
    );
  }

  emailContainerBuild() {
    var clientEmailAddress = Provider.of<List<Clients>>(context) ?? [];

    if (clientEmailAddress != null) {
      for (var data in clientEmailAddress) {
        print(clientName);
        if (data.clientName == clientName) {
          clientEmail = data.email;
          clientPhone = data.clientPhoneNumber;
          clientId = data.uid;
          print(clientEmail);
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
                    totalValue += quantity[i] * price[i];
                    //get item description
                    String prodName;
                    widget.productsWithDescription.keys.firstWhere((e) {
                      if (e == itemCode[i]) {
                        prodName = widget.productsWithDescription[e];
                        return true;
                      } else
                        return false;
                    }, orElse: () {
                      return null;
                    });
                    selectedProducts.add({
                      'itemCode': itemCode[i],
                      'itemDescription': prodName,
                      'itemPack': pack[i],
                      'quantity': quantity[i],
                      'price': price[i]
                    });
                  }
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuotationReview(
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
                child: TextFormField(
                    initialValue: paymentTerms != null ? paymentTerms : '',
                    style: textStyle1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (val) =>
                        val.isEmpty ? PAYMENT_TERMS_VALIDATION : null,
                    onSaved: (val) {
                      paymentTerms = val;
                    }),
              )
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
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(TOTAL_VALUE, style: textStyle3),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      width: 120.0,
                      height: 50.0,
                      child: Center(
                        child: Text(
                          totalValue == null ? '0.0' : totalValue.toString(),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                ),
              ),
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
      itemDescription = [];
      quantity = [];
      price = [];
      totalValue = 0;
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
      itemDescription = [];
      quantity = [];
      price = [];
      totalValue = 0;
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
                  flex: 2,
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
                        widget.products.forEach((element) {
                          var code = element.itemCode +
                              ' ' +
                              element.productPack.toString();

                          if (code == suggestions) {
                            _priceController.text =
                                element.productPrice.toString();
                            _packController.text =
                                element.productPack.toString();
                          }
                          return true;
                        });
                      },
                      onSaved: (value) {
                        var _itemCode = value.split(' ');
                        itemCode.add(_itemCode[0]);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                //Packing
                Expanded(
                  flex: 1,
                  child: Center(
                    child: TextFormField(
                        controller: _packController,
                        style: textStyle1,
                        decoration: InputDecoration(
                          labelText: ITEM_PACK,
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
                        validator: (val) =>
                            val.isEmpty ? ITEM_PACK_VALIDATION : null,
                        onSaved: (val) {
                          pack.add(double.parse(val));
                        }),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Quantity and price row
          Container(
            width: MediaQuery.of(context).size.width - 10,
            child: Row(
              children: [
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
                        validator: (val) =>
                            val.isEmpty ? ITEM_QUANTITY_VALIDATION : null,
                        onSaved: (val) {
                          quantity.add(double.parse(val));
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
                          price.add(double.parse(val));
                        }),
                  ),
                ),
              ],
            ),
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
    List<String> matches = new List();
    matches.addAll(widget.products
        .map((e) => e.itemCode + ' ' + e.productPack.toString()));
    matches.retainWhere(
        (item) => item.toString().toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  //Get list of suggestions for the clients
  List<String> getClientSuggestions(String query) {
    List<String> matches = new List();
    matches.addAll(widget.clients.map((e) => e.clientName));
    matches.retainWhere((client) =>
        client.toString().toLowerCase().contains(query.toLowerCase()));

    return matches;
  }
}
