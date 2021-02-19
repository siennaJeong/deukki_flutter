
import 'dart:ui';

import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/ui/base/ripple_animation.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class StageDialog extends StatefulWidget {
  final String title;
  final String sentenceId;

  StageDialog({@required this.title, @required this.sentenceId});

  @override
  _StageDialogState createState() => _StageDialogState();
}

class _StageDialogState extends State<StageDialog> with TickerProviderStateMixin{
  static const String PAGE_LEARNING_STAGE = "Learning Stage";
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;
  AuthServiceAdapter authServiceAdapter;
  UserProviderModel userProviderModel;

  final AutoScrollController _autoScrollController = AutoScrollController();
  AnimationController _controller;

  Size widgetSize;
  double deviceWidth, deviceHeight;
  String _title;
  String _sentenceId;
  int _selectedStageIdx, _selectedIndex;

  bool _isClick = false;

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  void initState() {
    _title = widget.title;
    _sentenceId = widget.sentenceId;
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);

    AnalyticsService().sendAnalyticsEvent("${AnalyticsService.VISIT}$PAGE_LEARNING_STAGE", <String, dynamic> {'sentence_id': _sentenceId});

    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this)
      ..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    categoryProvider.setSentenceTitle(_title);
    super.didChangeDependencies();
  }

  Widget _listWidget() {
    return Selector<CategoryProvider, List<StageVO>>(
      selector: (context, categoryProvider) => categoryProvider.stageList,
      builder: (context, stages, child) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 8, bottom: deviceHeight > 390 ? 30 : 20, left: 36),
            alignment: AlignmentDirectional.bottomCenter,
            child: ListView.separated(
              controller: _autoScrollController,
              padding: EdgeInsets.only(left: 0),
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: stages.length,
              itemBuilder: (BuildContext context, index) {
                return _autoScrollTag(index, stages[index]);
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

  Widget _autoScrollTag(int index, StageVO stageVO) {
    return AutoScrollTag(
        key: ValueKey(index),
        controller: _autoScrollController,
        index: index,
        child: _listItemWidget(stageVO, index)
    );
  }

  Widget _listItemWidget(StageVO stageVO, int index) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: deviceHeight > 420 ? MainAxisAlignment.center : MainAxisAlignment.end,
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
        size = deviceHeight > 420 ? 32 : 24;
      }else {
        size = deviceHeight > 420 ? 24 : 16;
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
        if(categoryProvider.preScoreList[index].isPreScoreExist) {
          _selectedIndex = index;
          _selectedStageIdx = stageVO.stageIdx;
          _onSelectedStage();

          if(index == categoryProvider.currentStageIndex) {
            AnalyticsService().sendAnalyticsEvent("LS Current Stage", <String, dynamic> {'stage_number': index});
          }else {
            AnalyticsService().sendAnalyticsEvent("LS Completed Stage", <String, dynamic> {'stage_number': index});
          }
        }else {
          AnalyticsService().sendAnalyticsEvent("LS Next Stage", <String, dynamic> {'stage_number': index});
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
            AnalyticsService().sendAnalyticsEvent("LS Back", null);
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

  Widget _startButtonWidget() {           //  Start Button
    if(userProviderModel.stageGuide == 0) {
      return RippleAnimation(
        controller: _controller,
        color: MainColors.purple_100,
        rippleTarget: _buttonWidget(),
      );
    }else {
      return _buttonWidget();
    }
  }

  Widget _buttonWidget() {
    return CommonRaisedButton(
      buttonText: Strings.start_btn,
      buttonColor: MainColors.purple_100,
      textColor: Colors.white,
      borderColor: MainColors.purple_100,
      fontSize: 24,
      voidCallback: _stageStart,
    );
  }

  void _onSelectedStage() {            //  ListView Item Click
    categoryProvider.onSelectedStage(_selectedIndex, _selectedStageIdx);
    categoryProvider.onRootBookmark(false);
  }

  void _stageStart() {        //  Start Click
    if(!_isClick) {
      AnalyticsService().sendAnalyticsEvent("LS Start", <String, dynamic> {'stage_number': categoryProvider.selectStageIndex});
      _isClick = true;
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
        categoryProvider.playCount = 0;
        categoryProvider.onBookMark((userProviderModel.currentBookmarkList.singleWhere((it) => it.stageIdx == categoryProvider.selectStageIdx, orElse: () => null)) != null);
        RouteNavigator().go(GetRoutesName.ROUTE_STAGE_QUIZ, context);

        _isClick = false;
        userProviderModel.setStageGuide();
        _controller?.stop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    categoryProvider.initPreScore();

    setState(() {
      _autoScrollController.scrollToIndex(
          categoryProvider.selectStageIndex,
          preferPosition: AutoScrollPosition.middle,
          duration: Duration(milliseconds: 500));
    });

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
                  margin: EdgeInsets.only(top: deviceHeight > 390 ? 30 : 20, bottom: 4),
                  child: Text(
                    '$_title',
                    style: Theme.of(context).textTheme.headline4,
                  ),
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
                          child: _startButtonWidget(),
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
