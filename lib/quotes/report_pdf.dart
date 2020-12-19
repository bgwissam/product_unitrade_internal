import 'dart:typed_data';
import 'package:Products/quotes/PDFDocumentViewer.dart';
import 'package:Products/services/email_management.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> reportView({
  context,
  List<List<dynamic>> quotationContent,
  List<Map<String, dynamic>> products,
  String quoteId,
  String clientName,
  String clientPhone,
  String clientEmail,
  String clientAddress,
  String salesmanName,
  String salesmanPhone,
  String salesmanEmail,
  String paymentTerms,
  double total,
  String textContent,
  String contactName,
  ByteData imageLogo,
}) async {
  //create a pdf document
  var pdf = PdfDocument();
  //add page to pdf
  PdfPage page = pdf.pages.add();
  //get page client size
  final Size pageSize = page.getClientSize();
  //Content pdf font
  final PdfFont contentFont = new PdfStandardFont(PdfFontFamily.helvetica, 15,
      style: PdfFontStyle.bold);
  //Draw logo
  drawLogo(pdf, page, pageSize, imageLogo);
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(142, 170, 219, 255)));
  //Generate pdf grid
  final PdfGrid grid = getGrid(products);
  //draw the header section by creating text elements
  final PdfLayoutResult result = drawHeader(page, pageSize, grid, clientName,
      clientPhone, clientAddress, total, quoteId);
  //Draw grid
  drawGrid(page, grid, result, contentFont, total, paymentTerms);
  //add footer
  drawFooter(page, pageSize);

  //save and launch the element
  final List<int> bytes = pdf.save();
  String _documentPath = 'UBD-Quotation.pdf';
  StorageReference storageReference;
  String _pdfUrl;
  String folderNameQuotes = 'Quotations';
  EmailManagement emailManagement = EmailManagement();
  bool quotationPdfSaved = false;
  var pdfUploadResult;
  try {
    // ByteData bytes2 = await DefaultAssetBundle.of(context).load(_documentPath);
    // final Uint8List list = bytes2.buffer.asUint8List();
    //get the storage location using path_provider
    final Directory dir = await getExternalStorageDirectory();
    final String path = dir.path;

    final File file =
        await File('$path/$_documentPath').create(recursive: true);

    await file.writeAsBytes(pdf.save());
    PDFDocument doc = await PDFDocument.fromFile(file);

    //save PDF quotation to firebase storage
    storageReference = FirebaseStorage.instance
        .ref()
        .child('$folderNameQuotes/$_documentPath');
    StorageUploadTask uploadTask = storageReference.putFile(file);

    var downLoadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    _pdfUrl = downLoadUrl.toString();
    //Upload downloaded pdf url and save it in the respective quotation
    if (_pdfUrl != null) {
      pdfUploadResult =
          await emailManagement.updateQuote(pdfUrl: _pdfUrl, uid: quoteId);
      if (pdfUploadResult != null) {
        quotationPdfSaved = true;
      } else {
        quotationPdfSaved = false;
      }
    }

    //Open the pdf document in the PDF Document Viewer
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PDFDocumentViewer(
              clientEmail: 'bgwissam@gmail.com',
              clientName: clientName,
              supplierEmail: salesmanEmail,
              subject: 'Paint Quote',
              contact: contactName,
              text: textContent,
              doc: doc,
              path: _pdfUrl,
            )));
  } catch (e) {
    print('Couldn\'t open pdf file: $e');
  }
}

//Draw Logo of Unitrade
void drawLogo(PdfDocument doc, PdfPage page, Size pageSize, ByteData imageLogo) {
  //read image data
  final Uint8List imageData = imageLogo.buffer.asUint8List();
  //load image using PdfBitmap
  final PdfBitmap image = PdfBitmap(imageData);
  //Draw image to pdf
  page.graphics.drawImage(image, Rect.fromLTWH(10, 10, pageSize.width - 140, 80));
}

//Draw Quotation Header
PdfLayoutResult drawHeader(
    PdfPage page,
    Size pageSize,
    PdfGrid grid,
    String clientName,
    String clientPhone,
    String clientAddress,
    double totalValue,
    String quoteId) {
  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 15);



  //Draws the rectangle that we will place in the net value
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
      brush: PdfSolidBrush(PdfColor(192, 192, 192, 5)));

  //Draw string Net Value of the pdf file
  page.graphics.drawString('Net Value', contentFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.bottom));
  //set the value value of the quotation in the currency required
  page.graphics.drawString('SAR ' + totalValue.toString(), contentFont,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
      brush: PdfBrushes.black,
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle));


  //Create data foramt and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');
  final String quoteNumber =
      'Quote#: $quoteId\r\n\r\nDate: ' + format.format(DateTime.now());
  final Size contentSize = contentFont.measureString(quoteNumber);
  String name = 'Name: $clientName';
  String phone = 'Contact: $clientPhone';
  String address = 'Address: $clientAddress';

  PdfTextElement(text: quoteNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
          contentSize.width + 30, pageSize.height - 120));

  return PdfTextElement(
          text: '$name\r\n\r$phone\r\n\r$address', font: contentFont)
      .draw(
          page: page,
          bounds: Rect.fromLTWH(
              30,
              120,
              pageSize.width - (contentSize.width + 30),
              pageSize.height - 120));
}

