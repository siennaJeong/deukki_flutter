import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/common/utils/validator.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpInputEmail extends BaseWidget{
  @override
  SignUpInputEmailState createState() => SignUpInputEmailState();
}

class SignUpInputEmailState extends State<SignUpInputEmail> with Validator {
  final _emailFormKey = GlobalKey<FormState>();
  FocusNode _focusNode;
  AuthServiceAdapter authServiceAdapter;

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _isEmailValid() {
    if(_emailFormKey.currentState.validate()) {
      _emailFormKey.currentState.save();
      RouteNavigator().go(GetRoutesName.ROUTE_SIGNUP_INPUT_NAME, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MainColors.yellow_100,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
            SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
          },
          child: Container(
            margin: EdgeInsets.only(left: 44, top: 19, right: 44, bottom: 19),
            child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Form(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: [
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
                                  borderColor: MainColors.purple_100,
                                  textColor: MainColors.purple_100,
                                  fontSize: 16,
                                  voidCallback: _isEmailValid,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  Strings.sign_up_email,
                                  style: Theme.of(context).textTheme.bodyText1
                              ),
                              Container(
                                  width: 280,
                                  margin: EdgeInsets.only(top: 8),
                                  child: TextFormField(
                                    key: _emailFormKey,
                                    autofocus: true,
                                    keyboardType: TextInputType.emailAddress,
                                    maxLines: 1,
                                    textInputAction: TextInputAction.done,
                                    style: Theme.of(context).textTheme.bodyText2,
                                    focusNode: _focusNode,
                                    validator: emailValidation,
                                    onSaved: (String value) {
                                      authServiceAdapter.userVO.email = value;
                                    },
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                            fontFamily: 'NotoSansKR',
                                            fontWeight: FontWeight.w400,
                                            color: MainColors.grey_text
                                        ),
                                        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 16),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(color: MainColors.grey_border, width: 2.0)
                                        ),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(color: Colors.red, width: 2.0)
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(color: Colors.red, width: 2.0)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                            borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
                                        )
                                    ),
                                  )
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ),
        )
    );
  }
}