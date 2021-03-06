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
  var productPack;
  var productPrice;
  var productCost;
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
      this.productCost,
      this.color,
      this.description,
      this.productTags,
      this.imageListUrls,
      this.imageLocalUrl,
      this.pdfUrl});
}

class WoodProduct {
  String uid;
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  var length;
  var width;
  var thickness;
  double productPack;
  String color;
  String description;
  var productPrice;
  var productCost;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;
  String pdfUrl;

  WoodProduct(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.length,
      this.width,
      this.thickness,
      this.productPack,
      this.color,
      this.description,
      this.productPrice,
      this.productCost,
      this.productTags,
      this.imageListUrls,
      this.pdfUrl});
}

class SolidProduct {
  String uid;
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  var length;
  var width;
  var thickness;
  var productPack;
  String color;
  String description;
  var productPrice;
  var productCost;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;
  String pdfUrl;

  SolidProduct(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.length,
      this.width,
      this.thickness,
      this.productPack,
      this.color,
      this.description,
      this.productPrice,
      this.productCost,
      this.productTags,
      this.imageListUrls,
      this.pdfUrl});
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
  String itemCode;
  String productName;
  String productType;
  String productCategory;
  String productBrand;
  var length;
  var angle;
  String closingType;
  String color;
  String description;
  String extensionType;
  String itemSide;
  var productPrice;
  var productCost;
  List<dynamic> productTags;
  List<dynamic> imageListUrls;
  String pdfUrl;

  Accessories(
      {this.uid,
      this.itemCode,
      this.productName,
      this.productType,
      this.productCategory,
      this.productBrand,
      this.length,
      this.angle,
      this.closingType,
      this.color,
      this.description,
      this.extensionType,
      this.itemSide,
      this.productPrice,
      this.productCost,
      this.productTags,
      this.imageListUrls,
      this.pdfUrl});
}

class Orders {
  String orderId;
  String userId;
  List<dynamic> orderProducts;
  String status;
  Timestamp date;
  Orders(
      {this.orderId, this.userId, this.orderProducts, this.date, this.status});
}

class QuoteItems {
  String itemCode;
  String itemPack;
  double quantity;
  double price;
  double tax;
  QuoteItems(
      {this.itemCode, this.itemPack, this.quantity, this.price, this.tax});
}
