import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:provider/provider.dart';
import 'package:Products/quotes/quote_view/quote_list.dart';
import 'package:Products/models/enquiries.dart';
import 'package:Products/services/email_management.dart';

class QuoteGrid extends StatelessWidget {
  final String userId;
  final DateTime startingDate;
  final DateTime endingDate;
  QuoteGrid({this.userId, this.startingDate, this.endingDate});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<QuoteData>>.value(
      value: EmailManagement().getQuoteDataByUserId(
          userId: userId, startingDate: startingDate, endingDate: endingDate),
      catchError: (context, error) {
        print('the error is: $error');
        return null;
      },
      child: _buildQuotesPage(),
    );
  }

  Widget _buildQuotesPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(QUOTE_LIST),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0,
      ),
      body: QuoteList(),
    );
  }
}
