import 'package:Products/models/clients.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/dropdownLists.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClientForm extends StatefulWidget {
  final String userId;
  final Clients client;
  ClientForm({this.userId, this.client});
  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();
  String clientUid;
  String clientName;
  String contactName;
  String phoneNumber;
  String emailAddress;
  String addressCity;
  String businessSector;

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      clientUid = widget.client.uid;
      clientName = widget.client.clientName;
      phoneNumber = widget.client.clientPhoneNumber;
      emailAddress = widget.client.email;
      addressCity = widget.client.clientCity;
      businessSector = widget.client.clientBusinessSector;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CLIENT_FORM),
        backgroundColor: Colors.blueGrey[500],
      ),
      body: SingleChildScrollView(
          child: new Form(key: _formKey, child: _buildClientForm())),
    );
  }

  Widget _buildClientForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          //Client Name
          Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(CLIENT_NAME),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: clientName == null ? '' : clientName,
                    style: textStyle1,
                    decoration: InputDecoration(
                      hintText: 'Ex. Factory Co.',
                      filled: true,
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (val) =>
                        val.isEmpty ? CLIENT_NAME_VALIDATION : null,
                    onChanged: (val) {
                      setState(() {
                        clientName = val.toUpperCase();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Client Phone number
          Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(CLIENT_PHONE),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    initialValue: phoneNumber != null ? phoneNumber : '',
                    style: textStyle1,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: '05 12341234',
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (val) =>
                        val.isEmpty ? CLIENT_PHONE_VALIDATION : null,
                    onChanged: (val) {
                      setState(() {
                        phoneNumber = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Client email address
          Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(CLIENT_EMAIL),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: emailAddress != null ? emailAddress : '',
                    style: textStyle1,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'example@domain.com',
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    validator: (val) =>
                        val.isEmpty ? CLIENT_EMAIL_VALIDATION : null,
                    onChanged: (val) {
                      setState(() {
                        emailAddress = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Client Address City
          Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(CLIENT_CITY),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        isDense: true,
                        isExpanded: true,
                        value: addressCity,
                        validator: (val) =>
                            val == null ? 'Area is required' : null,
                        onChanged: (String val) {
                          setState(() {
                            addressCity = val;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return CitiesSaudiArabia.cities()
                              .map<Widget>((String city) {
                            return Text(
                              city,
                              style: textStyle1,
                            );
                          }).toList();
                        },
                        items: CitiesSaudiArabia.cities().map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text(item),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //Client Business Sector
          Container(
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(CLIENT_BUSINESS),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        isDense: true,
                        isExpanded: true,
                        value: businessSector,
                        validator: (val) =>
                            val == null ? 'Select business sector' : null,
                        onChanged: (String val) {
                          setState(() {
                            businessSector = val;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return BusinessType.sector()
                              .map<Widget>((String item) {
                            return Text(
                              item,
                              style: textStyle1,
                            );
                          }).toList();
                        },
                        items: BusinessType.sector().map((String item) {
                          return DropdownMenuItem<String>(
                            child: Text(item),
                            value: item,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
          //Save button
          SizedBox(
            height: 15.0,
          ),
          Container(
            child: RaisedButton(
              elevation: 2.0,
              color: Colors.blueGrey[300],
              child: Text(SAVE),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  DatabaseService db = DatabaseService();
                  if (widget.client == null) {
                    var result = await db.addClient(
                        clientName: clientName,
                        clientPhone: phoneNumber,
                        clientAddress: addressCity,
                        clientSector: businessSector,
                        email: emailAddress,
                        salesInCharge: widget.userId);
                    if (result != null) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(ALERT_SAVED_CLIENT),
                              actions: [
                                FlatButton(
                                  child: Text(OK_BUTTON),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/home',
                                            (Route<dynamic> route) => true);
                                  },
                                )
                              ],
                            );
                          });
                    }
                  } else {
                    await db.updateClient(
                        uid: clientUid,
                        clientName: clientName,
                        clientPhone: phoneNumber,
                        email: emailAddress,
                        clientAddress: addressCity,
                        clientSector: businessSector);

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(ALERT_UPDATED_CLIENT),
                            actions: [
                              FlatButton(
                                child: Text(OK_BUTTON),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        });
                  }
                }
              },
            ),
          )
        ]),
      ),
    );
  }
}
