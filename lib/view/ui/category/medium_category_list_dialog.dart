import 'dart:convert';
import 'dart:ui';

import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/view/ui/base/membership_dialog_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MediumCategoryListDialog extends StatefulWidget {
  final String title;
  final List<CategoryMediumVO> list;
  final int premium;

  MediumCategoryListDialog({@required this.title, @required this.list, @required this.premium});

  @override
  _MediumCategoryListDialogState createState() => _MediumCategoryListDialogState();
}

class _MediumCategoryListDialogState extends State<MediumCategoryListDialog> {
  static const String PAGE_LEARNING_CATEGORY = "Learning Category";
  final AutoScrollController _autoScrollController = AutoScrollController();
  String _title;
  int _userPremium;
  List<CategoryMediumVO> _list;
  List<double> scores = [];

  double deviceWidth, deviceHeight;

  @override
  void initState() {
    _title = widget.title;
    _list = widget.list;
    _userPremium = widget.premium;

    AnalyticsService().sendAnalyticsEvent("${AnalyticsService.VISIT}$PAGE_LEARNING_CATEGORY", null);
    super.initState();
  }

  Widget _listWidget(List<CategoryMediumVO> list) {
    if(scores.length <= 0) {
      for(int i = 0 ; i < list.length ; i++) {
        if(list[i].archiveStars == 0) {
          scores.add(0.0);
        }else {
          scores.add(list[i].archiveStars / list[i].totalStars);
        }
      }
    }
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: ListView.separated(
          controller: _autoScrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (BuildContext context, index) {
            return _autoScrollTag(
                scores[index],
                list[index],
                index,
                list.length
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
    );
  }

  Widget _autoScrollTag(double progress, CategoryMediumVO mediumVO, int index, int length) {
    return AutoScrollTag(
        key: ValueKey(index),
        controller: _autoScrollController,
        index: index,
        child: _listItemWidget(progress, mediumVO, index, length)
    );
  }

  Widget _listItemWidget(double progress, CategoryMediumVO mediumVO, int index, int length) {
    return GestureDetector(
      child: Container(
        height: deviceHeight * 0.18,
        child: Stack(
          children: <Widget>[
            Positioned(child: _titleWidget(progress, mediumVO, index, length, mediumVO.premium ? 1 : 0)),
            Positioned(child: _premiumTagWidget(mediumVO.premium ? 1 : 0)),
          ],
        ),
      ),
      onTap: () {             //  List Item Click
        if(_userPremium == 0) {
          if(!mediumVO.premium) {
            AnalyticsService().sendAnalyticsEvent("LC Select", <String, dynamic> {'category_id': mediumVO.id});
            Navigator.of(context).pop(json.encode(mediumVO));
          }else {
            AnalyticsService().sendAnalyticsEvent("LC Disable Select", <String, dynamic> {'category_id': mediumVO.id});
            showDialog(
                context: context,
                useSafeArea: false,
                builder: (BuildContext context) {
                  return MemberShipDialog(deviceWidth: deviceWidth, deviceHeight: deviceHeight, callFrom: PAGE_LEARNING_CATEGORY);
                }
            );
          }
        }else {
          Navigator.of(context).pop(json.encode(mediumVO));

          if(!mediumVO.premium) {
            AnalyticsService().sendAnalyticsEvent("LC Select", <String, dynamic> {'category_id': mediumVO.id});
          }else {
            AnalyticsService().sendAnalyticsEvent("LC Disable Select", <String, dynamic> {'category_id': mediumVO.id});
          }
        }
      },
    );
  }

  Widget _premiumTagWidget(int premium) {
    if(_userPremium == 0 && _userPremium < premium) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
              color: MainColors.black_50,
              borderRadius: BorderRadius.circular(16)
          ),
          child: Icon(Icons.lock, size: 28, color: Colors.white,)
      );
    }else {
      return Container();
    }
  }

  Widget _titleWidget(double progress, CategoryMediumVO mediumVO, int index, int length, int premium) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              mediumVO.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MainColors.grey_100,
                fontSize: 20,
                fontFamily: "TmoneyRound",
              ),
            ),
          ),
          _progressWidget(progress, mediumVO, index, length, premium),
        ],
      ),
    );
  }

  Widget _progressWidget(double progress, CategoryMediumVO mediumVO, int index, int length, int premium) {
    if(_userPremium == 0 && _userPremium < premium) {
      return Container();
    }else {
      return Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Positioned(
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: LinearProgressIndicator(
                value: progress,
                valueColor: AlwaysStoppedAnimation<Color>(MainColors.yellow_80),
                backgroundColor: MainColors.grey_google,
                minHeight: 7.0,
              ),
            ),
          ),
          Image.asset(AppImages.fullStar, width: 20, height: 20,),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    setState(() {
      _autoScrollController.scrollToIndex(
          _list.indexWhere((element) => element.title == _title),
          preferPosition: AutoScrollPosition.middle,
          duration: Duration(milliseconds: 500));
    });

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9.2, sigmaY: 9.2),
            child: GestureDetector(
              child: Container(color: Colors.black.withOpacity(0.1)),
              onTap: () {
                AnalyticsService().sendAnalyticsEvent("LC Outside", null);
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: 406,
            height: 370,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 19, bottom: 20),
                      child: Text(_title, style: Theme.of(context).textTheme.subtitle1,),
                    ),
                    SizedBox(width: 8),
                    Container(
                      child: Image.asset(AppImages.expandMore, width: 32, height: 32,),
                    ),
                  ],
                ),
                _listWidget(_list)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
