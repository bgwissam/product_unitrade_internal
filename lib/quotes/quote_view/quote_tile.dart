import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:Products/models/enquiries.dart';
import 'package:Products/shared/constants.dart';
import 'package:intl/intl.dart';


class QuoteTile extends StatefulWidget {
  final QuoteData quotes;
  QuoteTile({this.quotes});

  @override
  _QuoteTileState createState() => _QuoteTileState();
}

class _QuoteTileState extends State<QuoteTile> {
  String quoteId;
  String clientName;
  var date;
  

  void initState() {
    quoteId = widget.quotes.quoteId ?? null;
    clientName = widget.quotes.clientName ?? null;
    date = widget.quotes.dateTime.toDate() ?? null;
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    var formatDate = new DateFormat().add_yMMMd().format(date);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () async {
          print(quoteId);
          return quoteId;
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(width: 2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(
              'Client Name: $clientName',
              style: labelTextStyle,
            ),
            Text(
              'Date: $formatDate',
              style: labelTextStyle,
            ),
          ]),
        ),
      ),
    );
  }
}
