import 'dart:math';
import 'dart:ui';

import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediumCategoryListDialog extends StatefulWidget {
  final String title;
  final List<CategoryMediumVO> list;

  MediumCategoryListDialog({@required this.title, @required this.list});

  @override
  _MediumCategoryListDialogState createState() => _MediumCategoryListDialogState();
}

class _MediumCategoryListDialogState extends State<MediumCategoryListDialog> {
  String _title;
  List<CategoryMediumVO> _list;

  @override
  void initState() {
    _title = widget.title;
    _list = widget.list;
    super.initState();
  }

  Widget _listWidget(List<CategoryMediumVO> list) {
    List<double> scores = [];   //  test
    for(int i = 0 ; i < list.length ; i++) {
      if(list[i].archiveStars == 0) {
        scores.add(0.0);
      }else {
        scores.add(list[i].archiveStars / list[i].totalStars);
      }
    }
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, index) {
            return _listItemWidget(
                scores[index],
                list[index],
                index,
                list.length
            );
          },
        ),
      ),
    );
  }

  Widget _listItemWidget(double progress, CategoryMediumVO mediumVO, int index, int length) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Stack(
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
          ),
          SizedBox(height: 8,),
          _divider(index, length),
        ],
      ),
      onTap: () => { Navigator.of(context).pop([mediumVO.title, mediumVO.id]) },    //  List Item Button
    );
  }

  Widget _divider(int index, int length) {
    if(index + 1 < length) {
      return Divider();
    }else {
      return Container();
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
        )
      ],
    );
  }
}
