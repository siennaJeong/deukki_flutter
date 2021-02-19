import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/provider/resource/mypage_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/mypage/bookmark.dart';
import 'package:deukki/view/ui/mypage/qna.dart';
import 'package:deukki/view/ui/mypage/membership.dart';
import 'package:deukki/view/ui/mypage/report.dart';
import 'package:deukki/view/ui/mypage/settings.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  static const String PAGE_MY = "My Tab";
  UserProviderModel userProviderModel;
  MyPageProvider myPageProvider;

  List<String> tabButtons = [Strings.mypage_report, Strings.mypage_bookmark, Strings.mypage_membership, Strings.mypage_setting, Strings.mypage_help];
  List<BookmarkVO> bookmarks;
  double deviceWidth, deviceHeight;

  PageController _pageController;
  int pages = -1;

  @override
  void initState() {
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    myPageProvider = Provider.of<MyPageProvider>(context);
    bookmarks = userProviderModel.currentBookmarkList;
    super.didChangeDependencies();
  }

  Widget _tabWidget() {
    return Container(
      width: deviceWidth,
      margin: EdgeInsets.only(top: 14, bottom: 14),
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: <Widget>[
          _backButtonWidget(),
          Consumer<MyPageProvider>(
            builder: (BuildContext context, buttonIndex, child) {
              return _tabButtonsWidget();
            },
          )
        ],
      ),
    );
  }

  Widget _tabButtonsWidget() {
    return Container(
      width: deviceWidth,
      margin: EdgeInsets.only(left: deviceWidth * 0.2, right: deviceWidth * 0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buttons(tabButtons[0], 0),
          _buttons(tabButtons[1], 1),
          _buttons(tabButtons[2], 2),
          _buttons(tabButtons[3], 3),
          _buttons(tabButtons[4], 4),
        ],
      )
    );
  }

  Widget _buttons(String buttonText, int index) {         // Tab Buttons
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 13, right: 13),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 16,
              fontFamily: "TmoneyRound",
              fontWeight: FontWeight.w700,
              color: myPageProvider.getButtonIndex() == index ? MainColors.purple_100 : MainColors.grey_text,
          ),
        ),
      ),
      onTap: () {
        myPageProvider.setButtonIndex(index);
        _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);

        switch(index) {
          case 0:
            AnalyticsService().sendAnalyticsEvent("$PAGE_MY Report", null);
            break;
          case 1:
            AnalyticsService().sendAnalyticsEvent("$PAGE_MY Bookmark", null);
            break;
          case 2:
            AnalyticsService().sendAnalyticsEvent("$PAGE_MY Membership", null);
            break;
          case 3:
            AnalyticsService().sendAnalyticsEvent("$PAGE_MY Settings", null);
            break;
          case 4:
            AnalyticsService().sendAnalyticsEvent("$PAGE_MY Help", null);
            break;
        }
      },
    );
  }


  Widget _backButtonWidget() {
    return Container(
      margin: EdgeInsets.only(left: 40),
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
          onTap: () {
            AnalyticsService().sendAnalyticsEvent("$PAGE_MY Back", null);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _pageViewWidget() {
    return Consumer<MyPageProvider>(
      builder: (BuildContext context, pageIndex, child) {
        return _pageViewItemWidget();
      },
    );
  }

  Widget _pageViewItemWidget() {
    return Expanded(
      child: Container(
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          onPageChanged: (index) {
            myPageProvider.setButtonIndex(index);
          },
          children: <Widget>[
            Report(),
            BookMark(bookmarkList: bookmarks,),
            MemberShip(),
            Settings(),
            QnA()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    if(pages == -1) {
      pages = ModalRoute.of(context).settings.arguments;
      myPageProvider.initButtonIndex(pages);
      _pageController ??= PageController(initialPage: pages);
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            left: false,
            right: false,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _tabWidget(),
                  _pageViewWidget()
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: myPageProvider.getIsPaying(),
          child: Container(
            color: Colors.black26,
            alignment: AlignmentDirectional.center,
            child: CupertinoActivityIndicator(radius: 14),
          ),
        ),
      ],
    );
  }
}
