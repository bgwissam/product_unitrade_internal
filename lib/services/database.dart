import 'package:Products/models/clients.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Products/models/products.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference unitradeCollection =
      Firestore.instance.collection('users');
  final CollectionReference brandCollection =
      Firestore.instance.collection('brands');
  final CollectionReference paintCollection =
      Firestore.instance.collection('paint');
  final CollectionReference woodCollection =
      Firestore.instance.collection('wood');
  final CollectionReference solidCollection =
      Firestore.instance.collection('solid');
  final CollectionReference cartCollection =
      Firestore.instance.collection('cart');
  final CollectionReference lightsCollection =
      Firestore.instance.collection('lights');
  final CollectionReference accessoriesCollection =
      Firestore.instance.collection('accessories');
  final CollectionReference clientCollection =
      Firestore.instance.collection('clients');

  //Update the user data
  Future<String> updateUserData(
      {String uid,
      String firstName,
      String lastName,
      String company,
      bool isAdmin,
      bool isPriceAdmin,
      bool isSuperAdmin,
      String phoneNumber,
      String emailAddress,
      String countryOfResidence,
      String cityOfResidence}) async {
    try {
      return await unitradeCollection.document(uid).setData({
        'firstName': firstName,
        'lastName': lastName,
        'company': company,
        'isAdmin': isAdmin,
        'isPriceAdmin': isPriceAdmin,
        'isSuperAdmin': isSuperAdmin,
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
        'countryOfResidence': countryOfResidence,
        'cityOfResidence': cityOfResidence
      }).then((value) {
        return 'your data has been updated successfully';
      });
    } catch (e) {
      return ' $e';
    }
  }

  //User data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        firstName: snapshot.data['firstName'] ?? '',
        lastName: snapshot.data['lastName'] ?? '',
        company: snapshot.data['company'] ?? '',
        phonNumber: snapshot.data['phoneNumber'],
        countryOfResidence: snapshot.data['countryOfResidence'],
        cityOfResidence: snapshot.data['cityOfResidnce'],
        isAdmin: snapshot.data['isAdmin'] ?? false,
        isPriceAdmin: snapshot.data['isPriceAdmin'] ?? false,
        isSuperAdmin: snapshot.data['isSuperAdmin'] ?? false);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return unitradeCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  //This section is to manage brand data
  //add a new brand
  Future addBrandData(
      {String brandName,
      String countryOfOrigin,
      String division,
      List<dynamic> category,
      String imageUrl}) async {
    try {
      brandCollection.add({
        'brandName': brandName,
        'countryOfOrigin': countryOfOrigin,
        'category': category ?? '',
        'division': division ?? '',
        'imageUrl': imageUrl ?? '',
      }).then((val) => print('The Brand is saved'));
    } catch (e) {
      print('could not add brand: ' + e.toString());
    }
  }

  //update current brand
  Future updateBrandData(
      {String uid,
      String brandName,
      String countryOfOrigin,
      String division,
      List<dynamic> category,
      String imageUrl}) async {
    try {
      brandCollection.document(uid).setData({
        'brandName': brandName,
        'countryOfOrigin': countryOfOrigin,
        'division': division ?? '',
        'category': category ?? '',
        'imageUrl': imageUrl ?? '',
      });
    } catch (e) {
      print('could not update brand: ' + e.toString());
    }
  }

  //Brand data from snapshot
  List<Brands> _brandDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brands(
          uid: doc.documentID,
          brand: doc.data['brandName'] ?? '',
          countryOrigin: doc.data['countryOfOrigin'] ?? '',
          division: doc.data['division'] ?? '',
          category: doc.data['category'] ?? null,
          image: doc.data['imageUrl'] ?? '');
    }).toList();
  }

  //Brand data from snapshot for product drop downlist
  Future<List<Brands>> brandDataForDropdownMenu() async {
    try {
      QuerySnapshot brandDoc = await brandCollection.getDocuments();
      List<Brands> brands = brandDoc.documents.map((doc) {
        Brands(
            uid: doc.documentID,
            brand: doc.data['brandName'] ?? '',
            countryOrigin: doc.data['countryOfOrigin'] ?? '',
            division: doc.data['division'] ?? '',
            category: doc.data['category'],
            image: doc.data['imageUrl'] ?? '');
      }).toList();
      return brands;
    } catch (e) {
      print('Could not retreive the brand list data $e');
      return null;
    }
  }

  //Delete Brand from database
  Future deleteBrandData(String uid, String imageUid) async {
    try {
      await brandCollection.document(uid).delete();
      await FirebaseStorage.instance.getReferenceFromUrl(imageUid).then((res) {
        res.delete().then((res) {
          print('Image has been deleted');
        });
      });
    } catch (e) {
      print('could not delete due to: $e');
    }
  }

  //get brands doc from Stream
  Stream<List<Brands>> get brands {
    return brandCollection.snapshots().map(_brandDataFromSnapshot);
  }

  //get brands depending on category
  Stream<List<Brands>> categoryBrands(String category) {
    return brandCollection
        .where('category', arrayContainsAny: [
          category,
          category.toLowerCase(),
          category.toUpperCase()
        ])
        .snapshots()
        .map(_brandDataFromSnapshot);
  }

  //This part will involve data regarding client and transactions
  //against them.
  //Add clients to the database
  Future addClient(
      {String clientName,
      String clientPhone,
      String clientAddress,
      String clientSector,
      String email,
      String salesInCharge}) async {
    try {
      return clientCollection.add({
        'clientName': clientName,
        'clientPhone': clientPhone,
        'clientAddress': clientAddress,
        'clientSector': clientSector,
        'clientEmail': email,
        'salesInCharge': salesInCharge
      }).then((value) => value);
    } catch (e) {
      print('An error occured in adding the client: $e');
    }
  }

  //Update client data
  Future updateClient(
      {String uid,
      String clientName,
      String clientPhone,
      String clientAddress,
      String clientSector,
      String email}) async {
    try {
      return clientCollection.document(uid).updateData({
        'clientName': clientName,
        'clientPhone': clientPhone,
        'clientAddress': clientAddress,
        'clientSector': clientSector,
        'clientEmail': email,
      }).then((value) => value);
    } catch (e) {
      print('Client could not be updated: $e');
    }
  }

  //Delete client from database to be done only by admin users
  Future deleteClient({String uid, bool isAdmin}) async {
    try {
      if (isAdmin) {
        return clientCollection
            .document(uid)
            .delete()
            .then((value) => print('Client was successfully deleted'));
      }
      return;
    } catch (e) {
      print('Client could not be deleted');
    }
  }

  //get client from database
  List<Clients> _clientDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Clients(
          uid: doc.documentID,
          clientName: doc.data['clientName'],
          clientPhoneNumber: doc.data['clientPhone'],
          clientCity: doc.data['clientAddress'],
          clientBusinessSector: doc.data['clientSector'],
          email: doc.data['clientEmail'],
          salesInCharge: doc.data['salesInCharge']);
    }).toList();
  }


  //Stream client data by client id
  Stream<List<Clients>> clientDataById({String uid}) {
    return clientCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_clientDataFromSnapshot);
  }

  //Stream client data by client name
  Stream<List<Clients>> clientDatabyName({String clientName}) {
    return clientCollection
        .where('clientName', isEqualTo: clientName)
        .snapshots()
        .map(_clientDataFromSnapshot);
  }

  //Stream all client from the database
  Stream<List<Clients>> get allClients {
    return clientCollection.snapshots().map(_clientDataFromSnapshot);
  }

  //Stream clients for a particular sales person
  Stream<List<Clients>> clientDataBySalesId({String salesId}) {
    return clientCollection
        .where('salesInCharge', isEqualTo: salesId)
        .snapshots()
        .map(_clientDataFromSnapshot);
  }

  //Stream client email for selected client
  Stream<List<Clients>> clientEmailByName({String name}) {
    return clientCollection
        .where('clientName', isEqualTo: name)
        .snapshots()
        .map(_clientDataFromSnapshot);
  }

  //This section is for managing products by type
  //depending on the type of the product selected we update a different collection
  //Add a new paint product
  Future addPaintProduct(
      {String itemCode,
      String productName,
      String productBrand,
      String productType,
      String productPackUnit,
      double productPack,
      double productPrice,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String imageLocalUrl,
      String pdfUrl}) async {
    try {
      paintCollection.add({
        'itemCode': itemCode,
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'productPackUnit': productPackUnit,
        'productPackValue': productPack,
        'productPrice': productPrice,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls,
        'imageLocalUrl': imageLocalUrl,
        'pdfUrl': pdfUrl
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current paint product
  Future updatePaintProduct(
      {String uid,
      String itemCode,
      String productName,
      String productBrand,
      String productType,
      String productPackUnit,
      double productPack,
      double productPrice,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls,
      String imageLocalUrl,
      String pdfUrl}) async {
    try {
      return paintCollection.document(uid).setData({
        'itemCode': itemCode,
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'productPackUnit': productPackUnit,
        'productPackValue': productPack,
        'productPrice': productPrice,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls,
        'imageLocalUrl': imageLocalUrl,
        'pdfUrl': pdfUrl
      }).then((value) => print('Paint data updated'));
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Update only the price field
  Future updatePaintPriceField({String uid, double productPrice}) async {
    await paintCollection
        .document(uid)
        .updateData({'productPrice': productPrice}).then(
            (value) => print('Product price updated'));
  }

  //Delete a paint product
  Future deletePaintProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await paintCollection.document(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance
            .getReferenceFromUrl(imageUid)
            .then((res) {
          res.delete().then((res) {
            print('Image has been deleted');
          });
        });
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get a list of paint product
  List<PaintMaterial> _productDataFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return PaintMaterial(
          uid: doc.documentID,
          itemCode: doc.data['itemCode'],
          productName: doc.data['productName'],
          productBrand: doc.data['productBrand'],
          productType: doc.data['productType'],
          productPackUnit: doc.data['productPackUnit'],
          productPack: doc.data['productPackValue'],
          productPrice: doc.data['productPrice'],
          productCategory: doc.data['productCategory'],
          color: doc.data['color'],
          description: doc.data['description'],
          productTags: doc.data['tags'],
          imageListUrls: doc.data['imageListUrls'],
          imageLocalUrl: doc.data['imageLocalUrl'],
          pdfUrl: doc.data['pdfUrl']);
    }).toList();
  }

  //Stream data from paint document
  Stream<List<PaintMaterial>> paintProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTag,
      String productColor}) {
    var color;
    if (productColor == 'clear') {
      color = 'CLEAR';
    } else if (productColor == 'pigmented') {
      color = 'WHITE';
    } else {
      color = null;
    }
    return paintCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .where('color', isEqualTo: color)
        .snapshots()
        .map(_productDataFromSnapShot);
  }

  //Stream data from paint document using a tag
  Stream<List<PaintMaterial>> paintProductsTags({String tags}) {
    Stream<QuerySnapshot> stream = paintCollection
        .orderBy('productName')
        .startAt([tags.toUpperCase()]).endAt([tags + '\uf8ff']).snapshots();
    return stream.map(_productDataFromSnapShot);
  }

  //Stream data from paint document reference to its id
  Stream<List<PaintMaterial>> paintProductId(String uid) {
    return paintCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_productDataFromSnapShot);
  }

  //Stream all paint product
  Stream<List<PaintMaterial>> get allPaintProduct {
    return paintCollection.snapshots().map(_productDataFromSnapShot);
  }

  //Section for wood products
  //Adding a new wood product
  Future addWoodProduct(
      {String productName,
      String productBrand,
      String productType,
      var length,
      var width,
      var thickness,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      woodCollection.add({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current wood product
  Future updateWoodProduct(
      {String uid,
      String productName,
      String productBrand,
      String productType,
      var length,
      var width,
      var thickness,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      woodCollection.document(uid).setData({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Delete current wood product
  Future deleteWoodProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await woodCollection.document(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance
            .getReferenceFromUrl(imageUid)
            .then((res) {
          res.delete().then((res) {
            print('Image has been deleted');
          });
        });
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get List of wood product
  List<WoodProduct> _woodProductDataFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return WoodProduct(
          uid: doc.documentID,
          productName: doc.data['productName'],
          productBrand: doc.data['productBrand'],
          productType: doc.data['productType'],
          length: doc.data['length'],
          width: doc.data['width'],
          thickness: doc.data['thickness'],
          productCategory: doc.data['productCategory'],
          color: doc.data['color'],
          description: doc.data['description'],
          productTags: doc.data['tags'],
          imageListUrls: doc.data['imageListUrls']);
    }).toList();
  }

  //Stream data from wood document
  Stream<List<WoodProduct>> woodProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTags}) {
    return woodCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_woodProductDataFromSnapShot);
  }

  //Stream data from paint document using a tag
  Stream<List<WoodProduct>> woodProductsTags({String tags}) {
    Stream<QuerySnapshot> stream = woodCollection
        .orderBy('productName')
        .startAt([tags.toUpperCase()]).endAt([tags + '\uf8ff']).snapshots();
    return stream.map(_woodProductDataFromSnapShot);
  }

  //Stream data from wood collection reference to its id
  Future<List<WoodProduct>> woodProductIdList(String uid) async {
    var document;
    try {
      document = await woodCollection.document(uid).get();
      print('the received docuement $document');
    } catch (e) {
      print(e);
    }

    return document;
  }

  //stream wood products by id
  Stream<List<WoodProduct>> woodProductId(String uid) {
    return woodCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_woodProductDataFromSnapShot);
  }

  //get all wood products
  Stream<List<WoodProduct>> get allWoodProduct {
    return woodCollection.snapshots().map(_woodProductDataFromSnapShot);
  }

  //Section for solid surface products
  //adding a new solid surface product
  Future addSolidSurfaceProduct(
      {String productName,
      String productBrand,
      String productType,
      var length,
      var width,
      var thickness,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      solidCollection.add({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current wood product
  Future updateSolidSurfaceProduct(
      {String uid,
      String productName,
      String productBrand,
      String productType,
      String length,
      String width,
      String thickness,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      solidCollection.document(uid).setData({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'width': width,
        'thickness': thickness,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Delete current wood product
  Future deletesolidSurfaceProduct(
      {String uid, List<dynamic> imageUids}) async {
    try {
      await solidCollection.document(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance
            .getReferenceFromUrl(imageUid)
            .then((res) {
          res.delete().then((res) {
            print('Image has been deleted');
          });
        });
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get List of solid surface product
  List<WoodProduct> _solidSurfcaeProductDataFromSnapShot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return WoodProduct(
          uid: doc.documentID,
          productName: doc.data['productName'],
          productBrand: doc.data['productBrand'],
          productType: doc.data['productType'],
          length: doc.data['length'],
          width: doc.data['width'],
          thickness: doc.data['thickness'],
          productCategory: doc.data['productCategory'],
          color: doc.data['color'],
          description: doc.data['description'],
          productTags: doc.data['tags'],
          imageListUrls: doc.data['imageListUrls']);
    }).toList();
  }

  //Stream data from solid surface document
  Stream<List<WoodProduct>> solidSurfaceProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTags}) {
    return solidCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_solidSurfcaeProductDataFromSnapShot);
  }

  //Stream item from solid surface document reference to its id
  Stream<List<WoodProduct>> solidSurfaceProductId(String uid) {
    return solidCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_solidSurfcaeProductDataFromSnapShot);
  }

  //Sections for light products
  //Adding light products
  Future addLightsProduct(
      {String productName,
      String productBrand,
      String productType,
      String dimensions,
      String watt,
      String voltage,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      lightsCollection.add({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'dimenions': dimensions,
        'watt': watt,
        'voltage': voltage,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current light product
  Future updateLightsProduct(
      {String uid,
      String productName,
      String productBrand,
      String productType,
      String productCategory,
      String dimensions,
      String voltage,
      String watt,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      lightsCollection.document(uid).setData({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'productCategory': productCategory,
        'dimensions': dimensions,
        'voltage': voltage,
        'watt': watt,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Delete current light product
  Future deleteLightsProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await lightsCollection.document(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance
            .getReferenceFromUrl(imageUid)
            .then((res) {
          res.delete().then((res) {
            print('Image has been deleted');
          });
        });
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get List of lights product
  List<Lights> _lightsProductDataFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Lights(
          uid: doc.documentID,
          productName: doc.data['productName'],
          productBrand: doc.data['productBrand'],
          productType: doc.data['productType'],
          dimensions: doc.data['dimensions'],
          voltage: doc.data['voltage'],
          watt: doc.data['watt'],
          productCategory: doc.data['productCategory'],
          color: doc.data['color'],
          description: doc.data['description'],
          productTags: doc.data['tags'],
          imageListUrls: doc.data['imageListUrls']);
    }).toList();
  }

  //Stream data from lights document
  Stream<List<Lights>> lightsProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTags}) {
    return lightsCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_lightsProductDataFromSnapShot);
  }

  //Stream item from lights document reference to its id
  Stream<List<Lights>> lightsProductId(String uid) {
    return lightsCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_lightsProductDataFromSnapShot);
  }

  //Section for Accessories
  //Adding Accessories products
  Future addAccessoriesProduct(
      {String productName,
      String productBrand,
      String productType,
      String length,
      String angle,
      String closingType,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      accessoriesCollection.add({
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'angle': angle,
        'closingType': closingType,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be added $e');
    }
  }

  //Update a current accessory product
  Future updateAccessoriesProduct(
      {String uid,
      String productName,
      String productBrand,
      String productType,
      String length,
      String angle,
      String closingType,
      String productCategory,
      String color,
      String description,
      List<dynamic> productTags,
      List<dynamic> imageListUrls}) async {
    try {
      accessoriesCollection.document(uid).setData({
        'uid': uid,
        'productName': productName,
        'productBrand': productBrand,
        'productType': productType,
        'length': length,
        'angle': angle,
        'closingType': closingType,
        'productCategory': productCategory,
        'color': color,
        'description': description,
        'tags': productTags,
        'imageListUrls': imageListUrls
      });
    } catch (e) {
      print('Product could not be updated $e');
    }
  }

  //Delete current accessory product
  Future deleteAccessoriesProduct({String uid, List<dynamic> imageUids}) async {
    try {
      await accessoriesCollection.document(uid).delete();
      for (var imageUid in imageUids)
        await FirebaseStorage.instance
            .getReferenceFromUrl(imageUid)
            .then((res) {
          res.delete().then((res) {
            print('Image has been deleted');
          });
        });
    } catch (e) {
      print('Product could not be deleted $e');
    }
  }

  //Get List of accessory product
  List<Accessories> _accessoriesProductDataFromSnapShot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Accessories(
          uid: doc.documentID,
          productName: doc.data['productName'],
          productBrand: doc.data['productBrand'],
          productType: doc.data['productType'],
          length: doc.data['length'],
          angle: doc.data['angle'],
          closingType: doc.data['closingType'],
          productCategory: doc.data['productCategory'],
          color: doc.data['color'],
          description: doc.data['description'],
          productTags: doc.data['tags'],
          imageListUrls: doc.data['imageListUrls']);
    }).toList();
  }

  //Stream data from accessories document
  Stream<List<Accessories>> accessoriesProducts(
      {String brandName,
      String productType,
      String productCategory,
      String productTags}) {
    return accessoriesCollection
        .where('productBrand', isEqualTo: brandName)
        .where('productType', isEqualTo: productType)
        .where('productCategory', isEqualTo: productCategory)
        .snapshots()
        .map(_accessoriesProductDataFromSnapShot);
  }

  //Stream item from accessories document reference to its id
  Stream<List<Accessories>> accessoriesProductId(String uid) {
    return accessoriesCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_accessoriesProductDataFromSnapShot);
  }
}
