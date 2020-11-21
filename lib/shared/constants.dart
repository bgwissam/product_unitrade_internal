import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white12,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  ),
);

const labelTextStyle = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: Colors.grey,
);

const labelTextStyle2 = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  shadows: [
    Shadow(blurRadius: 10.0, color: Colors.grey, offset: Offset(2.0, 2.0))
  ],
);

const labelTextStyle3 = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w300,
  color: Colors.black,
);

const textStyle1 = TextStyle(fontSize: 18.0, fontFamily: 'San Francisco');

const textStyle2 = TextStyle(
  fontSize: 12.0,
  fontFamily: 'San Francisco',
  fontWeight: FontWeight.bold,
);

const textStyle3 = TextStyle(
  fontSize: 18.0,
  fontFamily: 'San Francisco',
  fontWeight: FontWeight.bold,
  color: Colors.blueGrey,
);

const textStyle4 = TextStyle(
  fontSize: 16.0,
  fontFamily: 'San Francisco',
  fontWeight: FontWeight.bold,
);
const textStyle5 = TextStyle(fontSize: 14.0, fontFamily: 'San Francisco');

const textStyle6 = TextStyle(fontSize: 18.0, fontFamily: 'San Francisco');

const textStyle7 =
    TextStyle(fontSize: 14.0, fontFamily: 'San Francisco', color: Colors.blue);

const textStyle8 =
    TextStyle(fontSize: 36.0, fontFamily: 'San Fransisco', color: Colors.blue);

const textStyle9 = 
    TextStyle(fontSize: 20.0, fontFamily: 'San Fransisco', color: Colors.white);

const textStyle10 = TextStyle(fontSize: 24.0, color: Colors.green);

const buttonStyle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white);

var inkWellButton = TextStyle(
    color: Colors.brown[400],
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    backgroundColor: Colors.grey[100]);
