import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/ui/category/medium_category_list_dialog.dart';
import 'package:deukki/view/ui/category/stage_dialog.dart';
import 'package:deukki/view/ui/mypage/my_page.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class CategorySmall extends BaseWidget {
  @override
  _CategorySmallState createState() => _CategorySmallState();
}

class _CategorySmallState extends State<CategorySmall> with SingleTickerProviderStateMixin {
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;
  AuthServiceAdapter authServiceAdapter;
  UserProviderModel userProviderModel;
  AnimationController _animationController;

  double deviceWidth, deviceHeight;

  final random = Random();
  final List<Color> cellColor = [];
  List<num> mainAxis = [];
  List<SentenceVO> sentenceList = [];

  @override
  void initState() {
    _animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);

    final isSetData = resourceProviderModel.value.getSentence;
    if(isSetData.hasData) {
      for(int i = 0 ; i < isSetData.result.asValue.value.length ; i++) {
        cellColor.add(MainColors.randomColorSmall[i % 4]);
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    categoryProvider.onSelectedLarge(null);
    setState(() {
      Navigator.of(context).pop();
    });
    return Future(() => true);
  }

  void _setMainAxis() {
    if(mainAxis.length > 0) {
      mainAxis.clear();
    }
    categoryProvider.sentenceList.forEach((element) {
      String temp = element.content.replaceAll(" ", "");
      var num;
      if(temp.length == 1) {
        num = temp.length / 1.3;
      }else if(temp.length > 1 && temp.length <= 2) {
        num = temp.length / 2.4;
      }else if(temp.length > 2 && temp.length < 6){
        num = temp.length / 2.9;
      }else {
        num = temp.length / 3.6;
      }
      mainAxis.add(num);
    });
  }

  void _membershipDialog() {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return _dialogWidget();
      }
    );
  }

  void _dismissDialog() {
    Navigator.of(context).pop();
  }

  void _joinMembership() {
    _dismissDialog();
    Navigator.pushNamed(context, GetRoutesName.ROUTE_MYPAGE, arguments: 2);
  }

  Widget _listWidget() {
    _setMainAxis();
    return Selector<CategoryProvider, List<SentenceVO>>(
      selector: (context, provider) => provider.sentenceList,
      builder: (context, sentences, child) {
        if(sentences.length > 0) {
          return Expanded(
              child: Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.only(bottom: 25, left: 40),
                child: StaggeredGridView.countBuilder(
                    shrinkWrap: false,
                    padding: EdgeInsets.only(left: 0),
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: deviceHeight > 700 ? 3 : 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    scrollDirection: Axis.horizontal,
                    itemCount: sentences.length,
                    itemBuilder: (BuildContext context, index) {
                      return _listItemWidget(cellColor[index], sentences[index]);
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.count(1, mainAxis[index])
                ),
              )
          );
        }else {
          return Container(
            margin: EdgeInsets.only(top: deviceHeight * 0.27),
            child: Text(
              Strings.no_data,
              style: TextStyle(
                  color: MainColors.grey_70,
                  fontSize: 20,
                  fontFamily: "TmoneyRound",
                  fontWeight: FontWeight.w700
              ),
            ),
          );
        }
      },
    );
  }

  Widget _listItemWidget(Color colors, SentenceVO sentenceVO) {
    return GestureDetector(
      child: Card(
        elevation: 0,
        color: colors,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    sentenceVO.content,
                    style: deviceHeight > 700 ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              Positioned(child: _premiumTagWidget(sentenceVO.premium)),
              Positioned(left: 4, bottom: 4, child: _newTagWidget(sentenceVO.isNew)),
              Positioned(right: 0, top: 0, child: _scoreTagWidget(sentenceVO.avgScore)),
            ],
          ),
        ),
      ),
      onTap: () {                //  ListView Item Click
        if(userProviderModel.userVOForHttp.premium == sentenceVO.premium) {
          resourceProviderModel.getSentenceStages(authServiceAdapter.authJWT, sentenceVO.id).then((value) {
            categoryProvider.selectStageIndex = -1;
            categoryProvider.stageAvgScore = 0;
            categoryProvider.onSelectedSentence(sentenceVO);
            final stageResult = resourceProviderModel.value.getSentenceStages;
            if(stageResult.hasData) {
              categoryProvider.setStage(stageResult.result.asValue.value);
              categoryProvider.setPreScore(null);
            }
            showDialog(
                context: context,
                useSafeArea: false,
                builder: (BuildContext context) {
                  return StageDialog(title: sentenceVO.content,);
                }
            );
          });
        }else {
          //  다이얼로그 띄우기
          _membershipDialog();
        }
      },
    );
  }

  Widget _newTagWidget(int isNew) {
    if(isNew == 1) {
      return Container(
        margin: EdgeInsets.only(left: 2, bottom: 4),
        padding: EdgeInsets.only(top: 3, bottom: 3, left: 6, right: 6),
        decoration: BoxDecoration(
            color: MainColors.purple_100,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
          child: Text(
            Strings.category_new,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'TmoneyRound',
                fontWeight: FontWeight.w700,
                color: Colors.white
            ),
          ),
        ),
      );
    }else {
      return Container();
    }
  }

  Widget _premiumTagWidget(int premium) {
    if(userProviderModel.userVOForHttp.premium == 0 && userProviderModel.userVOForHttp.premium < premium) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
              color: MainColors.black_50,
              borderRadius: BorderRadius.circular(24)
          ),
          child: Icon(Icons.lock, size: 28, color: Colors.white,)
      );
    }else {
      return Container();
    }
  }

  Widget _scoreTagWidget(double avgScore) {
    String firstStar, secondStar, thirdStar;
    double size = deviceHeight > 700 ? 32 : 22;
    if(avgScore != null) {
      if(avgScore > 0 && avgScore < 1) {
        firstStar = AppImages.halfStar;
        secondStar = AppImages.emptyStar;
        thirdStar = AppImages.emptyStar;
      }else if(avgScore >= 1 && avgScore < 1.5) {
        firstStar = AppImages.fullStar;
        secondStar = AppImages.emptyStar;
        thirdStar = AppImages.emptyStar;
      }else if(avgScore >= 1.5 && avgScore < 2) {
        firstStar = AppImages.fullStar;
        secondStar = AppImages.halfStar;
        thirdStar = AppImages.emptyStar;
      }else if(avgScore >= 2 && avgScore < 2.5) {
        firstStar = AppImages.fullStar;
        secondStar = AppImages.fullStar;
        thirdStar = AppImages.emptyStar;
      }else if(avgScore >= 2.5 && avgScore < 3) {
        firstStar = AppImages.fullStar;
        secondStar = AppImages.fullStar;
        thirdStar = AppImages.halfStar;
      }else {
        firstStar = AppImages.fullStar;
        secondStar = AppImages.fullStar;
        thirdStar = AppImages.fullStar;
      }
      return Container(
        padding: EdgeInsets.only(left: 7, bottom: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
        ),
        child: Row(
          children: [
            Image.asset(firstStar, width: size, height: size),
            Image.asset(secondStar, width: size, height: size),
            Image.asset(thirdStar, width: size, height: size)
          ],
        ),
      );
    }else {
      return Container();
    }
  }

  Widget _dialogWidget() {
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
            width: deviceWidth * 0.5,
            height: deviceHeight * 0.43,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          left: false,
          bottom: false,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 14, left: 44),
                      child: Ink(                                               //  Back Button
                        decoration: BoxDecoration(
                          border: Border.all(color: MainColors.green_100, width: 2.0),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.arrow_back, color: MainColors.green_100, size: 30),
                          ),
                          onTap: () {
                            categoryProvider.onSelectedLarge(-1);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 19, bottom: 20),
                            child: Text(
                              '${categoryProvider.getMediumTitle()}',
                              style: deviceHeight > 700 ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            child: FadeTransition(
                              opacity: _animationController,
                              child: Image.asset(AppImages.expandMore, width: 32, height: 32,),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => {                      //  More List Button
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            useSafeArea: false,
                            builder: (BuildContext context) {
                              return MediumCategoryListDialog(
                                title: categoryProvider.getMediumTitle(),
                                list: categoryProvider.categoryMediumList,
                              );
                            }
                        ).then((value) => {
                          if(value != null) {
                            resourceProviderModel.getSentence(authServiceAdapter.authJWT, value[1]).then((val) {
                              categoryProvider.setMediumTitle(value[0]);
                              categoryProvider.setMediumId(value[1]);
                              final sentenceResult = resourceProviderModel.value.getSentence;
                              if(sentenceResult.hasData) {
                                categoryProvider.setSentence(sentenceResult.result.asValue.value);
                                _setMainAxis();
                              }
                            })
                          }
                        }),
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _listWidget(),
              ],
            ),
          ),
        ),
      ),
      onWillPop: _onBackPressed,
    );
  }
}
