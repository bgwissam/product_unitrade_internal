import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:Products/shared/constants.dart';

class QuoteDetails extends StatefulWidget {
  final String userId;
  final String customerName;
  final String paymentTerms;
  final List selectedProducts;

  const QuoteDetails(
      {Key key,
      this.userId,
      this.customerName,
      this.selectedProducts,
      this.paymentTerms})
      : super(key: key);
  @override
  _QuoteDetailsState createState() => _QuoteDetailsState();
}

class _QuoteDetailsState extends State<QuoteDetails> {
  double _distanceBetweenRows = 15.0;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ITEM_CODE,
                style: labelTextStyle5,
              ),
              Text(
                PRODUCT_NAME,
                style: labelTextStyle5,
              ),
              Text(
                PRODUCT_PACKAGE,
                style: labelTextStyle5,
              ),
              Text(
                QUANTITY,
                style: labelTextStyle5,
              ),
              Text(ITEM_PRICE, style: labelTextStyle5),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2.0,
          ),
          SizedBox(
            height: _distanceBetweenRows,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 400.0,
            child: ListView.builder(
                itemCount: widget.selectedProducts.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.selectedProducts[index]['itemCode'] ?? '',
                            style: labelTextStyle3,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.selectedProducts[index]['itemDescription'],
                            style: labelTextStyle3,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.selectedProducts[index]['itemPack']
                                    .toString() ??
                                '',
                            style: labelTextStyle3,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.selectedProducts[index]['quantity']
                                    .toString() ??
                                '',
                            style: labelTextStyle3,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.selectedProducts[index]['price']
                                    .toString() ??
                                '',
                            style: labelTextStyle3,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          
        ],
      ),
    );
  }
}
