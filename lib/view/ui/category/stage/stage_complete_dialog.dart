
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StageCompleteDialog extends StatefulWidget {
  @override
  _StageCompleteDialogState createState() => _StageCompleteDialogState();
}

class _StageCompleteDialogState extends State<StageCompleteDialog> {
  CategoryProvider categoryProvider;
  UserProviderModel userProviderModel;

  double deviceWidth, deviceHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    var acquiredStars;

    final result = userProviderModel.value.recordLearning;
    if(!result.hasData) {
      CupertinoActivityIndicator();
    }else {
      final recordResult = result.result.asValue.value.result;
      acquiredStars = recordResult['acquiredStars'];
    }

    String firstStar, secondStar, thirdStar;

    switch(acquiredStars) {
      case 1:
        firstStar = AppImages.fullStar;
        secondStar = AppImages.emptyStar;
        thirdStar = AppImages.emptyStar;
        break;
      case 2:
        firstStar = AppImages.fullStar;
        secondStar = AppImages.fullStar;
        thirdStar = AppImages.emptyStar;
        break;
      case 3:
        firstStar = AppImages.fullStar;
        secondStar = AppImages.fullStar;
        thirdStar = AppImages.fullStar;
        break;
    }

    void _quizDone() {
      categoryProvider.updateScore(acquiredStars);
      if(categoryProvider.selectStageIndex % 3 != 0) {
        Navigator.pop(context);
      }else {
        RouteNavigator().go(GetRoutesName.ROUTE_RECORD, context);
      }
    }

    return Scaffold(
      backgroundColor: MainColors.yellow_100,
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Positioned(
                          child: Container(
                            width: deviceWidth * 0.35,
                            child: Image.asset(AppImages.whiteBgImage),
                          )
                      ),
                      Positioned(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(firstStar, width: 40,),
                                Image.asset(secondStar, width: 40,),
                                Image.asset(thirdStar, width: 40,)
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              acquiredStars <= 1 ? Strings.quiz_result_good : Strings.quiz_result_great,
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: "TmoneyRound",
                                fontWeight: FontWeight.w700,
                                color: acquiredStars <= 1 ? MainColors.green_100 : MainColors.blue_100
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              Strings.star + "${acquiredStars.toString()}" + Strings.earn_star,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "NotoSansKR",
                                fontWeight: FontWeight.w400,
                                color: acquiredStars <= 1 ? MainColors.green_100 : MainColors.blue_100
                              ),
                            )
                          ],
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: deviceWidth * 0.4,
                    child: CommonRaisedButton(
                      borderColor: MainColors.purple_100,
                      textColor: Colors.white,
                      buttonColor: MainColors.purple_100,
                      buttonText: Strings.common_btn_ok,
                      fontSize: 16,
                      voidCallback: _quizDone,
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
