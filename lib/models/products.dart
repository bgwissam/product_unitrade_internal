import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  final String uid;

  Brand({this.uid});
}

class Brands {
  final String uid;
  final String brand;
  final String countryOrigin;
  final List<dynamic> category;
  final String division;
  final String image;

  Brands(
      {this.uid,
      this.brand,
      this.countryOrigin,
      this.division,
      this.category,
      this.image});
}

class Product {
  final String uid;
  Product({this.uid});
}

class PaintMaterial {
  String uid;
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  String productPackUnit;
  double productPack;
  double productPrice;
  String color;
  String description;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;
  String imageLocalUrl;
  String pdfUrl;

  PaintMaterial(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.productPackUnit,
      this.productPack,
      this.productPrice,
      this.color,
      this.description,
      this.productTags,
      this.imageListUrls,
      this.imageLocalUrl,
      this.pdfUrl});
}

class WoodProduct {
  String uid;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  String length;
  String width;
  String thickness;
  String color;
  String description;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;

  WoodProduct(
      {this.uid,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.length,
      this.width,
      this.thickness,
      this.color,
      this.description,
      this.productTags,
      this.imageListUrls});
}

class Lights {
  String uid;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  String dimensions;
  String voltage;
  String watt;
  String color;
  String description;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;

  Lights(
      {this.uid,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.dimensions,
      this.voltage,
      this.watt,
      this.color,
      this.description,
      this.productTags,
      this.imageListUrls});
}

class Accessories {
  String uid;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  String length;
  String angle;
  String closingType;
  String color;
  String description;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;

  Accessories({
    this.uid,
    this.productName,
    this.productType,
    this.productCategory,
    this.productBrand,
    this.length,
    this.angle,
    this.closingType,
    this.color,
    this.description,
    this.productTags,
    this.imageListUrls
  });
}

class Orders {
  String orderId;
  String userId;
  List<dynamic> orderProducts;
  String status;
  Timestamp date;
  Orders({this.orderId, this.userId, this.orderProducts, this.date, this.status});
}

class QuoteItems {
  String itemCode;
  String itemPack;
  double quantity;
  double price;
  double tax;
  QuoteItems({
    this.itemCode,
    this.itemPack,
    this.quantity,
    this.price,
    this.tax
  });

}
