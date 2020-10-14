import 'dart:ui';

import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/ui/app/app_theme.dart';
import 'package:deukki/view/ui/base/base_button_dialog.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/provider_widget.dart';
import 'package:deukki/view/ui/signin/login.dart';
import 'package:deukki/view/ui/main.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              Provider.value(value: SharedHelper()),
              Provider<Database>(
                create: (context) => DBHelper().initDB(),
                lazy: true,
              ),
              ChangeNotifierProxyProvider<SharedHelper, AuthServiceAdapter>(
                create: (context) => AuthServiceAdapter(sharedHelper: null),
                update: (BuildContext context, SharedHelper sharedHelper, AuthServiceAdapter authServiceAdapter) =>
                    AuthServiceAdapter(sharedHelper: sharedHelper),
              ),
              ChangeNotifierProvider<ResourceProviderModel>(
                create: (_) => ResourceProviderModel.build(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: routes,
              theme: AppThemeDataFactory.prepareThemeData(),
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
  ResourceProviderModel versionProviderModel;
  Widget returnWidget;

  @override
  void initState() {
    super.initState();
    versionProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    authServiceAdapter.userAuthState();
    versionProviderModel.checkAllVersion();
  }

  @override
  void didChangeDependencies() {
    if(authServiceAdapter.authJWT.isNotEmpty) {
      versionProviderModel.checkForceUpdate(authServiceAdapter.authJWT);
    }
    super.didChangeDependencies();
  }

  Widget _widget() {
    final updateResult = versionProviderModel.value.checkForceUpdate;
    if(authServiceAdapter.authJWT.isEmpty) {
      returnWidget = ProviderWidget<UserProviderModel>(
          Login(), (BuildContext context) => UserProviderModel.build()
      );
    }else if(!updateResult.hasData) {
      returnWidget = _splash();
    }else {
      returnWidget = Stack(
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
    }
    return returnWidget;
  }

  Widget _splash() => Scaffold(
    backgroundColor: MainColors.yellow_100,
    body: Center(
      child: Container(
        child: Text("!!"),
      ),
    )
  );

  @override
  Widget build(BuildContext context) {
    return _widget();
      /*Consumer<AuthServiceAdapter>(
      builder: (context, authServiceAdapter, child) {
        authServiceAdapter.userAuthState();
        if(authServiceAdapter.authJWT.isNotEmpty) {
          versionProviderModel.checkForceUpdate(authServiceAdapter.authJWT).then((value) {
            final checkResult = versionProviderModel.value.checkForceUpdate;
            if(checkResult.result.asValue.value.result) {
              /*return Stack(
                children: <Widget>[
                  BaseDialog(content: Strings.dialog_title_update, btnOk: Strings.dialog_btn_update_ok, btnCancel: Strings.dialog_btn_update_cancel),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                  )
                ],
              );*/
              returnWidget = BaseDialog(
                  content: Strings.dialog_title_update,
                  btnOk: Strings.dialog_btn_update_ok,
                  btnCancel: Strings.dialog_btn_update_cancel
              );
            }else {
              returnWidget = MainCategory();
            }
          });
          return returnWidget;
        }else {
          return ProviderWidget<UserProviderModel>(
            Login(), (BuildContext context) => UserProviderModel.build()
          );
        }
      }
    );*/
  }
}
