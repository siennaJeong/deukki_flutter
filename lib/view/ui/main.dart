import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainCategory extends BaseWidget {
  @override
  _MainCategoryState createState() => _MainCategoryState();
}

class _MainCategoryState extends State<MainCategory> {
  AuthServiceAdapter authServiceAdapter;
  //DBHelper dbHelper;

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    //dbHelper = Provider.of<DBHelper>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Text('main')
          ],
        )
      ),
    );
  }
}

