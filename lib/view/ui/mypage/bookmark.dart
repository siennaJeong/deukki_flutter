import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookMark extends StatefulWidget {
  final List<BookmarkVO> bookmarkList;

  BookMark({@required this.bookmarkList});

  @override
  _BookMarkState createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  List<BookmarkVO> _bookmarkList;
  double deviceWidth, deviceHeight;
  ResourceProviderModel resourceProviderModel;
  CategoryProvider categoryProvider;
  AuthServiceAdapter authServiceAdapter;

  @override
  void didChangeDependencies() {
    _bookmarkList = widget.bookmarkList;
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    super.didChangeDependencies();
  }

  Widget _listWidget(double deviceWidth, double deviceHeight) {
    if(_bookmarkList.length <= 0) {
      return _noListWidget();
    }else {
      return GridView.count(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: (deviceWidth * 0.44) / (deviceHeight * 0.26),
        children: List.generate(_bookmarkList.length, (index) {
          return _listItemWidget(index, deviceWidth, deviceHeight);
        }),
      );
    }
  }

  Widget _listItemWidget(int index, double deviceWidth, double deviceHeight) {
    String firstStar, secondStar, thirdStar;
    if(_bookmarkList[index].score == 1) {
      firstStar = AppImages.fullStar;
      secondStar = AppImages.emptyStar;
      thirdStar = AppImages.emptyStar;
    }else if(_bookmarkList[index].score == 2) {
      firstStar = AppImages.fullStar;
      secondStar = AppImages.fullStar;
      thirdStar = AppImages.emptyStar;
    }else if(_bookmarkList[index].score == 3) {
      firstStar = AppImages.fullStar;
      secondStar = AppImages.fullStar;
      thirdStar = AppImages.fullStar;
    }else {
      firstStar = AppImages.emptyStar;
      secondStar = AppImages.emptyStar;
      thirdStar = AppImages.emptyStar;
    }

    return GestureDetector(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: MainColors.grey_50,
            width: 2,
          ),
        ),
        elevation: 0,
        child: Container(
          width: deviceWidth * 0.44,
          height: deviceHeight * 0.26,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Row(
                  children: <Widget>[
                    Image.asset(AppImages.bookmarkActive, width: 44, height: 44),
                    SizedBox(width: 16),
                    Text(
                      "${_bookmarkList[index].content} - ${_bookmarkList[index].stage.toString()}단계",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "TmoneyRound",
                        fontWeight: FontWeight.w700,
                        color: MainColors.grey_100,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 76),
                child: Row(
                  children: <Widget>[
                    Image.asset(firstStar, width: 20,),
                    Image.asset(secondStar, width: 20,),
                    Image.asset(thirdStar, width: 20,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        //  stage quiz 화면으로
        resourceProviderModel.getPronunciation(
            authServiceAdapter.authJWT,
            _bookmarkList[index].sentenceId,
            _bookmarkList[index].stageIdx,
            _bookmarkList[index].stage == 1 ? true : false,
            "M"       //  가입시 사용자가 선택한 성별로
        ).then((value) {
          final commonResult = resourceProviderModel.value.getPronunciation;
          final pronunResult = commonResult.result.asValue.value.result;
          categoryProvider.setPronunciationList(
              pronunResult['wrongPronunciationList'],
              PronunciationVO.fromJson(pronunResult['rightPronunciation'])
          );
          categoryProvider.onSelectedStage(_bookmarkList[index].stage - 1, _bookmarkList[index].stageIdx);
          categoryProvider.setSentenceTitle(_bookmarkList[index].content);
          categoryProvider.initStepProgress();
          categoryProvider.onBookMark(true);
          categoryProvider.onRootBookmark(true);
          RouteNavigator().go(GetRoutesName.ROUTE_STAGE_QUIZ, context);
        });
      },
    );
  }

  Widget _noListWidget() {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(AppImages.bookmarkActive, width: 44, height: 44),
          SizedBox(width: 16),
          Text(
            Strings.mypage_bookmark_nothing,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "TmoneyRound",
              fontWeight: FontWeight.w700,
              color: MainColors.grey_100
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(top: 8, right: deviceWidth > 700 ? 0 : 40, left: deviceWidth > 700 ? 0 : 40),
      child: _listWidget(deviceWidth, deviceHeight),
    );
  }
}
