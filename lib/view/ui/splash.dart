import 'package:deukki/common/storage/db_helper.dart';
import 'package:deukki/common/storage/shared_helper.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/ui/app/app_theme.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/provider_widget.dart';
import 'package:deukki/view/ui/signin/login.dart';
import 'package:deukki/view/ui/main.dart';
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
  ResourceProviderModel versionProviderModel;

  @override
  void didChangeDependencies() {
    versionProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    versionProviderModel.checkAllVersion();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServiceAdapter>(
      builder: (context, authServiceAdapter, child) {
        authServiceAdapter.userAuthState();
        if(authServiceAdapter.authJWT.isNotEmpty) {
          versionProviderModel.checkForceUpdate(authServiceAdapter.authJWT).then((value) {
            final checkResult = versionProviderModel.value.checkForceUpdate;
            if(checkResult.result.asValue.value.result) {
              return Container(width: 0.0, height: 0.0,);
            }else {
              return MainCategory();
            }
          });
          return Container();
        }else {
          return ProviderWidget<UserProviderModel>(
            Login(), (BuildContext context) => UserProviderModel.build()
          );
        }
      }
    );
  }
}
