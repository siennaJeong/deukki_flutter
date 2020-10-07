import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainCategory extends BaseWidget {
  @override
  _MainCategoryState createState() => _MainCategoryState();
}

class _MainCategoryState extends State<MainCategory> {

  @override
  Widget build(BuildContext context) {
    final AuthServiceAdapter authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);

    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("로그아웃"),
          onPressed: () async => authServiceAdapter.signOut().then((value) => Navigator.pushReplacementNamed(context, GetRoutesName.ROUTE_LOGIN))
        )
      ),
    );
  }
}

