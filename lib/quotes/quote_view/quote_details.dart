import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:Products/shared/constants.dart';
import 'package:number_display/number_display.dart';
import 'package:Products/services/email_management.dart';
import 'package:Products/shared/loading.dart';

class QuoteDetails extends StatefulWidget {
  final String userId;
  final String quoteId;
  final String customerName;
  final String paymentTerms;
  final String status;
  final List selectedProducts;

  const QuoteDetails(
      {Key key,
      this.userId,
      this.quoteId,
      this.customerName,
      this.selectedProducts,
      this.status,
      this.paymentTerms})
      : super(key: key);
  @override
  _QuoteDetailsState createState() => _QuoteDetailsState();
}

class _QuoteDetailsState extends State<QuoteDetails> {
  double _distanceBetweenRows = 15.0;
  double _totalValue;
  String _statusDetails;
  EmailManagement emailManagement = new EmailManagement();

  var display = createDisplay(
    length: 9,
    decimal: 2,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(QUOTE_DETAILS),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _buildQuotationDetails(),
    );
  }

  void initState() {
    _totalValue = _calculateTotalValue();

    super.initState();
  }

  //Calculate the total value of the quotation
  double _calculateTotalValue() {
    var total = 0.0;
    for (int i = 0; i < widget.selectedProducts.length; i++) {
      if (widget.selectedProducts[i]['itemTotal'] != null) {
        total += widget.selectedProducts[i]['itemTotal'];
      }
    }
    return total;
  }

  Widget _buildQuotationDetails() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$CLIENT_NAME: ',
                style: labelTextStyle5,
              ),
              Text(
                widget.customerName ?? '',
                style: labelTextStyle3,
              ),
            ],
          ),
          SizedBox(
            height: _distanceBetweenRows,
          ),
          Row(
            children: [
              Text(
                '$PAYMENT_TERMS: ',
                style: labelTextStyle5,
              ),
              Text(
                widget.paymentTerms ?? '',
                style: labelTextStyle3,
              )
            ],
          ),
          SizedBox(
            height: _distanceBetweenRows * 2,
          ),
          Divider(
            color: Colors.black,
            thickness: 2.0,
          ),
          //Quotation details body titles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1.0))),
                    child: Text(
                      ITEM_CODE,
                      style: labelTextStyle5,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1.0))),
                    child: Text(
                      PRODUCT_NAME,
                      style: labelTextStyle5,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1.0))),
                    child: Text(
                      PRODUCT_PACKAGE,
                      style: labelTextStyle5,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1.0))),
                    child: Text(
                      QUOTE_QUANTITY,
                      style: labelTextStyle5,
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                    child: Container(
                        child: Text(ITEM_PRICE, style: labelTextStyle5)),
                  )),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2.0,
          ),
          SizedBox(
            height: _distanceBetweenRows,
          ),
          //Quotation details body
          Container(
            height: MediaQuery.of(context).size.height - 400.0,
            child: ListView.builder(
              itemCount: widget.selectedProducts.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            widget.selectedProducts[index]['itemCode'] ?? '',
                            style: labelTextStyle3,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            widget.selectedProducts[index]['itemDescription'],
                            style: labelTextStyle3,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            widget.selectedProducts[index]['itemPack']
                                    .toString() ??
                                '',
                            style: labelTextStyle3,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            widget.selectedProducts[index]['quantity']
                                    .toString() ??
                                '',
                            style: labelTextStyle3,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(
                            widget.selectedProducts[index]['price']
                                    .toString() ??
                                '',
                            style: labelTextStyle3,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          //Quotation details bottom
          SizedBox(
            height: _distanceBetweenRows,
          ),
          Divider(
            color: Colors.black,
            thickness: 2.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    TOTAL_ITEMS,
                    style: labelTextStyle5,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    widget.selectedProducts.length.toString(),
                    style: labelTextStyle3,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    TOTAL_VALUE,
                    style: labelTextStyle5,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    '${display(_totalValue)} SR',
                    style: labelTextStyle3,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2.0,
          ),
          Expanded(
              child: FutureBuilder(
            future: _checkColor(widget.status),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: snapshot.data,
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: widget.status != null
                              ? Center(child: Text(widget.status, style: textStyle1))
                              : '',
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: _statusDetails == null
                            ? Loading()
                            : Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(_statusDetails, style: textStyle1,)),
                      ),
                    ],
                  );
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }
              } else if (snapshot.hasError) {
                return snapshot.error;
              }
              return Container();
            },
          ))
        ],
      ),
    );
  }

  //change color depending on status, also return status details
  Future<Color> _checkColor(String status) async {
    //get the status details and update it
    _statusDetails = await _getStatusDetails(status);
    Color currentColor;
    if (status == PENDING) {
      currentColor = Colors.yellow[300];
    } else if (status == WON) {
      currentColor = Colors.green[300];
    } else {
      currentColor = Colors.red[200];
    }

    return currentColor;
  }

  Future<String> _getStatusDetails(String status) async {
    if (status == PENDING) {
      return _statusDetails = 'Status is still pending';
    } else if (status == WON) {
      var result = await emailManagement.quotationCollection
          .document(widget.quoteId)
          .get();

      return _statusDetails = result.data['paidValue'] == null ? 'Value not set' : result.data['paidValue'].toString();
    } else {
      var result = await emailManagement.quotationCollection
          .document(widget.quoteId)
          .get();

      return _statusDetails = result.data['lossReason'] == null ? 'Value not set': result.data['lossReason'];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
