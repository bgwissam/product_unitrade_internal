import 'package:flutter/material.dart';
import 'package:Products/models/enquiries.dart';
import 'package:Products/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:Products/shared/strings.dart';
import 'quote_details.dart';
import 'package:Products/services/email_management.dart';

class QuoteTile extends StatefulWidget {
  final QuoteData quotes;
  QuoteTile({this.quotes});

  @override
  _QuoteTileState createState() => _QuoteTileState();
}

class _QuoteTileState extends State<QuoteTile> {
  String quoteId;
  String userId;
  String clientName;
  String paymentTerms;
  List<double> quantity;
  List<dynamic> itemsSelected;
  List selecteProducts = [];
  double _distanceBetweenRows = 2.0;
  var date;

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

    EmailManagement products = new EmailManagement();
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

  @override
  Widget build(BuildContext context) {
    var formatDate = new DateFormat().add_yMMMd().format(date);
    var totalItem = widget.quotes.itemQuoted.length;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () async {
          await getSelectedProducts(quoteId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuoteDetails(
                userId: userId,
                customerName: clientName,
                paymentTerms: paymentTerms,
                selectedProducts: selecteProducts,
              ),
            ),
          );
        },
        child: Container(
          height: 80.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(width: 2)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              mainAxisAlignment: MainAxisAlignment.center,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$TOTAL_ITEMS: ', style: labelTextStyle5),
                Text(
                  totalItem.toString(),
                  style: labelTextStyle3,
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
