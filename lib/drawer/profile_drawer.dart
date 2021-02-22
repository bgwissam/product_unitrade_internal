import 'package:Products/clients/client_form.dart';
import 'package:Products/clients/client_grid.dart';
import 'package:Products/orders/orders.dart';
import 'package:Products/screens/authenticate/UserGrid.dart';
import 'package:flutter/material.dart';
import 'package:Products/account/account_page.dart';
import 'package:Products/services/auth.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:Products/shared/date_time_picker.dart';

class ProfileDrawer extends StatefulWidget {
  final String userId;
  final List<dynamic> roles;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String company;
  final String countryOfResidence;
  final String cityOfResidence;
  final String phoneNumber;
  final bool isAdmin;
  ProfileDrawer(
      {this.userId,
      this.roles,
      this.firstName,
      this.lastName,
      this.company,
      this.countryOfResidence,
      this.cityOfResidence,
      this.phoneNumber,
      this.emailAddress,
      this.isAdmin});
  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  void initState() {
    super.initState();
  }

  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _drawerHeader(),
            //Clients section
            ExpansionTile(
              leading: Icon(Icons.person),
              title: Text(CLIENTS),
              children: [
                //Add a new client
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text(NEW_CLIENT),
                  enabled: true,
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientForm(
                                  userId: widget.userId,
                                )));
                  },
                ),
                //Current clients
                ListTile(
                  leading: Icon(Icons.person_outline_rounded),
                  title: Text(CURRENT_CLIENTS),
                  enabled: true,
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientGrid(
                                  userId: widget.userId,
                                  quotation: false,
                                )));
                  },
                ),
              ],
            ),
            //Quotation section
            ExpansionTile(
              leading: Icon(Icons.mail),
              title: Text(QUOTES),
              children: [
                //send a quotation
                ListTile(
                  leading: Icon(Icons.mail_outline),
                  title: Text(SEND_QUOTE),
                  enabled: true,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClientGrid(userId: widget.userId, quotation: true),
                      ),
                    );
                  },
                ),

                //View current quotations
                ListTile(
                  leading: Icon(Icons.list_rounded),
                  title: Text(VIEW_QUOTES),
                  enabled: true,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DateTimePicker(userId: widget.userId,),
                      ),
                    );
                  },
                )
              ],
            ),

            //Send a sales orders
            ListTile(
              leading: Icon(Icons.mail_outline),
              title: Text(SEND_SR),
              enabled: false,
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrdersList(
                              userId: widget.userId,
                            )));
              },
            ),
            //change profile settings
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(ACCOUNT),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountPage(
                              userId: widget.userId,
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              emailAddress: widget.emailAddress,
                              company: widget.company,
                              phoneNumber: widget.phoneNumber,
                              countryOfResidence: widget.countryOfResidence,
                              cityOfResidence: widget.cityOfResidence,
                            )));
              },
            ),
            widget.roles != null
                ? widget.roles.contains('isSuperAdmin')
                    ? ExpansionTile(
                        leading: Icon(Icons.lock),
                        title: Text(USERS),
                        children: [
                          //View current users
                          ListTile(
                              leading: Icon(Icons.app_settings_alt_sharp),
                              title: Text(CURRENT_USERS),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserGrid()));
                              }),
                        ],
                      )
                    : SizedBox.shrink()
                : SizedBox.shrink(),

            ListTile(
              leading: Icon(Icons.person),
              title: Text(SIGN_OUT),
              onTap: () async {
                _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerHeader() {
    return DrawerHeader(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.scaleDown)),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 8.0,
            left: 12.0,
            child: Text(
              'Welcome ${widget.firstName}',
              style: textStyle6,
            ),
          )
        ],
      ),
    );
  }
}
