import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MemberShip extends StatefulWidget {
  @override
  _MemberShipState createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  UserProviderModel _userProviderModel;

  double deviceWidth, deviceHeight;
  int premium;

  @override
  void didChangeDependencies() {
    _userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _listWidget() {
    return Container(
      alignment: AlignmentDirectional.center,
      height: deviceHeight * 0.6,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemCount: _userProviderModel.productList.length,
        itemBuilder: (BuildContext context, i) {
          return _listItemWidget(i, _userProviderModel.productList[i]);
        },
      ),
    );
  }

  Widget _listItemWidget(int i, ProductionVO productionVO) {
    return GestureDetector(
      child: Card(
        color: i == 0 ? MainColors.green_100 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: i == 0 ? MainColors.green_100 : MainColors.grey_50,
            width: 2,
          ),
        ),
        elevation: 0,
        child: Container(
          width: (deviceWidth * 0.87) / _userProviderModel.productList.length,
          height: deviceHeight * 0.6,
          padding: EdgeInsets.only(left: 16, right: 24, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                productionVO.title,
                style: TextStyle(
                  color: i == 0 ? Colors.white : MainColors.grey_100,
                  fontSize: 20,
                  fontFamily: "TmoneyRound",
                  fontWeight: FontWeight.w700
                ),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16, fontFamily: "NotoSansKR"),
                        children: <TextSpan>[
                          TextSpan(
                              text: "${_numberWithComma(productionVO.price)}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: i == 0 ? MainColors.green_30 : MainColors.grey_price,
                                  color: i == 0 ? MainColors.green_30 : MainColors.grey_price,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                          TextSpan(
                              text: "   ${productionVO.discountRate}${Strings.mypage_membership_discount_rate}",
                              style: TextStyle(
                                  color: i == 0 ? Colors.white : MainColors.grey_100,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontFamily: "NotoSansKR",
                              fontWeight: FontWeight.w900,
                              color: i == 0 ? Colors.white : MainColors.green_100
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "${_numberWithComma(productionVO.discountPrice)} ",
                                style: TextStyle(fontSize: 32)
                            ),
                            TextSpan(
                                text: i == 0 ? Strings.mypage_membership_won : Strings.mypage_membership_annual_won,
                                style: TextStyle(fontSize: 20)
                            )
                          ]
                      ),
                    ),

                    Text(
                      i == 0 ? "" : "(${Strings.mypage_membership_monthly_price} ${_numberWithComma(productionVO.monthlyPrice)}${Strings.mypage_membership_annual_won})",
                      style: TextStyle(
                        color: MainColors.grey_answer,
                        fontSize: 16,
                        fontFamily: "NotoSansKR",
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ],
                )
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      Strings.mypage_membership_join,
                      style: TextStyle(
                          color: i == 0 ? Colors.white : MainColors.grey_100,
                          fontSize: 16,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios, size: 17, color: i == 0 ? Colors.white : MainColors.grey_100,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        //  멤버십 구매

      },
    );
  }

  String _numberWithComma(int num) {
    return NumberFormat('###,###,###,###').format(num).replaceAll(' ', '');
  }


  @override
  Widget build(BuildContext context) {

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    if(_userProviderModel.userVOForHttp != null) {
      premium = _userProviderModel.userVOForHttp.premium;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 60, top: 16),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      "${Strings.mypage_membership_status}",
                      style: TextStyle(
                          color: MainColors.grey_100,
                          fontSize: 24,
                          fontFamily: "TmoneyRound",
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Container(
                    child: Text(
                      premium == 0 ? Strings.mypage_membership_status_noMember : Strings.mypage_membership_status_yesMember,
                      style: TextStyle(
                          color: MainColors.grey_100,
                          fontSize: 24,
                          fontFamily: "TmoneyRound",
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 60, top: 8),
              child: Text(
                Strings.mypage_membership_title,
                style: TextStyle(
                    color: MainColors.grey_100,
                    fontSize: 16,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            SizedBox(height: 22),
            //  ListView,
            SizedBox(child: _listWidget()),
            SizedBox(height: 24),
            Container(
              margin: EdgeInsets.only(left: 60, right: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${Strings.mypage_membership_terms_script_1}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.mypage_membership_terms_script_2}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.mypage_membership_terms_script_3}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.mypage_membership_terms_script_4}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.mypage_membership_terms_script_5}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${Strings.mypage_membership_terms_script_6}",
                    style: TextStyle(color: MainColors.grey_80, fontSize: 16, fontFamily: "NotoSansKR", fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
