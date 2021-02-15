import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:provider/provider.dart';
import 'package:Products/quotes/quote_view/quote_list.dart';
import 'package:Products/models/enquiries.dart';
import 'package:Products/services/email_management.dart';

class QuoteGrid extends StatelessWidget {
  final String userId;
  QuoteGrid({this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<QuoteData>>.value(
      value: EmailManagement().getQuoteDataByUserId(userId: userId),
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
