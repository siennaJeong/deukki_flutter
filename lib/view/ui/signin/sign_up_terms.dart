import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpTerms extends BaseWidget {
  @override
  _SignUpTermsState createState() => _SignUpTermsState();
}

class _SignUpTermsState extends State<SignUpTerms> {
  bool marketingAgree = false;
  AuthServiceAdapter authServiceAdapter;

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context);
    super.didChangeDependencies();
  }

  String _isEmailExist() {

    if(authServiceAdapter.email.isEmpty) {
      return GetRoutesName.ROUTE_SIGNUP_INPUT_EMAIL;
    }else {
      return GetRoutesName.ROUTE_SIGNUP_INPUT_NAME;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.yellow_100,
      body: SafeArea(
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
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 28, bottom: 40),
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
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            textInkWell(Strings.sign_up_terms_terms),
                            termsText(Strings.sign_up_terms_essential + Strings.sign_up_terms_dot, MainColors.grey_100, null),
                            textInkWell(Strings.sign_up_terms_info),
                            termsText(Strings.sign_up_terms_essential, MainColors.grey_100, null)
                          ],
                        ),
                      ),
                      termsText(Strings.sign_up_terms_script, MainColors.grey_100, null),
                      Container(
                        margin: EdgeInsets.only(top: 24, bottom: 56),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              activeColor: MainColors.purple_100,
                              value: marketingAgree,
                              onChanged: (bool value) {
                                setState(() {
                                  marketingAgree = value;
                                });
                                if(marketingAgree) {
                                  authServiceAdapter.userVO.agreeMarketing = value;
                                  authServiceAdapter.userVO.marketingMethod = "email";
                                }
                              },
                            ),
                            termsText(Strings.sign_up_terms_marketing, MainColors.grey_100, null)
                          ],
                        ),
                      ),
                      Container(
                        width: 552,
                        height: 48,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: CommonRaisedButton(
                                    Strings.common_btn_cancel,
                                    GetRoutesName.ROUTE_LOGIN,
                                    Colors.white, MainColors.purple_100,
                                    MainColors.purple_100,
                                    16
                                )
                            ),
                            SizedBox(width: 16),
                            Expanded(
                                flex: 1,
                                child: CommonRaisedButton(
                                  Strings.common_btn_ok,
                                  _isEmailExist(),
                                  MainColors.purple_100,
                                  Colors.white,
                                  MainColors.purple_100,
                                  16
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        )
      )
    );
  }


  Widget textInkWell(String str) {
    return InkWell(
      child: termsText(str, MainColors.purple_100, TextDecoration.underline)
    );
  }

  Widget termsText(String str, Color color, TextDecoration textDecoration) {
    return Text(
      str,
      style: TextStyle(
        decoration: textDecoration,
        color: color,
        fontSize: 16
      ),
    );
  }

}
