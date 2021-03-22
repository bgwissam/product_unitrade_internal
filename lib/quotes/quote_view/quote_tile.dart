import 'package:flutter/material.dart';
import 'package:Products/models/enquiries.dart';
import 'package:Products/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:Products/shared/strings.dart';
import 'quote_details.dart';
import 'package:Products/services/email_management.dart';
import '../../shared/loading.dart';

class QuoteTile extends StatefulWidget {
  final QuoteData quotes;
  QuoteTile({this.quotes});

  @override
  _QuoteTileState createState() => _QuoteTileState();
}

class _QuoteTileState extends State<QuoteTile> {
  EmailManagement products = new EmailManagement();
  String quoteId;
  String userId;
  String clientName;
  String paymentTerms;
  List<double> quantity;
  List<dynamic> itemsSelected;
  List selecteProducts = [];
  double _distanceBetweenRows = 2.0;
  var date;
  bool _isDeleting = false;
  bool _isUpdating = false;
  List<String> _reasonList = [
    'Prices are high',
    'Payment terms',
    'lead time',
    'Quality issue',
    'Others...'
  ];

  void initState() {
    quoteId = widget.quotes.quoteId ?? null;
    userId = widget.quotes.userId ?? null;
    clientName = widget.quotes.clientName ?? null;
    paymentTerms = widget.quotes.paymentTerms ?? null;
    date = widget.quotes.dateTime.toDate() ?? null;
    itemsSelected = widget.quotes.itemQuoted ?? null;

    super.initState();
  }

  //Will map the selected products in the data base and set them to an array lay list.
  Future getSelectedProducts(String id) async {
    //Clear list first
    if (selecteProducts.isNotEmpty) selecteProducts.clear();

    var document = await products.quotationCollection.document(quoteId).get();
    if (document.exists) {
      var items = document.data['itemsQuoted'];
      for (int i = 0; i < items.length; i++) {
        Map<String, dynamic> oneProduct = {};

        var key = items[i].keys;
        for (var val in key) {
          oneProduct[val] = items[i][val];
        }
        selecteProducts.add(oneProduct);
      }
    }
  }

