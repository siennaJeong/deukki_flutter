import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/ui/base/custom_radio_widget.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

/* Email 입력 화면 */
class SignUpInputEmail extends BaseWidget {
  @override
  _SignUpInputEmailState createState() => _SignUpInputEmailState();
}

class _SignUpInputEmailState extends State<SignUpInputEmail> {
  FocusNode _focusNode;
  TextEditingController _textController;
  
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return EditWidget(Strings.sign_up_email, GetRoutesName.ROUTE_SIGNUP_INPUT_NAME, _focusNode, _textController);
  }
}




/* 이름 입력 화면 */
class SignUpInputName extends BaseWidget {
  @override
  _SignUpInputNameState createState() => _SignUpInputNameState();
}

class _SignUpInputNameState extends State<SignUpInputName> {
  FocusNode _focusNode;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return EditWidget(Strings.sign_up_name, GetRoutesName.ROUTE_SIGNUP_INPUT_BIRTH, _focusNode, _textController);
  }
}


class EditWidget extends StatelessWidget {
  final FocusNode _focusNode;
  final String inputTitle, routeName;

  final TextEditingController _textController;

  EditWidget(this.inputTitle, this.routeName, this._focusNode, this._textController);

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
                              child: CommonRaisedButton(Strings.common_btn_next, routeName, Colors.white, MainColors.purple_100, MainColors.purple_100, 16),
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
                              child: TextField(
                                maxLines: 1,
                                textInputAction: TextInputAction.go,
                                style: Theme.of(context).textTheme.bodyText2,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12, right: 16),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(color: MainColors.grey_border, width: 2.0)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
                                  ),
                                ),
                                onEditingComplete: () => OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
                                ),
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
  FocusNode _yearFocusNode, _monthFocusNode;
  String selectGender;

  @override
  void initState() {
    super.initState();
    _yearFocusNode = FocusNode();
    _monthFocusNode = FocusNode();
    selectGender = "";
  }

  @override
  void dispose() {
    _yearFocusNode.dispose();
    _monthFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: () {
          if(_yearFocusNode.hasFocus) {
            _yearFocusNode.unfocus();
          }
          if(_monthFocusNode.hasFocus) {
            _monthFocusNode.unfocus();
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
                          child: CommonRaisedButton(Strings.common_btn_next, GetRoutesName.ROUTE_WELCOME, Colors.white, MainColors.purple_100, MainColors.purple_100, 16),
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
                                  child: TextField(
                                    maxLines: 1,
                                    textInputAction: TextInputAction.go,
                                    style: Theme.of(context).textTheme.bodyText2,
                                    focusNode: _yearFocusNode,
                                    decoration: InputDecoration(
                                      hintText: "YYYY",
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
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
                                      ),
                                    ),
                                    onEditingComplete: () => OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                        borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 112,
                                  margin: EdgeInsets.only(top: 8),
                                  child: TextField(
                                    maxLines: 1,
                                    textInputAction: TextInputAction.go,
                                    style: Theme.of(context).textTheme.bodyText2,
                                    focusNode: _monthFocusNode,
                                    decoration: InputDecoration(
                                      hintText: "MM",
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
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
                                      ),
                                    ),
                                    onEditingComplete: () => OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                        borderSide: BorderSide(color: MainColors.grey_100, width: 2.0)
                                    ),
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


