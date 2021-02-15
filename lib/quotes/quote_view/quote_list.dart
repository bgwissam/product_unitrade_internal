import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:provider/provider.dart';
import 'package:Products/models/enquiries.dart';
import 'quote_tile.dart';

class QuoteList extends StatefulWidget {
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  var quoteProvider;
  @override
  Widget build(BuildContext context) {
    quoteProvider = Provider.of<List<QuoteData>>(context) ?? [];
    if (quoteProvider.isNotEmpty) {
      return ListView.builder(
        itemCount: quoteProvider.length,
        itemBuilder: (context, index) {
        return QuoteTile(
          quotes: quoteProvider[index],
        );
      });
    
    } else {
      return Center(
        child: Container(
          child: Text('No Quotes were found'),
        ),
      );
    }
  }
}