  _getQuoteTotal() {
    double total = 0;
    for (var index in itemsSelected) {
      total += index['itemTotal'];
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    var formatDate = new DateFormat().add_yMMMd().format(date);
    var totalItem = widget.quotes.itemQuoted.length;
    var totalValue = _getQuoteTotal();
    var status = widget.quotes.status;

    return _isDeleting
        ? Loading()
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () async {
                await getSelectedProducts(quoteId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuoteDetails(
                      userId: userId,
                      quoteId: quoteId,
                      customerName: clientName,
                      paymentTerms: paymentTerms,
                      status: status,
                      selectedProducts: selecteProducts,
                    ),
                  ),
                );
              },
              child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(width: 2)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '$CLIENT_NAME: ',
                                style: labelTextStyle5,
                              ),
                              Text(
                                clientName,
                                style: labelTextStyle3,
                              )
                            ],
                          ),
                          SizedBox(
                            height: _distanceBetweenRows,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '$QUOTE_DATE: ',
                                style: labelTextStyle5,
                              ),
                              Text(
                                formatDate,
                                style: labelTextStyle3,
                              )
                            ],
                          ),
                          SizedBox(
                            height: _distanceBetweenRows,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('$TOTAL_ITEMS: ', style: labelTextStyle5),
                              Text(
                                totalItem.toString(),
                                style: labelTextStyle3,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '$TOTAL_VALUE: ',
                                style: labelTextStyle5,
                              ),
                              Text(
                                totalValue.toString(),
                                style: labelTextStyle3,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                status == 'Pending'
                                    ? Row(
                                        children: [
                                          TextButton(
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.green),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  25.0),
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .green)))),
                                              child: Text(WON),
                                              onPressed: () async {
                                                return FutureBuilder(
                                                  future: _updateStatus(
                                                      status: WON,
                                                      total: totalValue),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting)
                                                        return Loading();
                                                      else if (snapshot
                                                              .connectionState ==
                                                          ConnectionState.done)
                                                        return Container(
                                                          child: Text(WON),
                                                        );
                                                      else
                                                        return Container(
                                                          child: Text(WON),
                                                        );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Container(
                                                        child: Text(
                                                            snapshot.error),
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  },
                                                );
                                              }),
                                          TextButton(
                                            style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.red),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.0),
                                                        side: BorderSide(
                                                            color:
                                                                Colors.red)))),
                                            child: Text(LOST),
                                            onPressed: () async {
                                              await _updateStatus(status: LOST);
                                            },
                                          )
                                        ],
                                      )
                                    : Container(
                                        width: 100.0,
                                        child: Center(child: Text(status)),
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            color: status == WON
                                                ? Colors.green[400]
                                                : Colors.red[400]),
                                      ),
                                SizedBox(
                                  width: 60.0,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(DELETE_QUOTE),
                                              content:
                                                  Text(DELETE_QUOTE_CONTENT),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      setState(() {
                                                        _isDeleting = true;
                                                      });
                                                      var result =
                                                          await products
                                                              .deleteQuoteById(
                                                                  quoteId);
                                                      print(result);
                                                      if (result != null) {
                                                        setState(() {
                                                          _isDeleting = false;
                                                        });
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(ALERT_YES)),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(ALERT_NO),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurpleAccent,
                                    ),
                                    child: Text(DELETE_QUOTE))
                              ],
                            ),
                          ),
                        ]),
                  )),
            ),
          );
  }

  //updates the status of the quotation whether won or lost
  Future _updateStatus({String status, double total}) async {
    double actualValue;
    String reason;
    if (status == WON) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(UPDATE_STATUS),
              content: Container(
                height: MediaQuery.of(context).size.height / 6,
                child: Column(children: [
                  Container(
                    child: Text(UPDATE_STATUS_CONTENT),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    initialValue: '',
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration:
                        textInputDecoration.copyWith(labelText: QUOTE_VALUE),
                    onChanged: (val) {
                      actualValue = double.parse(val);
                    },
                  ),
                ]),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        _isUpdating = true;
                      });
                      if (actualValue == null) {
                        actualValue = total;
                      }
                      var result = await products.updateQuoteStatus(
                          uid: quoteId, status: status, paidValue: actualValue);
                      print(result);
                      if (result != null) {
                        setState(() {
                          _isUpdating = false;
                        });
                      }
                      Navigator.pop(context);
                      _isUpdating = false;
                    },
                    child: Text(ALERT_YES)),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(ALERT_NO),
                )
              ],
            );
          });
    } else {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text(UPDATE_STATUS),
                content: Container(
                  height: MediaQuery.of(context).size.height / 6,
                  child: Column(children: [
                    Container(
                      child: Text(UPDATE_STATUS_CONTENT),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      child: new DropdownButton<String>(
                        isExpanded: true,
                        isDense: true,
                        value: reason,
                        hint: Text(LOST_REASON),
                        onChanged: (String val) {
                          setState(() {
                            reason = val;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return _reasonList.map<Widget>((String item) {
                            return Text(
                              item,
                              style: textStyle1,
                            );
                          }).toList();
                        },
                        items: _reasonList.map((String item) {
                          return DropdownMenuItem<String>(
                              child: Text(item), value: item);
                        }).toList(),
                      ),
                    )
                  ]),
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          _isUpdating = true;
                        });
                        var result = await products.updateQuoteStatus(
                            uid: quoteId, status: status, reason: reason);
                        if (result != null) {
                          setState(() {
                            _isUpdating = false;
                          });
                        }
                        Navigator.pop(context);
                      },
                      child: Text(ALERT_YES)),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text(ALERT_NO),
                  )
                ],
              );
            });
          });
    }
  }
}
