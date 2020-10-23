
import 'dart:ui';

import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/model/stage_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  String _title;
  int _selectedStageIdx, _selectedIndex;
  bool _isStart;
  List<bool> _preScore = [true];

  @override
  void initState() {
    _title = widget.title;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    for(int i = 1 ; i <= categoryProvider.stageList.length ; i++) {
      if(categoryProvider.stageList[i - 1].score != null) {
        _preScore.add(true);
      }else {
        _preScore.add(false);
      }
    }
    categoryProvider.setSentenceTitle(_title);
    super.didChangeDependencies();
  }

  Widget _listWidget() {
    return Selector<CategoryProvider, List<StageVO>>(
      selector: (context, categoryProvider) => categoryProvider.stageList,
      builder: (context, stages, child) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 8, bottom: 30, left: 36),
            alignment: AlignmentDirectional.bottomCenter,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
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
    if(stageVO.score != null) {
      borderColor = MainColors.blue_100;
      if(categoryProvider.selectStageIndex != null && categoryProvider.selectStageIndex == index) {
        bgColor = MainColors.blue_100;
        textColor = Colors.white;
      }else {
        bgColor = Colors.white;
        textColor = MainColors.blue_100;
      }
    }else {
      if(categoryProvider.selectStageIndex != null && categoryProvider.selectStageIndex == index) {
        bgColor = MainColors.blue_100;
        textColor = Colors.white;
        borderColor = MainColors.blue_100;
      }else {
        bgColor = MainColors.grey_google;
        textColor = MainColors.grey_40;
        borderColor = MainColors.grey_google;
      }
    }
    return GestureDetector(
      child: Card(
        elevation: 0,
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(width: 2, color: borderColor)),
        child: Container(
          width: 90.0,
          height: 90.0,
          alignment: AlignmentDirectional.center,
          child: Text(
            stageVO.stage.toString(),
            style: TextStyle(
              fontSize: 32,
              fontFamily: "TmoneyRound",
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
      onTap: () => { _onSelectedStage(index, stageVO.stageIdx) },
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
          onTap: () => { Navigator.of(context).pop() },
        ),
      ),
    );
  }

  void _onSelectedStage(int index, int stageIdx) {            //  ListView Item Click
    _isStart = _preScore[index] ? true : false;
    _selectedIndex = index;
    _selectedStageIdx = stageIdx;
    categoryProvider.onSelectedStage(index);
  }

  void _stageStart() {        //  Start Click
    if(_isStart) {
      resourceProviderModel.getPronunciation(
        authServiceAdapter.authJWT,
        categoryProvider.selectedSentence.id,
        _selectedStageIdx,
        _selectedIndex == 1 ? true : false,
        "M"       //  가입시 사용자가 선택한 성별로
      ).then((value) {
        final commonResult = resourceProviderModel.value.getPronunciation;
        final pronunResult = commonResult.result.asValue.value.result;
        categoryProvider.setPronunciationList(
            pronunResult['wrongPronunciationList'],
            PronunciationVO.fromJson(pronunResult['rightPronunciation'])
        );
        RouteNavigator().go(GetRoutesName.ROUTE_STAGE_QUIZ, context);
      });
    }
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
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 4),
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
                  margin: EdgeInsets.only(left: 36, right: 36, bottom: 32),
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
