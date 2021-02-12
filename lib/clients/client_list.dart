import 'package:Products/clients/client_form.dart';
import 'package:Products/models/clients.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientList extends StatefulWidget {
  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  var clients;

  @override
  Widget build(BuildContext context) {
    clients = Provider.of<List<Clients>>(context) ?? [];
    if (clients.isNotEmpty)
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
                        CLIENT_NAME,
                        style: textStyle3,
                      )),
                    ),
                    TableCell(
                      child: Center(
                          child: Text(
                        CLIENT_PHONE,
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
            Expanded(
              child: _buildClientList(),
            ),
          ],
        ),
      );
    else
      return Container(
        child: Center(child: Text('No clients were found')),
      );
  }
  //build the client list
  Widget _buildClientList() {
    return SingleChildScrollView(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: clients.length ?? 0,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClientForm(
                            client: clients[index],
                          ))),
              child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                            child: Center(
                                child: Text(
                                    clients[index].clientName.toString()))),
                        TableCell(
                            child: Center(
                          child:
                              Text(clients[index].clientPhoneNumber.toString()),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
