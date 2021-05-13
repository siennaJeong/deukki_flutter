import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final PageController _pageController = PageController(initialPage: 0);
  AuthServiceAdapter authServiceAdapter;
  double _deviceWidth, _deviceHeight;

  String _buttonText = Strings.skip_btn;
  List<Color> testColor = [Colors.blue, Colors.amber, Colors.green, Colors.deepPurpleAccent];

  @override
  void initState() {
    super.initState();
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
  }

  Widget _pageViewWidget() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _setCurrentPage,
      itemCount: testColor.length,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox.expand(
          child: Container(
            color: testColor[index],
            child: Center(
              child: Text("pages : $index"),
            ),
          ),
        );
      },
    );
  }

  Widget _skipButtonWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 40, left: _deviceWidth * 0.32, right: _deviceWidth * 0.32),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(14),
            primary: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                side: BorderSide(
                    color: Colors.white,
                    width: 2.0
                )
            ),
          ),
          child: Text(
            _buttonText,
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: "TmoneyRound",
                fontWeight: FontWeight.w700
            ),
          ),
          onPressed: () => { _exitTutorial() }
      ),
    );
  }

  void _setCurrentPage(int pages) {
    setState(() {
      if(pages >= 3) {
        _buttonText = Strings.start_btn;
      }else {
        _buttonText = Strings.skip_btn;
      }
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
            Positioned(bottom: 0, left: 0, right: 0, child: _skipButtonWidget()),
          ],
        ),
      ),
    );
  }
}
