import 'package:flutter/material.dart';
import 'package:Products/models/enquiries.dart';
import 'package:Products/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:Products/shared/strings.dart';
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
  List<double> quantity;
  List<dynamic> itemsSelected;
  bool quotation = true;
  double _distanceBetweenRows = 2.0;
  var date;

  void initState() {
    quoteId = widget.quotes.quoteId ?? null;
    userId = widget.quotes.userId ?? null;
    clientName = widget.quotes.clientName ?? null;
    date = widget.quotes.dateTime.toDate() ?? null;
    itemsSelected = widget.quotes.itemQuoted ?? null;

    super.initState();
  }

  void getSelectedProducts(String id) async {
    List<Items> selecteProducts = [];
    Map<String, dynamic> oneProduct;
    EmailManagement products = new EmailManagement();
    var document = await products.quotationCollection.document(quoteId).get();
    if (document.exists) {
      var items = document.data['itemsQuoted'];
      for (int i = 0; i < items.length; i++) {
        print(items[i]['itemPack']);
        oneProduct = {items[i].keys.toString(): items[i].values};
        selecteProducts = oneProduct.entries.map((e) => Items(e.key, e.value)).toList();
      }
        print(selecteProducts);
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
          getSelectedProducts(quoteId);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ClientGrid(
          //               userId: userId,
          //               customerName: clientName,
          //               quotation: quotation,
          //               numberOfProducts: totalItem,
          //             )));
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
            )
          ]),
        ),
      ),
    );
  }
}
