import 'dart:math';

import 'package:deukki/data/model/sentence_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/category/medium_category_list_dialog.dart';
import 'package:deukki/view/ui/category/stage_dialog.dart';
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
  AnimationController _animationController;
  final random = Random();
  final List<Color> randomColor = [];
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
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);

    final isSetData = resourceProviderModel.value.getSentence;
    if(isSetData.hasData) {
      isSetData.result.asValue.value.forEach((element) {
        randomColor.add(MainColors.randomColorSmall[random.nextInt(MainColors.randomColorSmall.length)]);
      });
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
        num = temp.length / 2.5;
      }else if(temp.length > 2 && temp.length < 6){
        num = temp.length / 3;
      }else {
        num = temp.length / 3.6;
      }
      mainAxis.add(num);
    });
  }

  Widget _listWidget() {
    _setMainAxis();
    print("category small list");
    return Selector<CategoryProvider, List<SentenceVO>>(
      selector: (context, provider) => provider.sentenceList,
      builder: (context, sentences, child) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 40, bottom: 25),
            child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                scrollDirection: Axis.horizontal,
                itemCount: sentences.length,
                itemBuilder: (BuildContext context, index) {
                  return _listItemWidget(randomColor[index], sentences[index]);
                },
                staggeredTileBuilder: (index) => StaggeredTile.count(1, mainAxis[index])
            ),
          )
        );
      },
    );
  }

  Widget _listItemWidget(Color colors, SentenceVO sentenceVO) {
    return GestureDetector(
      child: Card(
        elevation: 0,
        color: colors,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
                  child: Text(
                    sentenceVO.content,
                    style: Theme.of(context).textTheme.subtitle1,
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
      onTap: () => {                //  ListView Item Click
        resourceProviderModel.getSentenceStages(authServiceAdapter.authJWT, sentenceVO.id).then((value) {
          categoryProvider.selectStageIndex = null;
          categoryProvider.onSelectedSentence(sentenceVO);
          final stageResult = resourceProviderModel.value.getSentenceStages;
          if(stageResult.hasData) {
            categoryProvider.setStage(stageResult.result.asValue.value);
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StageDialog(title: sentenceVO.content,);
              }
          );
        }),
      },
    );
  }

  Widget _newTagWidget(int isNew) {
    print("new tag widget");
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
    if(premium == 1) {
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
            Image.asset(firstStar, width: 22, height: 22),
            Image.asset(secondStar, width: 22, height: 22),
            Image.asset(thirdStar, width: 22, height: 22)
          ],
        ),
      );
    }else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 14, left: 44),
                    child: GestureDetector(                         //  Back button
                      child: Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child: Ink(
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
                            onTap: () => { Navigator.of(context).pop() },
                          ),
                        ),
                      ),
                      onTap: () => { _onBackPressed() },
                    ),
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 19, bottom: 20),
                          child: Text('${categoryProvider.getMediumTitle()}', style: Theme.of(context).textTheme.subtitle1,),
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
      onWillPop: _onBackPressed,
    );
  }
}
