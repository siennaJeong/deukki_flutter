import 'package:deukki/common/utils/routeUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
        routes: routes,
      )
  );
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("hello"),
      ),
    );
  }
}