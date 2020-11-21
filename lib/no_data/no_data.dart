import 'package:flutter/material.dart';

class NoDataExists extends StatelessWidget {
  final String contexttext;
  final String title;
  NoDataExists({this.contexttext, this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Center(child: Text(contexttext)),
          )
        ],),
    );
  }
}