import 'package:Products/shared/loading.dart';
import 'package:flutter/material.dart';

class ShowCustomDialog extends StatefulWidget {
  final title;
  ShowCustomDialog({this.title});
  @override
  _ShowCustomDialogState createState() => _ShowCustomDialogState();
}

class _ShowCustomDialogState extends State<ShowCustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: const Color(0xFF0E3311).withOpacity(0.5),
          height: 100.0,
          width: 150.0,
          child: Loading(),
        )
      ],
    );
  }
}
