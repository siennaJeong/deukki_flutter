
import 'dart:ui';

import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StageDialog extends StatefulWidget {
  final String title;

  StageDialog({@required this.title});

  @override
  _StageDialogState createState() => _StageDialogState();
}

class _StageDialogState extends State<StageDialog> {
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;
  AuthServiceAdapter authServiceAdapter;
  UserProviderModel userProviderModel;
  double deviceWidth, deviceHeight;
  String _title;
  int _selectedStageIdx, _selectedIndex;
  List<bool> _preScore = [true];

  @override
  void initState() {
    _title = widget.title;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    categoryProvider.setSentenceTitle(_title);
    super.didChangeDependencies();
  }

  Widget _listWidget() {
    return Selector<CategoryProvider, List<StageVO>>(
      selector: (context, categoryProvider) => categoryProvider.stageList,
      builder: (context, stages, child) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 8, bottom: deviceHeight > 380 ? 30 : 20, left: 36),
            alignment: AlignmentDirectional.bottomCenter,
            child: ListView.separated(
              shrinkWrap: false,
              padding: EdgeInsets.only(left: 0),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: stages.length,
              itemBuilder: (BuildContext context, index) {
                return _listItemWidget(stages[index], index);
              },
              separatorBuilder: (BuildContext context, index) {
                return SizedBox(width: 10);
              },
            ),
          ),
        );
      }
    );
  }

  Widget _listItemWidget(StageVO stageVO, int index) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _scoreWidget(stageVO.score, index),
          _stageWidget(stageVO, index)
        ],
      ),
    );
  }

  Widget _scoreWidget(int score, int index) {
    String firstStar, secondStar, thirdStar;
    double size;
    if(score != null) {
      if(categoryProvider.selectStageIndex != null && categoryProvider.selectStageIndex == index) {
        size = 24;
      }else {
        size = 16;
      }
      switch(score) {
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(firstStar, width: size, height: size),
          Image.asset(secondStar, width: size, height: size),
          Image.asset(thirdStar, width: size, height: size)
        ],
      );
    }else {
      return Container(height: 24,);
    }

  }

  Widget _stageWidget(StageVO stageVO, int index) {
    Color bgColor, borderColor, textColor;
    if(stageVO.score == null) {
      if(categoryProvider.selectStageIndex == index) {
        bgColor = MainColors.blue_100;
        textColor = Colors.white;
        borderColor = MainColors.blue_100;
      }else {
        bgColor = MainColors.grey_google;
        textColor = MainColors.grey_40;
        borderColor = MainColors.grey_google;
      }
    }else {
      if(categoryProvider.selectStageIndex == index) {
        bgColor = MainColors.blue_100;
        textColor = Colors.white;
        borderColor = MainColors.blue_100;
      }else {
        bgColor = Colors.white;
        textColor = MainColors.blue_100;
        borderColor = MainColors.blue_100;
      }
    }
    return GestureDetector(
      child: Card(
        elevation: 0,
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceWidth > 700 ? 30 : 24), side: BorderSide(width: 2, color: borderColor)),
        child: Container(
          width: deviceWidth * 0.11,
          height: deviceWidth * 0.11,
          alignment: AlignmentDirectional.center,
          child: Text(
            stageVO.stage.toString(),
            style: TextStyle(
              fontSize: (deviceWidth * 0.11) * 0.36,
              fontFamily: "TmoneyRound",
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
      onTap: () {
        if(_preScore[index]) {
          _selectedIndex = index;
          _selectedStageIdx = stageVO.stageIdx;
          _onSelectedStage();
        }
      },
    );
  }

  Widget _backButtonWidget() {
    return Container(
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: MainColors.purple_100, width: 2.0),
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(100.0),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Icon(Icons.arrow_back, color: MainColors.purple_100, size: 30),
          ),
          onTap: () {
            categoryProvider.selectStageIndex = -1;
            categoryProvider.selectStageIdx = -1;
            if(categoryProvider.stageAvgScore != 0) {
              categoryProvider.updateStageAvgScore();
            }
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _onSelectedStage() {            //  ListView Item Click
    categoryProvider.onSelectedStage(_selectedIndex, _selectedStageIdx);
    categoryProvider.onRootBookmark(false);
  }

  void _stageStart() {        //  Start Click
    resourceProviderModel.getPronunciation(
        authServiceAdapter.authJWT,
        categoryProvider.selectedSentence.id,
        categoryProvider.selectStageIdx,
        categoryProvider.selectStageIndex == 0 ? true : false,
        userProviderModel.userVOForHttp.defaultVoice       //  가입시 사용자가 선택한 성별로
    ).then((value) {
      final commonResult = resourceProviderModel.value.getPronunciation;
      final pronunResult = commonResult.result.asValue.value.result;
      categoryProvider.setPronunciationList(
          pronunResult['wrongPronunciationList'],
          PronunciationVO.fromJson(pronunResult['rightPronunciation'])
      );
      categoryProvider.initStepProgress();
      categoryProvider.onBookMark((userProviderModel.currentBookmarkList.singleWhere((it) => it.stageIdx == _selectedStageIdx, orElse: () => null)) != null);
      RouteNavigator().go(GetRoutesName.ROUTE_STAGE_QUIZ, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    for(int i = 1 ; i <= categoryProvider.stageList.length ; i++) {
      if(categoryProvider.stageList[i - 1].score != null) {
        _preScore.add(true);
      }else {
        _preScore.add(false);
      }
    }

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
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: deviceHeight > 380 ? 30 : 20, bottom: 4),
                  child: Text('$_title', style: Theme.of(context).textTheme.headline4),
                ),
                Text(
                  Strings.stage_script,
                  style: TextStyle(
                    color: MainColors.grey_90,
                    fontSize: 16,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w400
                  ),
                ),
                _listWidget(),          //  ListView
                Container(
                  margin: EdgeInsets.only(left: 36, right: 36, bottom: deviceHeight > 380 ? 32 : 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: _backButtonWidget(),    //  Back Button
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 7,
                        child: Container(
                          child:CommonRaisedButton(
                            buttonText: Strings.start_btn,
                            buttonColor: MainColors.purple_100,
                            textColor: Colors.white,
                            borderColor: MainColors.purple_100,
                            fontSize: 24,
                            voidCallback: _stageStart,   // Start Button
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
