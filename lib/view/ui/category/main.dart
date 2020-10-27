import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
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
  AuthServiceAdapter authServiceAdapter;
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;

  @override
  void didChangeDependencies() {
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    categoryProvider = Provider.of<CategoryProvider>(context);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
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
        });
      });
      //RouteNavigator().go(GetRoutesName.ROUTE_RECORD, context);
    }
    print("category large list");
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
                  width: 133,
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
              onTap: () => _onSelectedLarge(index, largeVO.id),    //  ListView Item Click
            );
          },
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MainColors.yellow_20,
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsets.only(top: 25, bottom: 25),
                    child: Image.asset(
                      AppImages.appLogoMint,
                      width: 122,
                    ),
                  ),
                  Container(
                    width: 90,
                    alignment: AlignmentDirectional.centerStart,
                    margin: EdgeInsets.only(top: 14, left: 44),
                    child: RaisedButton(
                      padding: EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 12),
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
                            width: 32,
                            height: 32,
                          ),
                          SizedBox(width: 2),
                          Text(
                              Strings.main_btn_my,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "TmoneyRound",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white
                              )
                          )
                        ],
                      ),
                      onPressed: () {},   //  My Menu Button
                    ),
                  ),
                ],
              ),
              Container(
                height: 223,
                margin: EdgeInsets.only(top: 30),
                child: _categoryLargeList(),
              ),
              Container(
                alignment: AlignmentDirectional.bottomCenter,
                margin: EdgeInsets.only(top: 20),
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
        )
      ),
    );
  }
}

