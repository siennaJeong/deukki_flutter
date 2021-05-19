import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final PageController _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  AuthServiceAdapter authServiceAdapter;
  double _deviceWidth, _deviceHeight;

  List<String> guideImages = [
    AppImages.guide_1,
    AppImages.guide_2,
    AppImages.guide_3,
    AppImages.guide_4,
    AppImages.guide_5,
    AppImages.guide_6,
    AppImages.guide_7
  ];

  @override
  void initState() {
    super.initState();
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
  }

  Widget _pageViewWidget() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _setCurrentPage,
      itemCount: guideImages.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox.expand(
          child: Container(
            child: Image.asset(guideImages[index], fit: BoxFit.fitHeight,),
          ),
        );
      },
    );
  }

  Widget _indicatorWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 27),
      child: CirclePageIndicator(
        currentPageNotifier: _currentPageNotifier,
        itemCount: guideImages.length,
        dotColor: Colors.white,
        selectedDotColor: MainColors.green_30,
        dotSpacing: 15,
      ),
    );
  }

  Widget _skipButtonWidget() {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 15),
      child: TextButton(
        child: Image.asset(AppImages.skipButton, width: 60,),
        onPressed: () => {
          _exitTutorial()
        },
      ),
    );
  }

  Widget _moveButtonWidget(bool isNext, String img) {
    return Container(
      margin: EdgeInsets.only(left: 12),
      child: TextButton(
        child: Image.asset(img, width: 16,),
        onPressed: () => {
          _movePage(isNext)
        },
      ),
    );
  }

  Widget _startButtonWidget() {
    return Container(
      margin: EdgeInsets.only(left: _deviceWidth * 0.24, bottom: 40),
      child: TextButton(
        child: Image.asset(AppImages.startButton, width: _deviceWidth * 0.32,),
        onPressed: () => {
          _exitTutorial()
        },
      ),
    );
  }

  void _setCurrentPage(int pages) {
    setState(() {
      _currentPageNotifier.value = pages;
    });
  }

  void _movePage(bool isNext) {
    if(isNext) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }else {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _exitTutorial() {
    authServiceAdapter.setSkipTutorial("true");
    if(authServiceAdapter.authJWT.isNotEmpty) {
      RouteNavigator().go(GetRoutesName.ROUTE_MAIN, context);
    }else {
      RouteNavigator().go(GetRoutesName.ROUTE_LOGIN, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: _pageViewWidget()),
            Positioned(right: 0, top: 0, child: _skipButtonWidget()),
            Positioned(left: 0, top: 0, bottom: 0, child: _currentPageNotifier.value <= 0 ? Container() : _moveButtonWidget(false, AppImages.arrowLeft)),
            Positioned(right: 0, top: 0, bottom: 0, child: _currentPageNotifier.value > 5 ? Container() : _moveButtonWidget(true, AppImages.arrowRight)),
            Positioned(bottom: 0, left: 0, right: 0, child: _currentPageNotifier.value > 5 ? _startButtonWidget() : Container()),
            Positioned(bottom: 0, left: 0, right: 0, child: _currentPageNotifier.value > 5 ? Container() : _indicatorWidget()),
          ],
        ),
      ),
    );
  }
}
