import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import './home/home.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //User user = Provider.of<User>(context) ?? null;
    UserData userData = Provider.of<UserData>(context) ?? null;
    if (userData == null) {
      return Authenticate();
    } else {
      return Home(
        userId: userData.uid,
        isActive: userData.isActive,
        firstName: userData.firstName,
      );
    }
  }
}
