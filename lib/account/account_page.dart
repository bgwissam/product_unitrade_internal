import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:Products/services/drop_down_picker.dart';

class AccountPage extends StatefulWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String phoneNumber;
  final String countryOfResidence;
  final String cityOfResidence;
  final String company;
  AccountPage(
      {this.userId,
      this.firstName,
      this.lastName,
      this.emailAddress,
      this.company,
      this.phoneNumber,
      this.countryOfResidence,
      this.cityOfResidence});
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  String newFirstName;
  String newLastName;
  String newPhoneNumber;
  String newCountryOfResidence;
  String newCityOfResidence;
  String newCompany;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    newCountryOfResidence = widget.countryOfResidence;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          ButtonTheme(
            minWidth: 60.0,
            height: 60.0,
            child: FlatButton.icon(
              icon: Icon(
                Icons.save,
                size: 40.0,
              ),
              label: iconLabel(),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  var result;
                  DatabaseService db = DatabaseService();
                  await db
                      .setUserData(
                          uid: widget.userId,
                          firstName: newFirstName ?? widget.firstName,
                          lastName: newLastName ?? widget.lastName,
                          phoneNumber: newPhoneNumber ?? widget.phoneNumber,
                          emailAddress: widget.emailAddress,
                          countryOfResidence: newCountryOfResidence ??
                              widget.countryOfResidence,
                          cityOfResidence:
                              newCityOfResidence ?? widget.cityOfResidence,
                          company: newCompany ?? widget.company,
                          isActive: true)
                      .then((value) {
                    result = value;
                    print(result);
                  });
                  if (result == null) {
                    setState(() {
                      loading = false;
                      _alertBox('Error Saving:', result);
                    });
                  } else {
                    setState(() {
                      loading = false;
                      _alertBox('Saved', result);
                    });
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: new Form(
          key: _formKey,
          child: _buildAccountBody(),
        ),
      ),
    );
  }

  //label is required for flatbottom.Icon as a widget
  Widget iconLabel() {
    return Text(SAVE);
  }

  //Alert box
  void _alertBox(String title, String errorText) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(errorText),
            actions: [
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  },
                  child: Text(OK_BUTTON))
            ],
          );
        });
  }

  Widget _buildAccountBody() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          //user name
          Container(
            padding: EdgeInsets.all(5.0),
            color: Colors.grey[400],
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(USER_NAME),
                ),
                Expanded(
                    flex: 2,
                    child: widget.emailAddress != null
                        ? Text(widget.emailAddress)
                        : Text('')),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          //First Name
          Row(
            children: [
              Expanded(flex: 1, child: Text(FIRST_NAME)),
              Expanded(
                flex: 2,
                child: TextFormField(
                    initialValue:
                        widget.firstName != null ? widget.firstName : ' ',
                    style: textStyle1,
                    decoration: InputDecoration(
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
                        val.isEmpty ? FIRST_NAME_VALIDATION : null,
                    onChanged: (val) => val.isNotEmpty
                        ? newFirstName = val
                        : newFirstName = widget.firstName),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          //Last Name
          Row(
            children: [
              Expanded(flex: 1, child: Text(LAST_NAME)),
              Expanded(
                flex: 2,
                child: TextFormField(
                    initialValue:
                        widget.lastName != null ? widget.lastName : ' ',
                    style: textStyle1,
                    decoration: InputDecoration(
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
                        val.isEmpty ? LAST_NAME_VALIDATION : null,
                    onChanged: (val) => val.isNotEmpty
                        ? newLastName = val
                        : newLastName = widget.lastName),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          //Phone number
          Row(
            children: [
              Expanded(flex: 1, child: Text(PHONE_NUMBER)),
              Expanded(
                flex: 2,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    initialValue:
                        widget.phoneNumber != null ? widget.phoneNumber : ' ',
                    style: textStyle1,
                    decoration: InputDecoration(
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
                        val.isEmpty ? PHONE_NUMBER_VALIDATION : null,
                    onChanged: (val) => val.isNotEmpty
                        ? newPhoneNumber = val
                        : newPhoneNumber = widget.phoneNumber),
              )
            ],
          ),
          Divider(
            height: 40,
            thickness: 3,
          ),
          //Country of Residence
          Row(children: [
            Expanded(flex: 1, child: Text(COUNTRY)),
            Expanded(
              flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15.0),
                      ),
                  child: CountryDropDownPicker(
                    countryOfResidence: widget.countryOfResidence,
                  )),
            )
          ]),
          SizedBox(
            height: 15.0,
          ),
          //City of residence
          Row(
            children: [
              Expanded(flex: 1, child: Text(CITY_RESIDENCE)),
              Expanded(
                flex: 2,
                child: TextFormField(
                    initialValue: widget.cityOfResidence != null
                        ? widget.cityOfResidence
                        : ' ',
                    style: textStyle1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    onChanged: (val) => val.isNotEmpty
                        ? newCityOfResidence = val
                        : newCityOfResidence = widget.cityOfResidence),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          //Company
          Row(
            children: [
              Expanded(flex: 1, child: Text(COMPANY)),
              Expanded(
                flex: 2,
                child: Container(
                  width: 100.0,
                  child: TextFormField(
                      initialValue:
                          widget.company != null ? widget.company : ' ',
                      style: textStyle1,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (val) =>
                          val.isEmpty ? COMPANY_VALIDATION : null,
                      onChanged: (val) => val.isNotEmpty
                          ? newCompany = val
                          : newCompany = widget.company),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
} //end of class
