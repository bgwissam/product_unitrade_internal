import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:Products/shared/constants.dart';
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
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        height: 50.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$WON: ',
                  style: labelTextStyle5,
                ),
              ),
              Expanded(
                child: Text(
                  '$LOST: ',
                  style: labelTextStyle5,
                ),
              ),
              Expanded(
                child: Text(
                  '$PENDING: ',
                  style: labelTextStyle5,
                ),
              )
            ],
          ),
        ));
  }

  Future _getQuoteValueStatus() async {
    EmailManagement emailManagement = new EmailManagement();
  }
}
