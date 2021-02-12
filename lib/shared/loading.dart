import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SpinKitWave(
            color: Colors.purple,
            size: 55.0,
          ),
        ),
      ),
    );
  }
}