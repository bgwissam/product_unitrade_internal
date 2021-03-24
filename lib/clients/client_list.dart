import 'package:Products/clients/client_form.dart';
import 'package:Products/models/clients.dart';
import 'package:Products/shared/constants.dart';
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
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'This page will show the Sale\'s executive personal clients, tapping on the client will allow you to edit them.',
                  style: textStyle6,
                )),
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
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: clients.length ?? 0,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 80.0,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0)),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientForm(
                                client: clients[index],
                              ))),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 7.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  clients[index].clientName.toString(),
                                  style: textStyle4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                clients[index].contactPerson.toString(),
                                style: textStyle5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                clients[index].clientPhoneNumber.toString(),
                                style: textStyle5,
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          );
        });
  }
}
