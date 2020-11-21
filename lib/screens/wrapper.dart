import '../models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';
import './home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context) ?? null;
    if (user == null) {
      return Authenticate();
    } else {
      return Home(
        userId: user.uid,
      );
    }
  }
}
