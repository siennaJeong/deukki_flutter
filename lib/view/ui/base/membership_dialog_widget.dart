
import 'dart:ui';

import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemberShipDialog extends StatefulWidget {
  final double deviceWidth;
  final double deviceHeight;


  MemberShipDialog({@required this.deviceWidth, @required this.deviceHeight});

  @override
  _MemberShipDialogState createState() => _MemberShipDialogState();
}

class _MemberShipDialogState extends State<MemberShipDialog> {
  double deviceWidth, deviceHeight;

  @override
  void initState() {
    deviceWidth = widget.deviceWidth;
    deviceHeight = widget.deviceHeight;
    super.initState();
  }

  void _dismissDialog() {
    //AnalyticsService().sendAnalyticsEvent(false, userProviderModel.userVOForHttp.premium == 0 ? false : true, DIALOG_UPGRADE, "close", "", "");
    Navigator.of(context).pop();
  }

  void _joinMembership() {
    //AnalyticsService().sendAnalyticsEvent(false, userProviderModel.userVOForHttp.premium == 0 ? false : true, DIALOG_UPGRADE, "enrollment", "", "");
    _dismissDialog();
    Navigator.pushNamed(context, GetRoutesName.ROUTE_MYPAGE, arguments: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9.2, sigmaY: 9.2),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
        ),
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: deviceHeight > 390 ? deviceWidth * 0.5 : deviceWidth * 0.52,
            height: deviceHeight > 390 ? deviceHeight * 0.5 : deviceHeight * 0.52,
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 32, bottom: 24),
                      child: Text(Strings.only_membership, style: Theme.of(context).textTheme.bodyText2,),
                    ),
                    Container(
                        width: (deviceWidth * 0.5) * 0.67,
                        child: CommonRaisedButton(
                          textColor: Colors.white,
                          buttonColor: MainColors.purple_100,
                          borderColor: MainColors.purple_100,
                          buttonText: Strings.join_membership,
                          fontSize: 16,
                          voidCallback: _joinMembership,                 //  멤버십 가입
                        )
                    ),
                    SizedBox(height: 4),
                    Container(
                        width: (deviceWidth * 0.5) * 0.67,
                        child: CommonRaisedButton(
                          textColor: MainColors.purple_100,
                          buttonColor: Colors.white,
                          borderColor: MainColors.purple_100,
                          buttonText: Strings.common_btn_close,
                          fontSize: 16,
                          voidCallback: _dismissDialog,       //  닫기
                        )
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}