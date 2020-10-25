import 'dart:ui';

import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/ui/app/app_theme.dart';
import 'package:deukki/view/ui/base/base_button_dialog.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/m_scroll_behavior.dart';
import 'package:deukki/view/ui/base/provider_widget.dart';
import 'package:deukki/view/ui/signin/login.dart';
import 'package:deukki/view/ui/category/main.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
  .then((_) {
    runApp(
        MultiProvider(
            providers: [
              Provider<DBHelper>(
                create: (context) => DBHelper(),
                lazy: true,
              ),
              Provider<SharedHelper>(
                create: (context) => SharedHelper(),
                lazy: true,
              ),
              ChangeNotifierProvider<ResourceProviderModel>(
                create: (context) => ResourceProviderModel.build(),
                lazy: true,
              ),
              ChangeNotifierProxyProvider2<SharedHelper, DBHelper, AuthServiceAdapter>(
                create: (context) => AuthServiceAdapter("", sharedHelper: null, dbHelper: null),
                update: (context, sharedHelper, dbHelper, previous) =>
                    AuthServiceAdapter(previous.authJWT, sharedHelper: sharedHelper, dbHelper: dbHelper),
                lazy: true,
              ),
              ChangeNotifierProxyProvider<DBHelper, CategoryProvider>(
                create: (context) => CategoryProvider([], dbHelper: null),
                update: (context, dbHelper, previous) => CategoryProvider(previous.categoryLargeList, dbHelper: dbHelper),
                lazy: true,
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: routes,
              theme: AppThemeDataFactory.prepareThemeData(),
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: MyScrollBehavior(),
                  child: child,
                );
              },
              home: Splash(),
            )
        )
    );
  });

}

class Splash extends BaseWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AuthServiceAdapter authServiceAdapter;
  Future<void> checkAppVersion;
  Future<void> checkAllVersion;

  @override
  void didChangeDependencies() {
    checkAllVersion ??= Provider.of<ResourceProviderModel>(context, listen: false).checkAllVersion();
    checkAppVersion ??= Provider.of<ResourceProviderModel>(context).checkAppVersion();
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    super.didChangeDependencies();
  }

  Widget _widget() {
    final forceUpdateResult = context.select((ResourceProviderModel model) => model.value.checkAppVersion);
    if(!forceUpdateResult.hasData) {
      return Container(
        alignment: AlignmentDirectional.center,
        color: MainColors.green_80,
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
      );
    }
    if(forceUpdateResult.result.asValue.value.requireInstall) {
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: MainColors.yellow_100.withOpacity(0.6)),
            ),
          ),
          BaseButtonDialog(
              content: Strings.dialog_title_update,
              btnOk: Strings.dialog_btn_update_ok,
              btnCancel: Strings.dialog_btn_update_cancel
          )
        ],
      );
    }else {
      if(authServiceAdapter.authJWT.isNotEmpty) {
        return MainCategory();
      }else {
        return ProviderWidget<UserProviderModel>(
            Login(), (BuildContext context) => UserProviderModel.build()
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _widget();
  }
}
