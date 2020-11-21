import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SpinKitDualRing(
            color: Colors.yellow,
            size: 75.0,
          ),
        ),
      ),
    );
  }
}