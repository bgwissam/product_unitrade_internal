import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LoadFile {
  Directory document;
  File file;
  List<String> cartList;

  //Get the values of the cart list save on the internal storage
  Future loadDocument() async {
    cartList = new List();
    document = await getApplicationDocumentsDirectory();
    file = new File('${document.path}/cartList.txt');
    try {
      file.createSync(recursive: true);
      if (file.existsSync()) {
        await file.readAsLines().then((value) {
          for (var data in value) {
            cartList.add(data);
          }
        });

        return cartList;
      }
    } catch (e) {
      print('error loading file in cart $e');
    }
  }

  //will update the document with new values
  Future updateDocument(List<String> cartList) async {
    document = await getApplicationDocumentsDirectory();
    file = new File('${document.path}/cartList.txt');
    file.createSync(recursive: true);
    try {
      IOSink cartFile = file.openWrite();
      for (var data in cartList) {
        cartFile.writeln(data);
      }
      cartFile.close();
    } catch (e) {
      print('error loading file in cart $e');
    }
  }

  //will delete the document file
  Future deleteDocument() async {
    try {
      document = await getApplicationDocumentsDirectory();
      file = new File('${document.path}/cartList.txt');
      file.delete();
    } catch (e) {
      print('error trying to delete file $e');
    }
  }

  //Read cart local storage file
  Future readCartList() async {
    try {
      if (file.existsSync()) {
        Future<List<String>> currentContent = file.readAsLines();
        currentContent.then((value){
          
        });
      } else {
        print('couldn\'t read file');
      }
    } catch (e) {
      print('couldn\'t read data from the local storage file due to: $e');
    }
  }

  //Will write to file
  Future writeToDocument(List<String> newCart) async {
    cartList = new List();
    try {
      document = await getApplicationDocumentsDirectory();
      file = new File('${document.path}/cartList.txt');
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        print('file did not exists ');
      }
      IOSink cartFile = file.openWrite();
      for (var data in newCart) {
        cartFile.writeln(data);
      }
      cartFile.close();
    } catch (e) {
      print('Couldn\'t open file $e');
    }
  }

}
