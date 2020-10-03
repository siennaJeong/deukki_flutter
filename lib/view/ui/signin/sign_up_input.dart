import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
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

/* Email 입력 화면 */
class SignUpInputEmail extends BaseWidget {
  @override
  SignUpInputEmailState createState() => SignUpInputEmailState();
}

class SignUpInputEmailState extends State<SignUpInputEmail> {
  FocusNode _focusNode;
  TextEditingController _textController = TextEditingController();
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
    _textController.addListener(() {});
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _isEmailValid() {
    setState(() {
      if(_textController != null && authServiceAdapter.canUseEmail(_textController.text)) {
        RouteNavigator().go(GetRoutesName.ROUTE_SIGNUP_INPUT_NAME, context);
      }else {
        RouteNavigator().go(null, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditWidget(Strings.sign_up_email, _focusNode, _textController, _isEmailValid);
  }
}




/* 이름 입력 화면 */
class SignUpInputName extends BaseWidget {
  @override
  SignUpInputNameState createState() => SignUpInputNameState();
}

class SignUpInputNameState extends State<SignUpInputName> {
  FocusNode _focusNode;
  TextEditingController _textController = TextEditingController();
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
    _textController.addListener(() {});
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _isNameValid() {
    setState(() {
      if(_textController != null && authServiceAdapter.canUseName(_textController.text)) {
        RouteNavigator().go(GetRoutesName.ROUTE_SIGNUP_INPUT_BIRTH, context);
      }else {
        RouteNavigator().go(null, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditWidget(Strings.sign_up_name, _focusNode, _textController, _isNameValid);
  }
}


// ignore: must_be_immutable
class EditWidget extends StatelessWidget {
  final FocusNode _focusNode;
  final String inputTitle;
  final TextEditingController _textController;
  VoidCallback voidCallback;

  EditWidget(this.inputTitle, this._focusNode, this._textController, this.voidCallback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MainColors.yellow_100,
        resizeToAvoidBottomPadding: false,
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
                                voidCallback: voidCallback,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              inputTitle,
                              style: Theme.of(context).textTheme.bodyText1
                            ),
                            Container(
                              width: 280,
                              margin: EdgeInsets.only(top: 8),
                              child: _inputField(
                                context,
                                null,
                                TextInputType.emailAddress,
                                _focusNode,
                                _textController,
                                null
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
            ),
          ),
        )
    );
  }
}

/* 생년월일 입력 화면 */
class SignUpInputBirth extends BaseWidget {
  @override
  _SignUpInputBirthState createState() => _SignUpInputBirthState();
}

class _SignUpInputBirthState extends State<SignUpInputBirth> {
  FocusScopeNode _focusNode;
  TextEditingController _yearController, _monthController;
  String selectGender;
  AuthServiceAdapter authServiceAdapter;

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusScopeNode();
    selectGender = "";
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _yearEditingComplete() {
    if(authServiceAdapter.canUseYear(_yearController as int)) {
      _focusNode.nextFocus();
    }
  }

  void _monthEditingComplete() {
    if(!authServiceAdapter.canUseMonth(_monthController as int)) {
      _focusNode.previousFocus();
    }
    authServiceAdapter.userVO.birthDate = _yearController.text + "-" + _monthController.text;
  }

  void _signUpDone() {
    if(authServiceAdapter.userVO.birthDate.isNotEmpty && selectGender.isNotEmpty) {
      RouteNavigator().go(GetRoutesName.ROUTE_WELCOME, context);
    }
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
                            voidCallback: null,
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
                            Row(
                              children: <Widget>[
                                Container(
                                    width: 160,
                                    margin: EdgeInsets.only(top: 8, right: 8),
                                    child: _inputField(
                                      context,
                                      Strings.sign_up_year,
                                      TextInputType.number,
                                      _focusNode,
                                      _yearController,
                                      _yearEditingComplete
                                    )
                                ),
                                Container(
                                  width: 112,
                                  margin: EdgeInsets.only(top: 8),
                                  child: _inputField(
                                    context,
                                    Strings.sign_up_month,
                                    TextInputType.number,
                                    _focusNode,
                                    _monthController,
                                    _monthEditingComplete
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}

Widget _inputField(
    BuildContext context,
    String hint,
    TextInputType textInputType,
    FocusNode focusNode,
    TextEditingController textEditingController,
    Function() function) {
  return TextField(
    controller: textEditingController,
    keyboardType: textInputType,
    maxLines: 1,
    textInputAction: TextInputAction.go,
    style: Theme.of(context).textTheme.bodyText2,
    focusNode: focusNode,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          fontFamily: 'TmoneyRound',
          fontWeight: FontWeight.w400,
          color: MainColors.grey_text
      ),
      contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 16),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MainColors.grey_border, width: 2.0)
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
      )
    ),
    onEditingComplete: function
  );
}



