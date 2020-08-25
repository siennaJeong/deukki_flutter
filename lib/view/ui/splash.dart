import 'package:deukki/common/utils/routeUtil.dart';
import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      routes: routes,
    )
);

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("hi"),
    );
  }
}
