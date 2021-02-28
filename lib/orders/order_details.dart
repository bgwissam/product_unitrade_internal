import 'package:flutter/material.dart';
import 'package:Products/shared/constants.dart';
import 'package:Products/shared/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetails extends StatelessWidget {
  final String orderId;
  final List<dynamic> orderProducts;
  final String status;
  OrderDetails({this.orderId, this.orderProducts, this.status});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ORDER_DETAILS_TITLE),
        backgroundColor: Colors.purpleAccent[400],
      ),
      body: _buildOrderDetails(),
    );
  }

  Widget _buildItemsRow(int index) {
    print(status);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: orderProducts[index]['imageUrl'][0] ?? '',
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            height: 60,
            width: 60,
          ),
        ),
        Expanded(flex: 2, child: Text(orderProducts[index]['productName'])),
        Expanded(flex: 2, child: Text(orderProducts[index]['color'])),
        Expanded(flex: 2, child: Text(orderProducts[index]['productBrand'])),
      ],
    );
  }

  Widget _buildFirstRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(flex: 2, child: Text(PRODUCT_IMAGE, style: textStyle4)),
        Expanded(
            flex: 2,
            child: Text(
              PRODUCT_NAME,
              style: textStyle4,
            )),
        Expanded(flex: 2, child: Text(PRODUCT_COLOUR, style: textStyle4)),
        Expanded(flex: 2, child: Text(PRODUCT_BRAND, style: textStyle4)),
      ],
    );
  }

  Widget _buildListViewItems() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 20,
        );
      },
      itemCount: orderProducts.length ?? 0,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 10,
              child: _buildItemsRow(index),
            )
          ],
        );
      },
    );
  }

  Widget _buildBottomSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(children: [
        Row(
          children: <Widget>[
            new Expanded(
              flex: 2,
              child: Text(
                ORDER_ITEMS_COUNT,
                style: textStyle4,
              ),
            ),
            new Expanded(
              flex: 1,
              child: Text(orderProducts.length.toString()),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            new Expanded(
                flex: 3,
                child: Text(
                  ORDER_DETAILS_SUMMARY,
                  style: textStyle5,
                ))
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            new Expanded(
              flex: 2,
              child: Text(
                ORDER_STATUS,
                style: textStyle4,
              ),
            ),
            new Expanded(
              flex: 1,
              child: Text(
                status != null ? status : 'Pending',
                style: TextStyle(
                    color: status == 'Pending' || status == null
                        ? Colors.amber
                        : Colors.green),
              ),
            )
          ],
        )
      ]),
    );
  }

  Widget _buildOrderDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Column(
        children: <Widget>[
          Expanded(flex: 1, child: _buildFirstRow()),
          SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 5,
            child: _buildListViewItems(),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 3,
            child: _buildBottomSummary(),
          )
        ],
      ),
    );
  }
}
