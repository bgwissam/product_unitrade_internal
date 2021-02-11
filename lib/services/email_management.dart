import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Products/models/products.dart';
import 'package:Products/models/enquiries.dart';

class EmailManagement {
  final CollectionReference mail = Firestore.instance.collection('quote_mail');
  final CollectionReference quotationCollection =
      Firestore.instance.collection('quotes');

  Future sendEmail(
      {String toRecipient,
      String clientName,
      String adminRecipient,
      String subject,
      String contact,
      String text,
      String path,
      File file}) async {
    try {
      String uid;
      var response;
      StringBuffer buffer = new StringBuffer();
      //Capitalize the first letter of the email text items
      contact.firstLetterToUpperCase;
      text.firstLetterToUpperCase;
      //set the detais
      buffer.write(
          '<table><tr><td>Dear ${contact.firstLetterToUpperCase},</td></tr><tr>\n</tr>');
      buffer.write(
          '<tr><td>${text.firstLetterToUpperCase}</td></tr><tr>\n\n</tr>');
      buffer.write('<tr><td>Thank you</td></tr></table>');

      return mail.add({
        'to': [toRecipient],
        'cc': [adminRecipient],
        'message': {
          'subject': subject,
          'html': buffer.toString(),
          'attachments': [
            {
              'filename': '$clientName.pdf',
              'path': path,
            },
          ],
        },
      }).then((value) {
        uid = value.documentID;
        return uid;
      }).catchError((e) {
        response = e;
      });
    } catch (e) {
      print('The email process did not succeed: $e');
    }
  }

//save the orders into the database
  Future saveQuotation(
      {List<Map<String, dynamic>> products,
      String userId,
      String clientId,
      String clientName,
      String paymentTerms}) async {
    //get the last id in the orders database
    String quoteId;
    String status = 'Pending';
    try {
      String lastId;
      String newId;
      await quotationCollection
          .orderBy('quoteId', descending: false)
          .getDocuments()
          .then((doc) {
        doc.documents.forEach((element) {
          element.data['quoteId'] != null
              ? lastId = element.data['quoteId']
              : lastId = newId;
        });

        if (lastId == null) {
          quoteId = 'QUO000001';
        } else {
          quoteId = lastId;
          RegExp reg = new RegExp('[a-zA-Z]');
          var numbers = quoteId.replaceAll(reg, '').split(reg);
          int numaricOrderId = int.parse(numbers[0]);
          numaricOrderId++;

          var newId = numaricOrderId.toString();
          if (newId.length < 6) {
            for (var i = newId.length; i < 6; i++) {
              newId = '0' + newId;
            }
          }
          quoteId = 'QUO' + newId;
        }
      });

      //set the order with the new order Id to the order collection
      try {
        if (quoteId != null) {
          var now = DateTime.now();
          await quotationCollection.document(quoteId).setData({
            'itemsQuoted': products,
            'clientId': clientId,
            'clientName': clientName,
            'paymentTerms': paymentTerms,
            'userId': userId,
            'quoteId': quoteId,
            'dateTime': now,
            'status': status,
          });
        }
      } catch (e) {
        print('quotation couldn\'t be saved: $e');
      }
      return quoteId;
    } catch (e) {
      print('Couldn\'t get data from quotations table: $e');
    }
  }

  //Update quotation
  Future updateQuote({String pdfUrl, String uid}) async {
    try {
      return quotationCollection
          .document(uid)
          .updateData({'pdfUrl': pdfUrl}).then((value) => value);
    } catch (e) {
      print('pdf Url could not be saved to the database: $e');
    }
  }

  //quotation data
  List<QuoteData> _quoteDataBySnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return QuoteData(
          quoteId: doc.data['quoteId'] ?? '',
          clientId: doc.data['clientId'] ?? '',
          clientName: doc.data['clientName'] ?? '',
          paymentTerms: doc.data['paymentTerms'] ?? '',
          products: doc.data['products'] ?? '',
          userId: doc.data['userId'] ?? '',
          status: doc.data['status'] ?? '');
    });
  }

  //Stream data for the saved quotes
  Stream<List<QuoteData>> getQuoteDataById(String quoteId) {
    return quotationCollection
        .where('quoteId', isEqualTo: quoteId)
        .snapshots()
        .map(_quoteDataBySnapshot);
  }

  //Get list of orders
  List<Orders> _ordersBySnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Orders(
          orderId: doc.documentID,
          orderProducts: doc.data['itemsOrdered'],
          date: doc.data['dateTime'],
          status: doc.data['status']);
    }).toList();
  }

  //stream data from the orders collection based on user Id
  Stream<List<Orders>> getOrdersById({String userId}) {
    try {
      return quotationCollection
          .orderBy('dateTime', descending: true)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map(_ordersBySnapshot);
    } catch (e) {
      print('Quotation couldn\'t be found: $e');
      return null;
    }
  }
}

extension StringExtension on String {
  get firstLetterToUpperCase {
    if (this != null) {
      return this[0].toUpperCase() + this.substring(1);
    } else {
      return null;
    }
  }
}
