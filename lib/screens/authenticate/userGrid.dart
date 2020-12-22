import 'package:Products/models/user.dart';
import 'package:Products/screens/authenticate/usersList.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// UserGrid will be the streaming parent for UserList Class
class UserGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
      value: DatabaseService().userData,
      child: userBuild(),
    );
  }

  Widget userBuild() {
    return Scaffold(
        appBar: AppBar(
        title: Text(USER_LIST),
        backgroundColor: Colors.blueGrey[500],
      ),
      body: UsersList(),
    );
  }
}