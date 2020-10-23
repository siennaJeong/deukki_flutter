
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StageCompleteDialog extends StatefulWidget {
  @override
  _StageCompleteDialogState createState() => _StageCompleteDialogState();
}

class _StageCompleteDialogState extends State<StageCompleteDialog> {
  ResourceProviderModel resourceProviderModel;
  CategoryProvider categoryProvider;

  double deviceWidth, deviceHeight;
  String firstStar, secondStar, thirdStar = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    resourceProviderModel = Provider.of<ResourceProviderModel>(context);
    categoryProvider = Provider.of<CategoryProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    switch(categoryProvider.stageScore) {
      case 1:
        firstStar = AppImages.fullStar;
        secondStar = AppImages.emptyStar;
        thirdStar = AppImages.emptyStar;
        print("stage first");
        break;
      case 2:
        firstStar = AppImages.fullStar;
        secondStar = AppImages.fullStar;
        thirdStar = AppImages.emptyStar;
        print("stage second");
        break;
      case 3:
        firstStar = AppImages.fullStar;
        secondStar = AppImages.fullStar;
        thirdStar = AppImages.fullStar;
        print("stage third");
        break;
    }

    void _quizDone() {
      Navigator.pop(context);
      /*if(categoryProvider.selectStageIndex % 3 == 0) {
        //  녹음 화면
      }else {
        Navigator.pop(context);
      }*/
    }

    return Scaffold(
      backgroundColor: MainColors.yellow_100,
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(firstStar, scale: 40,),
                                Image.asset(secondStar, scale: 40,),
                                Image.asset(thirdStar, scale: 40,)
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              categoryProvider.stageScore <= 1 ? Strings.quiz_result_good : Strings.quiz_result_great,
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: "TmoneyRound",
                                fontWeight: FontWeight.w700,
                                color: categoryProvider.stageScore <= 1 ? MainColors.green_100 : MainColors.blue_100
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              Strings.star + "${categoryProvider.stageScore.toString()}" + Strings.earn_star,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "NotoSansKR",
                                fontWeight: FontWeight.w400,
                                color: categoryProvider.stageScore <= 1 ? MainColors.green_100 : MainColors.blue_100
                              ),
                            )
                          ],
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: deviceWidth * 0.33,
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
