import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainCategory extends BaseWidget {
  @override
  _MainCategoryState createState() => _MainCategoryState();
}

class _MainCategoryState extends State<MainCategory> {
  static const String PAGE_MAIN = "main";
  AuthServiceAdapter authServiceAdapter;
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;
  Future<void> getAllBookmark;
  Future<void> getUserInfo;
  Future<void> getProductList;
  Future<void> getReports;

  double deviceWidth, deviceHeight;

  bool isClick = false;

  @override
  void initState() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    getUserInfo ??= Provider.of<UserProviderModel>(context, listen: false).getUserInfo(authServiceAdapter.authJWT, authServiceAdapter);
    getAllBookmark ??= Provider.of<UserProviderModel>(context, listen: false).getBookmark(authServiceAdapter.authJWT);
    getProductList ??= Provider.of<UserProviderModel>(context, listen: false).getProductList(authServiceAdapter.authJWT);
    getReports ??= Provider.of<UserProviderModel>(context, listen: false).getReports(authServiceAdapter.authJWT);

    AnalyticsService().sendAnalyticsEvent(true, authServiceAdapter.userVO.premium == 0 ? false : true, PAGE_MAIN, "", "", "");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    super.didChangeDependencies();
  }

  Widget _categoryLargeList() {

    void _onSelectedLarge(int index, String largeId) {
      categoryProvider.onSelectedLarge(index);
      resourceProviderModel.getCategoryMediumStar(authServiceAdapter.authJWT, largeId);
      categoryProvider.setMediumCategory(largeId).then((value) {
        resourceProviderModel.getSentence(authServiceAdapter.authJWT, categoryProvider.getMediumId()).then((value) {
          final sentenceResult = resourceProviderModel.value.getSentence;
          if(sentenceResult.hasData) {
            categoryProvider.setSentence(sentenceResult.result.asValue.value);
          }
          RouteNavigator().go(GetRoutesName.ROUTE_CATEGORY_SMALL, context);
          isClick = false;
        });
      });
    }

    return Selector<CategoryProvider, List<CategoryLargeVO>>(
      selector: (context, categoryProvider) => categoryProvider.categoryLargeList,
      builder: (context, largeList, child) {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: largeList.length,
          itemBuilder: (BuildContext context, index) {
            CategoryLargeVO largeVO = largeList[index];
            String subString;
            if(largeVO.title.length > 2) {
              subString = largeVO.title.substring(0, largeVO.title.length - 3);
              subString = subString.replaceAll(" ", "\n");
            }else {
              subString = largeVO.title;
            }

            return GestureDetector(
              child: Card(
                color: categoryProvider.selectLargeIndex != null && categoryProvider.selectLargeIndex == index
                    ? Colors.white : MainColors.randomColorMain[index],
                margin: EdgeInsets.only(left: 8, right: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: MainColors.randomColorMain[index],
                    width: 2.5,
                  ),
                ),
                elevation: 0,
                child: Container(
                  width: deviceHeight > 390 ? deviceWidth * 0.19 : deviceWidth * 0.172,
                  child: Center(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Image.asset(
                            categoryProvider.selectLargeIndex != null && categoryProvider.selectLargeIndex == index
                                ? AppImages.randomImageColor[index]
                                : AppImages.randomImage[index]),
                        Text(
                          subString,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "TmoneyRound",
                            fontWeight: FontWeight.w700,
                            color: categoryProvider.selectLargeIndex != null && categoryProvider.selectLargeIndex == index
                                ? MainColors.randomColorMain[index]
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {                             //  ListView Item Click
                if(!isClick) {
                  isClick = true;
                  _onSelectedLarge(index, largeVO.id);

                  switch(index) {
                    case 0:
                      AnalyticsService().sendAnalyticsEvent(false, authServiceAdapter.userVO.premium == 0 ? false : true, PAGE_MAIN, "word", "", "");
                      break;
                    case 1:
                      AnalyticsService().sendAnalyticsEvent(false, authServiceAdapter.userVO.premium == 0 ? false : true, PAGE_MAIN, "sentence", "", "");
                      break;
                    case 2:
                      AnalyticsService().sendAnalyticsEvent(false, authServiceAdapter.userVO.premium == 0 ? false : true, PAGE_MAIN, "field_sentence", "", "");
                      break;
                    case 3:
                      AnalyticsService().sendAnalyticsEvent(false, authServiceAdapter.userVO.premium == 0 ? false : true, PAGE_MAIN, "business_sentence", "", "");
                      break;
                  }
                }
              },
            );
          },
        );
      }
    );
  }

  void _myPage() {
    AnalyticsService().sendAnalyticsEvent(false, authServiceAdapter.userVO.premium == 0 ? false : true, "main", "my", "", "");
    Navigator.pushNamed(context, GetRoutesName.ROUTE_MYPAGE, arguments: 0);
  }

  @override
  Widget build(BuildContext context) {
    resourceProviderModel.getFaq();

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MainColors.yellow_20,
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.center,
                        padding: EdgeInsets.only(top: 25, bottom: 25),
                        child: Image.asset(
                          AppImages.appLogoMint,
                          width: deviceWidth * 0.15,
                        ),
                      ),
                      Container(                    //  My page Button
                        width: deviceWidth * 0.12,
                        alignment: AlignmentDirectional.centerStart,
                        margin: EdgeInsets.only(top: 14, left: 44),
                        child: RaisedButton(
                          padding: EdgeInsets.only(top: 6, bottom: 6, left: 11, right: 11),
                          color: MainColors.green_100,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              side: BorderSide(
                                  color: MainColors.green_100,
                                  width: 2.0
                              )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                AppImages.myMenuIcon,
                                width: (deviceWidth * 0.11) * 0.36,
                                height: (deviceWidth * 0.11) * 0.36,
                              ),
                              SizedBox(width: 2),
                              Text(
                                  Strings.main_btn_my,
                                  style: TextStyle(
                                      fontSize: deviceWidth > 700 ? 16 : 13,
                                      fontFamily: "TmoneyRound",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white
                                  )
                              )
                            ],
                          ),
                          onPressed: () { _myPage(); },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: deviceHeight * 0.6,
                    child: _categoryLargeList(),
                  ),
                  Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      Strings.main_script,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "TmoneyRound",
                          fontWeight: FontWeight.w700,
                          color: MainColors.green_80
                      ),
                    ),
                  )
                ],
              ),
            ),
        ),
      ),
    );
  }
}

