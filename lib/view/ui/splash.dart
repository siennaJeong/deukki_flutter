import 'dart:io';
import 'dart:ui';

import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/payment/payment_provider_model.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/ui/app/app_theme.dart';
import 'package:deukki/view/ui/base/base_button_dialog.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/m_scroll_behavior.dart';
import 'package:deukki/view/ui/signin/login.dart';
import 'package:deukki/view/ui/category/main.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if(kDebugMode) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }else {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  if(!Platform.isIOS) {
    InAppPurchaseConnection.enablePendingPurchases();
  }

  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
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
              ChangeNotifierProvider<UserProviderModel>(
                create: (context) => UserProviderModel.build(),
                lazy: true,
              ),
              ChangeNotifierProvider<ResourceProviderModel>(
                create: (context) => ResourceProviderModel.build(),
                lazy: true,
              ),
              ChangeNotifierProvider<PaymentProviderModel>(
                create: (context) => PaymentProviderModel.build(),
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
  Future<void> verifyToken;

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
        child: CupertinoActivityIndicator(radius: 15)
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
        verifyToken ??= Provider.of<UserProviderModel>(context).verifyToken(authServiceAdapter.authJWT);
        final tokenStatusResult = context.select((UserProviderModel model) => model.value.verifyToken);
        if(!tokenStatusResult.hasData) {
          return Container(
              alignment: AlignmentDirectional.center,
              color: MainColors.green_80,
              child: CupertinoActivityIndicator(radius: 15)
          );
        }
        if(tokenStatusResult.result.asValue.value != null) {
          if(authServiceAdapter.userVO.gender.isNotEmpty && authServiceAdapter.userVO.birthDate.isNotEmpty) {
            AnalyticsService().setUserProperties(
                "${tokenStatusResult.result.asValue.value.idx}",
                authServiceAdapter.userVO.gender,
                authServiceAdapter.userVO.birthDate);
          }
          return MainCategory();
        }else {
          return Login();
        }
      }else {
        return Login();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _widget();
  }
}
