import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _privacyWidget(Strings.sign_up_terms_terms, Strings.privacy_terms_url, context);
  }
}

class PrivacyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _privacyWidget(Strings.sign_up_terms_info, Strings.privacy_privacy_url, context);
  }
}

Widget _privacyWidget(String title, String url, BuildContext context) {
  double deviceWidth, deviceHeight;

  deviceWidth = MediaQuery.of(context).size.width;
  deviceHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: MainColors.yellow_100,
    body: SafeArea(
      right: false,
      left: false,
      bottom: false,
      child: Container(
        margin: EdgeInsets.only(left: 44, top: 19, right: 44, bottom: 19),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        alignment: AlignmentDirectional.center,
                        margin: EdgeInsets.only(top: 24, bottom: 20),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Container(                      //  X Button
                        alignment: AlignmentDirectional.centerEnd,
                        margin: EdgeInsets.only(right: 12),
                        child: InkWell(
                          child: Container(
                            margin: EdgeInsets.all(24),
                            child: Image.asset(AppImages.xButton, width: 24, height: 24,),
                          ),
                          onTap: () => { Navigator.pop(context) },
                        ),
                      ),
                    ],
                  ),
                  Card(
                    color: MainColors.grey_30,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                    margin: EdgeInsets.only(left: 24, right: 24, bottom: 11),
                    child: Container(
                      width: deviceWidth * 0.81,
                      height: deviceHeight * 0.62,
                      padding: EdgeInsets.all(20),
                      child: WebView(
                        initialUrl: url,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
