import 'package:deukki/data/model/production_vo.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberShip extends StatefulWidget {
  @override
  _MemberShipState createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  UserProviderModel _userProviderModel;

  double deviceWidth, deviceHeight;

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
      child: ListView.builder(
        shrinkWrap: true,
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
          child: Column(
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

            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: deviceWidth > 700 ? 14 : 60, top: 16),
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
                        _userProviderModel.userVOForHttp.premium == 0 ? Strings.mypage_membership_status_noMember : Strings.mypage_membership_status_yesMember,
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
                margin: EdgeInsets.only(left: deviceWidth > 700 ? 14 : 60, top: 8),
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
              //  ListView,

            ],
          ),
        ),
      ),
    );
  }
}