//Draws the body of the pdf file with the data of the products
void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result,
    PdfFont contentFont, double total, String paymentTerms) {
  Rect totalPriceCellBounds;
  Rect quantityCellBounds;
  double taxValue;
  double grandTotal;
  Size pageSize = page.getClientSize();
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(
      page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));

  if (total != null) taxValue = total * 0.15;
  grandTotal = total + taxValue;
  //Draw the Tax value
  page.graphics.drawString('Vat 15%: ', contentFont,
      bounds: Rect.fromLTWH(quantityCellBounds.left -30, result.bounds.bottom + 15,
          quantityCellBounds.width, quantityCellBounds.height));

  page.graphics.drawString(taxValue.toString(), contentFont,
      bounds: Rect.fromLTWH(
          totalPriceCellBounds.left,
          result.bounds.bottom + 15,
          totalPriceCellBounds.width,
          totalPriceCellBounds.height));

  //Draw grand total.
  page.graphics.drawString('Grand Total', contentFont,
      bounds: Rect.fromLTWH(quantityCellBounds.left - 30, result.bounds.bottom + 40,
          quantityCellBounds.width *2, quantityCellBounds.height));

  page.graphics.drawString(grandTotal.toString(), contentFont,
      bounds: Rect.fromLTWH(
          totalPriceCellBounds.left,
          result.bounds.bottom + 40,
          totalPriceCellBounds.width,
          totalPriceCellBounds.height));
  //Variables for the payment, delivery, and validity terms
  String payment = 'Payment Terms: $paymentTerms';
  String validity = 'Price Validity: These prices are valid for 15 days';
  String delivery =
      'Delivery: Material will be delievered to your warehouse if order exceeds 10,000 Riyal';
  Size contentSize = contentFont.measureString(payment);
  //Draw quotation terms box
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(5, 450, pageSize.width - 10, 120),
      brush: PdfSolidBrush(PdfColor(223, 242, 240)));

  PdfTextElement(
          text: '$payment\r\n\r$validity\r\n\r$delivery', font: contentFont)
      .draw(
          page: page,
          bounds: Rect.fromLTWH(
              25, 460, pageSize.width - 50, pageSize.height - 120));
}





//Draw the invoice footer data.
void drawFooter(PdfPage page, Size pageSize) {
  final PdfPen linePen =
      PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
      Offset(pageSize.width, pageSize.height - 100));

  const String footerContent =
      '''United Company for Industry and Trade, PO Box: XXXXX, Dammam, Riyadh, Jeddah''';

  //Added 30 as a margin for the layout
  page.graphics.drawString(
      footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
      bounds: Rect.fromLTWH(pageSize.width - 250, pageSize.height - 70, 0, 0));
}

//Create PDF grid and return
PdfGrid getGrid(List<Map<String, dynamic>> products) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  double totalValue = 0;
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = 'Product Code';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Product Name';
  headerRow.cells[2].value = 'Price';
  headerRow.cells[3].value = 'Quantity';
  headerRow.cells[4].value = 'Total';
  //Add rows
  for (int i = 0; i < products.length; i++) {
    var productCode = products[i]['itemCode'] ?? ' ';
    var productName = products[i]['itemDescription'] ?? ' ';
    double productQuantity = products[i]['quantity'] ?? 0;
    double productPrice = products[i]['price'] ?? 0;
    var productTotal = productQuantity * productPrice;
    totalValue += productTotal;
    addProducts(productCode, productName, productPrice, productQuantity,
        productTotal, grid);
  }

  //Apply the table built-in style
  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  //Set gird columns width
  grid.columns[1].width = 200;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding =
        PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }

  return grid;
}

//Create and row for the grid.
void addProducts(String productCode, String productName, double price,
    double quantity, double total, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = productCode;
  row.cells[1].value = productName;
  row.cells[2].value = price.toString();
  row.cells[3].value = quantity.toString();
  row.cells[4].value = total.toString();
}
