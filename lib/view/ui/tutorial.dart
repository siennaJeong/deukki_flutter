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

  String _buttonText = Strings.skip_btn;
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

  void _setCurrentPage(int pages) {
    setState(() {
      _currentPageNotifier.value = pages;
    });
  }

  void _exitTutorial() {
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
            Positioned(bottom: 0, left: 0, right: 0, child: _indicatorWidget()),
          ],
        ),
      ),
    );
  }
}
