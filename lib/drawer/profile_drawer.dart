import 'package:Products/clients/client_form.dart';
import 'package:Products/clients/client_grid.dart';
import 'package:Products/orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:Products/account/account_page.dart';
import 'package:Products/services/auth.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';

class ProfileDrawer extends StatefulWidget {
  final String userId;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String company;
  final String countryOfResidence;
  final String cityOfResidence;
  final String phoneNumber;
  ProfileDrawer(
      {this.userId,
      this.firstName,
      this.lastName,
      this.company,
      this.countryOfResidence,
      this.cityOfResidence,
      this.phoneNumber,
      this.emailAddress});
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
            //Clients
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
            //send a quotation
            ListTile(
              leading: Icon(Icons.mail_outline),
              title: Text(SEND_QUOTE),
              enabled: true,
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClientGrid(
                            userId: widget.userId, quotation: true)));
              },
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
