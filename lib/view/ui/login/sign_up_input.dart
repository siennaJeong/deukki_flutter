import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/view/ui/base/common_button.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/* Email 입력 화면 */
class SignUpInputEmail extends StatefulWidget {
  @override
  _SignUpInputEmailState createState() => _SignUpInputEmailState();
}

class _SignUpInputEmailState extends State<SignUpInputEmail> {

  @override
  Widget build(BuildContext context) {
    return EditWidget("email", GetRoutesName.ROUTE_SIGNUP_INPUT_NAME);
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
    return EditWidget("name", GetRoutesName.ROUTE_SIGNUP_INPUT_BIRTH);
  }
}



/* 생년월일 입력 화면 */
class SignUpInputBirth extends StatefulWidget {
  @override
  _SignUpInputBirthState createState() => _SignUpInputBirthState();
}

class _SignUpInputBirthState extends State<SignUpInputBirth> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class EditWidget extends StatelessWidget {
  final String inputTitle, routeName;

  EditWidget(this.inputTitle, this.routeName);

  @override
  Widget build(BuildContext context) {
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
                      Stack(
                        children: [
                          Container(
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.only(top: 28, bottom: 40),
                              child: Text(
                                  Strings.sign_up_terms_title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "TmoneyRound",
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700
                                  )
                              )
                          ),
                          Container(
                            alignment: AlignmentDirectional.centerEnd,
                            margin: EdgeInsets.only(top: 16, right: 12),
                            child: CommonRaisedButton(Strings.common_btn_next, routeName, Colors.white, MainColors().purple_100),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              )
          ),
        )
    );
  }
}
