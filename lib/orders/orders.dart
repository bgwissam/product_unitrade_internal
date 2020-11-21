import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Products/models/products.dart';
import 'package:Products/orders/order_details.dart';
import 'package:Products/services/email_management.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';

class OrdersList extends StatefulWidget {
  final String userId;
  OrdersList({this.userId});
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<Orders> ordersList = new List();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Orders>>.value(
      value: EmailManagement().getOrdersById(userId: widget.userId),
      child: Scaffold(
          appBar: AppBar(
            title: Text(ORDER_TITLE),
            backgroundColor: Colors.amber[400],
          ),
          body: _buildOrderPage()),
      catchError: (_, err) {
        print(err);
        return ordersList;
      },
    );
  }

  //Build the body of the order page
  Widget _buildOrderPage() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(child: _buildPageHeaders()),
          Container(child: _buildOrderList()),
          Container(child: _buildPageFooter())
        ],
      ),
    );
  }

  //build the top view of the headers of the list view
  Widget _buildPageHeaders() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(3),
        },
        children: [
          TableRow(children: [
            new Container(
              child: Center(
                child: Text(
                  ORDER_REF,
                  style: textStyle1,
                ),
              ),
            ),
            new Container(
              child: Center(
                child: Text(
                  ORDER_ID,
                  style: textStyle1,
                ),
              ),
            ),
            new Container(
              child: Center(
                child: Text(
                  Order_DATE,
                  style: textStyle1,
                ),
              ),
            )
          ])
        ],
      ),
    );
  }

  //build a list view to get all available orders
  Widget _buildOrderList() {
    return Container(
      height: 500.0,
      child: OrderListProvider(),
    );
  }

  //build the bottom of the page
  Widget _buildPageFooter() {
    return Container();
  }
}

class OrderListProvider extends StatefulWidget {
  @override
  _OrderListProviderState createState() => _OrderListProviderState();
}

class _OrderListProviderState extends State<OrderListProvider> {
  var converted;
  @override
  Widget build(BuildContext context) {
    var products = Provider.of<List<Orders>>(context) ?? [];
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: products.length ?? 0,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetails(
                        orderId: products[index].orderId,
                        orderProducts: products[index].orderProducts,
                        status: products[index].status,
                      ))),
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
              },
              children: [
                TableRow(children: [
                  TableCell(
                    child: Center(child: Text((index + 1).toString())),
                  ),
                  TableCell(
                    child:
                        Center(child: Text(products[index].orderId.toString())),
                  ),
                  TableCell(
                      child: Center(
                    child: _converTimeStampToDate(products[index].date),
                  )),
                ])
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _converTimeStampToDate(Timestamp orderTime) {
    if (orderTime != null) {
      converted =
          '${orderTime.toDate().day}-${orderTime.toDate().month}-${orderTime.toDate().year}';
    }
    return Container(
      child: Text(converted),
    );
  }
} //end of class
