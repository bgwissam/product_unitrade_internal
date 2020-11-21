import 'dart:io';
import 'package:Products/services/email_management.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFDocumentViewer extends StatefulWidget {
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
      {this.doc,
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
  bool _emailSentStatus = false;
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
    EmailManagement sendQuote = new EmailManagement();
    //disable sending email after first click
    _isButtonDisabled = true;
    var result = await sendQuote.sendEmail(
        toRecipient: widget.clientEmail,
        clientName: widget.clientName,
        adminRecipient: widget.supplierEmail,
        subject: widget.subject,
        contact: widget.contact,
        text: widget.text,
        file: widget.file,
        path: widget.path);

      
      sendQuote.mail.document(result).snapshots().listen((event) {
          if(event.data['delivery']['state'] != null)
          print('state ${event.data['delivery']['state']}');
      });
      
      
      // then((value) {
      //   emailStatus = value.data['state'];
      //   print(emailStatus);
      //   if (emailStatus == 'SUCCESS') {
      //     _emailSentStatus = true;
      //   } else {
      //     _emailSentStatus = false;
      //   }
      // });
    

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text(EMAIL_STATUS),
    //         content: _emailSentStatus ? Text(EMAIL_SENT) : Text(EMAIL_FAIL),
    //         actions: [
    //           FlatButton(
    //             child: Text(OK_BUTTON),
    //             onPressed: () {
    //               Navigator.pop(context);
    //               Navigator.pop(context);
    //               Navigator.pop(context);
    //               Navigator.pop(context);
    //             },
    //           )
    //         ],
    //       );
    //     });
  }
}
