// //Class is not being used

// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class QuotationPDFViewer extends StatefulWidget {
//   final String path;
//   final String customerName;
//   QuotationPDFViewer({Key key, this.path, this.customerName}) : super(key: key);
//   @override
//   _QuotationPDFViewerState createState() => _QuotationPDFViewerState();
// }

// class _QuotationPDFViewerState extends State<QuotationPDFViewer> {
//   int pages = 0;
//   int currentPage = 0;
//   bool isReady = false;

//   String errorMessage;
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Customer Quotation',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.customerName),
//           backgroundColor: Colors.blue[300],
//         ),
//         body: Center(
//           child: Builder(
//             builder: (context) {
//               return Stack(
//                 children: [
//                   PDFView(
//                     filePath: widget.path,
//                     enableSwipe: true,
//                     swipeHorizontal: true,
//                     autoSpacing: false,
//                     pageFling: true,
//                     pageSnap: true,
//                     defaultPage: currentPage,
//                     fitPolicy: FitPolicy.BOTH,
//                     preventLinkNavigation: false,
//                     onRender: (_pages) {
//                       setState(() {
//                         pages = _pages;
//                         isReady = true;
//                       });
//                     },
//                     onError: (error) {
//                       setState(() {
//                         print('there is an error 1');
//                         errorMessage = error.toString();
//                       });
//                       print(error.toString());
//                     },
//                     onPageError: (page, error) {
//                       setState(() {
//                         print('there is an error 2');
//                         errorMessage = '$page: ${error.toString()}';
//                       });
//                       print('$page: ${error.toString()}');
//                     },
//                     onLinkHandler: (String uri) {
//                       print('goto uri: $uri');
//                     },
//                     onPageChanged: (int page, int total) {
//                       print('page change: $page/$total');
//                       setState(() {
//                         currentPage = page;
//                       });
//                     },
//                   )
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
