
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  double deviceWidth, deviceHeight;

  Widget _cardWidget(Color bgColor, String icons, String title, String script, bool isAccuracy) {
    return Card(
      color: isAccuracy ? MainColors.grey_google : bgColor,
      margin: EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isAccuracy ? MainColors.grey_google : MainColors.yellow_40,
          width: 2,
        ),
      ),
      elevation: 0,
      child: Container(
        width: deviceWidth * 0.42,
        height: deviceHeight * 0.36,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                margin: EdgeInsets.only(right: 8, bottom: 8),
                child: Image.asset(icons, width: 80, height: 80,),
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 24, left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    isAccuracy ? "$title -" : "${title}0.0 / 100",
                    style: TextStyle(
                      color: isAccuracy ? MainColors.grey_90 : MainColors.grey_100,
                      fontSize: 24,
                      fontFamily: "TmoneyRound",
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    isAccuracy ? "준비중" : "${script}0.0 / 100",
                    style: TextStyle(
                      color: isAccuracy ? MainColors.grey_90 : MainColors.grey_100,
                      fontSize: 16,
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.w400
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: deviceWidth > 700 ? 10 : 40),
                child: Text(
                  "이름${Strings.mypage_report_title}",
                  style: TextStyle(
                    color: MainColors.grey_100,
                    fontSize: 16,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3, left: deviceWidth > 700 ? 10 : 40),
                child: Text(
                  "${Strings.mypage_report_script} 이름${Strings.mypage_report_script_2}",
                  style: TextStyle(
                      color: MainColors.grey_100,
                      fontSize: 16,
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _cardWidget(MainColors.yellow_40, AppImages.hearingIcon, Strings.mypage_report_listening_score, Strings.mypage_report_listening_average, false),
                  SizedBox(width: 16),
                  _cardWidget(MainColors.yellow_60, AppImages.micIcon, Strings.mypage_report_accuracy, null, true)
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 40, right: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Strings.mypage_report_show,
                      style: TextStyle(
                          color: MainColors.grey_100,
                          fontSize: 16,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios, size: 17, )
                  ],
                ),
              ),
            ),
          )
        ],
      )

    );
  }
}
