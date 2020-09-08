import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/provider/login/auth_service.dart';
import 'package:deukki/provider/login/auth_service_adapter.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:flutter/material.dart';

class MainCategory extends BaseWidget {
  @override
  _MainCategoryState createState() => _MainCategoryState();
}

class _MainCategoryState extends State<MainCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("로그아웃"),
          onPressed: () => AuthServiceAdapter().signOut(context, SharedHelper.getStringSharedPref(AuthService.AUTH_TYPE, ""))
        )
      ),
    );
  }
}

