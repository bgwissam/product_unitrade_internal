import 'package:Products/models/clients.dart';
import 'package:Products/models/products.dart';
import 'package:Products/no_data/no_data.dart';
import 'package:Products/quotes/quotation_form.dart';
import 'package:Products/services/database.dart';
import 'package:Products/shared/dialog.dart';
import 'package:Products/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'client_list.dart';

class ClientGrid extends StatefulWidget {
  final String userId;
  final bool quotation;

  ClientGrid({this.userId, this.quotation});
  @override
  _ClientGridState createState() => _ClientGridState();
}

class _ClientGridState extends State<ClientGrid> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Clients>>.value(
        value: DatabaseService().clientDataBySalesId(salesId: widget.userId),
        child: StreamProvider<List<PaintMaterial>>.value(
          value: DatabaseService().allPaintProduct,
          child: widget.quotation
              ? QuotationProviderBuild(
                  userId: widget.userId,
                )
              : clientBuild(),
        ));
  }

  //build the client build widget
  Widget clientBuild() {
    return Scaffold(
      appBar: AppBar(
        title: Text(CLIENT_LIST),
        backgroundColor: Colors.blueGrey[500],
      ),
      body: ClientList(),
    );
  }
}

//build the provider for the client's quotations
class QuotationProviderBuild extends StatefulWidget {
  final String userId;
  QuotationProviderBuild({this.userId});
  @override
  _QuotationProviderBuildState createState() => _QuotationProviderBuildState();
}

class _QuotationProviderBuildState extends State<QuotationProviderBuild> {
  Map<String, String> productsWithDescription = new Map();
  List<String> itemCodes = [];
  List<String> productNames = [];
  @override
  Widget build(BuildContext context) {
    var clientProvider = Provider.of<List<Clients>>(context) ?? [];
    var paintProducts = Provider.of<List<PaintMaterial>>(context) ?? [];

    if (clientProvider.isNotEmpty)
      return Container(
        child: FutureBuilder(
            future: _getProductData(paintProducts),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return QuotationForm(
                    userId: widget.userId,
                    clients: clientProvider,
                    productsWithDescription: productsWithDescription,
                    products: paintProducts,
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ShowCustomDialog();
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Container(
                    height: 100.0,
                    width: 100.0,
                    child: Text('Could not get product data'),
                  );
                }
              } else {
                return ShowCustomDialog();
              }
              return ShowCustomDialog();
            },
            
            ),
      );
    else
      return NoDataExists(
        contexttext: 'No available clients in your database exist',
        title: 'Quotation Form',
      );
  }

  Future<Map<String, String>> _getProductData(
      List<PaintMaterial> paintProduct) async {
    itemCodes = [];
    productNames = [];
    itemCodes.addAll(paintProduct.map((e) => e.itemCode));
    //productNames.addAll(widget.products.map((e) => e.productName));
    productNames = await settingDescription(paintProduct);
    //check the products have their description before proceeding
    if (productNames.isNotEmpty) {
      productsWithDescription = Map.fromIterables(itemCodes, productNames);
      
    }

    return productsWithDescription;
  }

  //will await the product names to be set into the list
  Future<List<String>> settingDescription(
      List<PaintMaterial> paintProduct) async {
    List<String> productNamesDescription = [];
    productNamesDescription.addAll(paintProduct.map((e) => e.productName));

    return productNamesDescription;
  }
}
