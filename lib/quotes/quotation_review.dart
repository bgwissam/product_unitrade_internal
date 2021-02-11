import 'package:Products/models/user.dart';
import 'package:Products/quotes/report_pdf.dart';
import 'package:Products/services/email_management.dart';
import 'package:Products/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class QuotationReview extends StatefulWidget {
  final String salesCordinator;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String clientId;
  final String paymentTerms;
  final List<Map<String, dynamic>> products;
  final double totalValue;
  final User user;
  final String userId;
  final Function clearProductList;
  //quote sender information
  final String name;
  final String phone;
  final String supplierEmail;

  QuotationReview(
      {this.salesCordinator,
      this.customerName,
      this.customerEmail,
      this.customerPhone,
      this.clientId,
      this.paymentTerms,
      this.products,
      this.clearProductList,
      this.user,
      this.userId,
      this.totalValue,
      this.name,
      this.phone,
      this.supplierEmail});
  @override
  _QuotationReviewState createState() => _QuotationReviewState();
}

class _QuotationReviewState extends State<QuotationReview> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var _formKey = GlobalKey<FormState>();
  EmailManagement saveQuotation;
  EmailManagement getQuotation;
  bool emailSent = false;
  String clienEmail;
  String quotationContent;
  String contactName;
  ByteData imageLogo;
  @override
  void initState() {
    super.initState();
    //get image logo
    rootBundle
        .load('assets/images/logo.png')
        .then((data) => setState(() => imageLogo = data));
    saveQuotation = EmailManagement();
    getQuotation = EmailManagement();
  }

  //clear cart on back pressed
  _clearProductList() async {
    widget.clearProductList();
  }

  //Dialog box for quotation status
  _quotationSentSuccessfully(bool status) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: status
                ? Text(QUOTE_SENT_SUCCESSFULLY)
                : Text(QUOTE_SENT_FAILED),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(OK_BUTTON))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _clearProductList();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(REVIEW_SUBMIT),
          backgroundColor: Colors.blueGrey[500],
          actions: [
            FlatButton(
                onPressed: () async {
                  submitQuotation(context);
                },
                child: Text(
                  SUBMIT,
                  style: textStyle9,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(key: _formKey, child: _buildQuotationFormReview(context)),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(TOTAL_BEFORE_TAX,
                      style: GoogleFonts.lato(textStyle: textStyle10)),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.totalValue.toStringAsFixed(2),
                    style: textStyle10,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Submit current quotation request to save the quote
  Future<void> submitQuotation(BuildContext context) async {
    try {
      //check if the form fields are valid

      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        Dialogs.showLoadingDialog(context, _keyLoader);

        var result = await saveQuotation.saveQuotation(
            products: widget.products,
            clientName: widget.customerName,
            clientId: widget.clientId,
            paymentTerms: widget.paymentTerms,
            userId: widget.userId);
        //check if item is saved
        if (result != null) {
          //close loading navigator
          await reportView(
            saleCordinator: widget.salesCordinator,
            context: context,
            quoteId: result,
            products: widget.products,
            clientName: widget.customerName,
            clientEmail: widget.customerEmail,
            clientPhone: widget.customerPhone,
            salesmanName: widget.name,
            salesmanEmail: widget.supplierEmail,
            salesmanPhone: widget.phone,
            paymentTerms: widget.paymentTerms,
            total: widget.totalValue,
            textContent: quotationContent,
            contactName: contactName,
            imageLogo: imageLogo,
          );
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        }
        //if an error occured
        else {
          emailSent = false;
          _quotationSentSuccessfully(emailSent);
        }
      }
    } catch (e) {
      print('An error occured while trying to save document: $e');
    }
  }

  Widget _buildQuotationFormReview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  CLIENT_NAME,
                  style: textStyle4,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(widget.customerName),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  PAYMENT_TERMS,
                  style: textStyle4,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(widget.paymentTerms),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  ITEM_CODE,
                  style: textStyle4,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  PRODUCT_PACKAGE,
                  style: textStyle4,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  QUANTITY,
                  style: textStyle4,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  ITEM_PRICE,
                  style: textStyle4,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          widget.products.isNotEmpty
              ? Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(widget.products[index]['itemCode']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                                widget.products[index]['itemPack'].toString()),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                                widget.products[index]['quantity'].toString()),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                                widget.products[index]['price'].toString()),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Container(),
          SizedBox(
            height: 10.0,
          ),
          //Set the name of the client's contact
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(CONTACT_NAME),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                    style: textStyle1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (val) => val.isEmpty ? CONTACT_NAME_EMPTY : null,
                    onSaved: (val) {
                      setState(() {
                        contactName = val;
                      });
                    }),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          //set the message content
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(MESSAGE_CONTENT),
              ),
              Expanded(
                flex: 3,
                child: TextFormField(
                    style: textStyle1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (val) =>
                        val.isEmpty ? MESSAGE_CONTENT_VALIDATION : null,
                    onSaved: (val) {
                      setState(() {
                        quotationContent = val;
                      });
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
}

//Show loading dialog
class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.amber[300],
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.black),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
