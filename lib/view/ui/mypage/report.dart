
import 'package:deukki/data/model/report_vo.dart';
import 'package:deukki/provider/resource/mypage_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserProviderModel userProviderModel;
  MyPageProvider myPageProvider;

  double deviceWidth, deviceHeight;
  ReportVO weeklyReports;

  bool _isClick = false;

  @override
  void didChangeDependencies() {
    myPageProvider = Provider.of<MyPageProvider>(context, listen: false);
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    if(userProviderModel.weeklyReports != null) {
      weeklyReports ??= userProviderModel.weeklyReports;
    }
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
                    isAccuracy ? "$title${weeklyReports.speakingScore}%" : "$title${weeklyReports.listeningScore} / 100",
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

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: Container(
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
              Positioned(                   //  리포트 보러가기
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    if(!_isClick) {
                      _isClick = true;
                      if(weeklyReports.link != "") {
                        await launch("${Strings.weekly_report_url}?link=${weeklyReports.link}");
                        _isClick = false;
                      }else {
                        scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text(Strings.mypage_report_not_yet), duration: Duration(seconds: 2)));
                        _isClick = false;
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: deviceHeight > 390 ? 40 : 20, right: 60),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          Strings.mypage_report_show,
                          style: TextStyle(
                              color: weeklyReports.link == "" ? MainColors.grey_70 : MainColors.grey_100,
                              fontSize: 16,
                              fontFamily: "NotoSansKR",
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios, size: 17, color: weeklyReports.link == "" ? MainColors.grey_70 : MainColors.grey_100,)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}
