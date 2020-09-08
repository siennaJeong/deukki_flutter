import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/* Email 입력 화면 */
class SignUpInputEmail extends BaseWidget {
  @override
  _SignUpInputEmailState createState() => _SignUpInputEmailState();

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    throw UnimplementedError();
  }
}

class _SignUpInputEmailState extends State<SignUpInputEmail> {


  @override
  Widget build(BuildContext context) {
    return editWidget("email", RouteNavigator(context).navigatePushName(GetRoutesName.ROUTE_SIGNUP_INPUT_NAME));
  }
}

/* 이름 입력 화면 */
class SignUpInputName extends StatefulWidget {
  @override
  _SignUpInputNameState createState() => _SignUpInputNameState();
}

class _SignUpInputNameState extends State<SignUpInputName> {
  @override
  Widget build(BuildContext context) {
    return editWidget("name", null);
  }
}


Widget editWidget(String str, Object object) {
  return Scaffold(
      backgroundColor: MainColors().yellow_100,
      body: Container(
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
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 28, bottom: 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                Strings.sign_up_terms_title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "TmoneyRound",
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: CommonRaisedButton(Strings.common_btn_next, GetRoutesName.ROUTE_SIGNUP_INPUT_NAME, true),
                            )
                          ],
                        )
                    ),

                  ],
                ),
              ),
            )
        ),
      )
  );
}
