import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:Products/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:Products/quotes/quote_view/quote_list.dart';
import 'package:Products/models/enquiries.dart';
import 'package:Products/services/email_management.dart';
import 'package:Products/shared/loading.dart';

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
      child: _buildQuotesPage(context),
    );
  }

  Widget _buildQuotesPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(QUOTE_LIST),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0,
      ),
      body: QuoteList(),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        height: 50.0,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: FutureBuilder(
              future: _getQuoteValueStatus(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Loading();
                  else if (snapshot.connectionState == ConnectionState.done) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$WON: ${snapshot.data[0]}',
                            style: labelTextStyle5,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$LOST: ${snapshot.data[1]}',
                            style: labelTextStyle5,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$PENDING: ${snapshot.data[2]}',
                            style: labelTextStyle5,
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                } else if (snapshot.hasError) {
                  return Container(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Container();
                }
              },
            )));
  }

  Future _getQuoteValueStatus() async {
    double wonTotal = 0.0;
    double lostTotal = 0.0;
    double pendingTotal = 0.0;
    EmailManagement emailManagement = new EmailManagement();
    
    var result = emailManagement.quotationCollection
        .where('userId', isEqualTo: userId)
        .where('dateTime', isGreaterThanOrEqualTo: startingDate)
        .where('dateTime', isLessThanOrEqualTo: endingDate)
        .getDocuments();
    if (result != null) {
      var items = await result.then((value) => value.documents.map((doc) {
            return QuoteData(
                status: doc.data['status'],
                itemQuoted: doc.data['itemsQuoted']);
          }).toList());
      //the for loop will iterate between the item to calculate the total
      for (int i = 0; i < items.length; i++) {
        for (int j = 0; j < items[i].itemQuoted.length; j++) {
          switch (items[i].status) {
            case WON:
            wonTotal += items[i].itemQuoted[j]['itemTotal'];
            break;
            case LOST:
            lostTotal += items[i].itemQuoted[j]['itemTotal'];
            break;
            case PENDING:
            pendingTotal += items[i].itemQuoted[j]['itemTotal'];
            break;
            
          }
        }
      }

      List<double> totalStatusValue = [];
      totalStatusValue = [wonTotal, lostTotal, pendingTotal];

      return totalStatusValue;
     
    } else {
      print('no fucking data was found');
    }
  }

  void dispose() {
    _getQuoteValueStatus().whenComplete(() => dispose());
  }
}
