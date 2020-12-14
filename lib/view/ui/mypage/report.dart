
import 'package:deukki/data/model/report_vo.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  UserProviderModel userProviderModel;

  double deviceWidth, deviceHeight;
  ReportVO weeklyReports;

  @override
  void didChangeDependencies() {
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  Widget _cardWidget(Color bgColor, String icons, String title, String script, bool isAccuracy) {
    return Card(
      color: bgColor,
      margin: EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isAccuracy ? MainColors.yellow_60 : MainColors.yellow_40,
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
                    isAccuracy ? "$title${userProviderModel.weeklyReports.speakingScore}%" : "$title${userProviderModel.weeklyReports.listeningScore} / 100",
                    style: TextStyle(
                      color: MainColors.grey_100,
                      fontSize: 24,
                      fontFamily: "TmoneyRound",
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: 8),
                  //  같은 레벨의 평균 점수 숨김 처리
                  /*Text(
                    isAccuracy ? "준비중" : "${script}0 / 100",
                    style: TextStyle(
                      color: isAccuracy ? MainColors.grey_90 : MainColors.grey_100,
                      fontSize: 16,
                      fontFamily: "NotoSansKR",
                      fontWeight: FontWeight.w400
                    ),
                  )*/
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

    if(userProviderModel.weeklyReports != null) {
      weeklyReports ??= userProviderModel.weeklyReports;
    }else {
      weeklyReports ??= ReportVO(0, 0, 0, null);
    }

    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 60),
                child: Text(
                  "${userProviderModel.userVOForHttp.name}${Strings.mypage_report_title}",
                  style: TextStyle(
                    color: MainColors.grey_100,
                    fontSize: 16,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3, left: 60),
                child: Text(
                  "${Strings.mypage_report_script} ${userProviderModel.userVOForHttp.name}${Strings.mypage_report_script_2}",
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
          //  리포트 보러가기 숨김처리.
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                //  TODO: 웹뷰로 리포트 보기.
              },
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
