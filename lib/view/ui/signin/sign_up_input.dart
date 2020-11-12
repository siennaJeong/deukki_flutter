import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/common/utils/validator.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/ui/base/custom_radio_widget.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/* 생년월일 입력 화면 */
class SignUpInputBirth extends BaseWidget {
  @override
  _SignUpInputBirthState createState() => _SignUpInputBirthState();
}

class _SignUpInputBirthState extends State<SignUpInputBirth> with Validator {
  final _formKey = GlobalKey<FormState>();
  FocusScopeNode _focusNode;
  AuthServiceAdapter authServiceAdapter;
  UserProviderModel userProviderModel;
  String year, month, selectGender = "";

  @override
  void initState() {
    super.initState();
    _focusNode = FocusScopeNode();
  }

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _signUpDone() {
    if(_focusNode.hasFocus) {
      _focusNode.unfocus();
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }
    if(_formKey.currentState.validate() && this.selectGender.isNotEmpty) {
      _formKey.currentState.save();
      authServiceAdapter.userVO.birthDate = "$year-$month";
      RouteNavigator().go(GetRoutesName.ROUTE_WELCOME, context);
      userProviderModel.signUp(
          authServiceAdapter.userVO,
          authServiceAdapter.socialMethod,
          authServiceAdapter.socialId,
          authServiceAdapter.marketingAgree,
          authServiceAdapter.marketingMethod
      ).then((value) {
        final signUpResult = userProviderModel.value.signUp;
        if(!signUpResult.hasData) {
          print("sign up failed");
        }
        if(signUpResult.result.isValue) {
          authServiceAdapter.signUpDone(signUpResult.result.asValue.value.result);
        }else if(signUpResult.result.isError) {
          print("sign up error : " + signUpResult.result.asError.error.toString());
        }
      });
    }
  }

  Widget _yearInputWidget() {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      autofocus: true,
      maxLines: 1,
      style: Theme.of(context).textTheme.bodyText2,
      validator: yearValidation,
      onSaved: (String value) {
        year = value;
      },
      decoration: InputDecoration(
        hintText: Strings.sign_up_year,
        hintStyle: TextStyle(
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w400,
            color: MainColors.grey_text
        ),
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MainColors.grey_border, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MainColors.grey_100, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0)
        ),
      ),
    );
  }

  Widget _monthInputWidget() {
    return TextFormField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLines: 1,
      style: Theme.of(context).textTheme.bodyText2,
      validator: monthValidation,
      onSaved: (String value) {
        month = value;
      },
      decoration: InputDecoration(
        hintText: Strings.sign_up_month,
        hintStyle: TextStyle(
            fontFamily: 'NotoSansKR',
            fontWeight: FontWeight.w400,
            color: MainColors.grey_text
        ),
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MainColors.grey_border, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MainColors.grey_100, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red, width: 2.0)
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () {
          if(_focusNode.hasFocus) {
            _focusNode.unfocus();
          }
          SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
        },
        child: Container(
          margin: EdgeInsets.only(right: 44, top: 19, left: 44, bottom: 19),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Form(
                key: _formKey,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.only(top: 28, bottom: 40),
                              child: Text(
                                  Strings.sign_up_terms_title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline4
                              )
                          ),
                          Container(
                            alignment: AlignmentDirectional.centerEnd,
                            margin: EdgeInsets.only(top: 16, right: 12),
                            child: CommonRaisedButton(
                              buttonText: Strings.common_btn_next,
                              buttonColor: Colors.white,
                              textColor: MainColors.purple_100,
                              borderColor: MainColors.purple_100,
                              fontSize: 16,
                              voidCallback: _signUpDone,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  Strings.sign_up_birth,
                                  style: Theme.of(context).textTheme.bodyText1
                              ),
                              FocusScope(
                                node: _focusNode,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 160,
                                      margin: EdgeInsets.only(top: 8, right: 8),
                                      child: _yearInputWidget(),
                                    ),
                                    Container(
                                      width: 112,
                                      margin: EdgeInsets.only(top: 8),
                                      child: _monthInputWidget(),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 48),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  Strings.sign_up_gender,
                                  style: Theme.of(context).textTheme.bodyText1
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CustomRadioWidget(
                                    title: Strings.sign_up_gender_male,
                                    value: Strings.sign_up_gender_male,
                                    groupValue: selectGender,
                                    onChanged: (String val) {
                                      setState(() {
                                        selectGender = val;
                                        authServiceAdapter.userVO.gender = "M";
                                      });
                                    },
                                  ),
                                  SizedBox(width: 24),
                                  CustomRadioWidget(
                                    title: Strings.sign_up_gender_female,
                                    value: Strings.sign_up_gender_female,
                                    groupValue: selectGender,
                                    onChanged: (String val) {
                                      setState(() {
                                        selectGender = val;
                                        authServiceAdapter.userVO.gender = "F";
                                      });
                                    },
                                  )
                                ],
                              ),

                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

