import 'dart:io';
import 'package:Products/services/email_management.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFDocumentViewer extends StatefulWidget {
  final String quoteId;
  final PDFDocument doc;
  final String clientEmail;
  final String clientName;
  final String supplierEmail;
  final String subject;
  final String text;
  final String contact;
  final String path;
  final File file;
  PDFDocumentViewer(
      {this.quoteId,
      this.doc,
      this.clientEmail,
      this.clientName,
      this.supplierEmail,
      this.subject,
      this.contact,
      this.text,
      this.path,
      this.file});
  @override
  _PDFDocumentViewerState createState() => _PDFDocumentViewerState();
}

class _PDFDocumentViewerState extends State<PDFDocumentViewer> {
  bool _isButtonDisabled = false;

  String emailStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(QUOTATION),
        backgroundColor: Colors.amber[300],
        actions: [
          Container(
            child: RaisedButton(
                color: Colors.amber[100],
                onPressed: !_isButtonDisabled ? () => _sendQuotation() : null,
                elevation: 2.0,
                child: Text(
                  SEND_QUOTE,
                  style: buttonStyle,
                )),
          )
        ],
      ),
      body: Center(
        child: PDFViewer(document: widget.doc),
      ),
    );
  }

  _sendQuotation() async {
    setState(() {
      _isButtonDisabled = true;
    });
    EmailManagement sendQuote = new EmailManagement();
    //get the saved quote to updated status
    
    //disable sending email after first click
    var result = await sendQuote.sendEmail(
        toRecipient: widget.clientEmail,
        clientName: widget.clientName,
        adminRecipient: widget.supplierEmail,
        subject: widget.subject,
        contact: widget.contact,
        text: widget.text,
        file: widget.file,
        path: widget.path);

    sendQuote.mail.document(result).snapshots().listen(
      (event) async {
        //delay the creation of the email 2 seconds
        Future.delayed(Duration(seconds: 3), () async {
          var result = await event.data['delivery']['state'] ?? null;
          if (result != null) {
            switch (result) {
              case 'SUCCESS':
                emailStatus = EMAIL_SENT;
                break;
              case 'PENDING':
                emailStatus = EMAIL_PENDING;
                break;
              case 'PREPARING':
                emailStatus = EMAIL_PREP;
                break;
              case 'FAILED':
                emailStatus = EMAIL_FAIL;
                break;
              default:
                emailStatus = EMAIL_PENDING;
            }
            Future.delayed(Duration(seconds: 2), () {
              //show dialog after delay
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(EMAIL_STATUS),
                    content: Text(emailStatus),
                    actions: [
                      FlatButton(
                        child: Text(OK_BUTTON),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home', (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  );
                },
              );
            });
          }
        });
      },
    );
  }
}
