import 'package:Products/models/user.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  var users;

  @override
  Widget build(BuildContext context) {
    users = Provider.of<List<UserData>>(context);
    if (users != null)
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              child: Table(
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Center(
                          child: Text(
                        USER_NAME,
                        style: textStyle3,
                      )),
                    ),
                    TableCell(
                      child: Center(
                          child: Text(
                        PHONE_NUMBER,
                        style: textStyle3,
                      )),
                    )
                  ])
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: users.length ?? 0,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {

                      },
                      child:  Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Table(
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                    child: Center(
                                        child: Text(users[index]
                                            .firstName
                                            .toString()))),
                                TableCell(
                                    child: Center(
                                  child: Text(users[index]
                                      .lastName
                                      .toString()),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
    else
      return Container(
        child: Center(child: Text('No clients were found')),
      );
  }
}