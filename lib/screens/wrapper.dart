import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import './home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './authenticate/signin.dart';


class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _userIsVerified = false;
  // AuthService _auth = new AuthService();
  String message;
  void initState() {
    _checkUserVerified();
    super.initState();
  }

  //Check if user has been verified
  Future _checkUserVerified() async {
    // await FirebaseAuth.instance.currentUser()
    //   ..reload();
    var user = await FirebaseAuth.instance.currentUser();
        if (user != null) {
      if (user.isEmailVerified) {
        setState(() {
          _userIsVerified = true;
        });
      }
     print('The current user $_userIsVerified');
    }
  }

  @override
  Widget build(BuildContext context) {
    //User user = Provider.of<User>(context) ?? null;
    UserData userData = Provider.of<UserData>(context) ?? null;
    print('${this.runtimeType} is user verified: $_userIsVerified');
    if (userData == null) {
      return Authenticate();
    } 
    else {
      return Home(
        userId: userData.uid,
        isActive: userData.isActive,
        firstName: userData.firstName,
      );
    }
  }
}
