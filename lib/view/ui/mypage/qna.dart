import 'package:deukki/data/model/faq_vo.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QnA extends StatefulWidget {
  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnA> {
  ResourceProviderModel resourceProviderModel;
  List<FaqVO> faqs = [];
  List<ExpandableFaq> expandableFaqs = [];

  @override
  void didChangeDependencies() {
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    faqs = resourceProviderModel.faqs;

    faqs.forEach((element) {
      ExpandableFaq expandableFaq = ExpandableFaq(question: element.question);
      expandableFaq.addAnswer(element.answer);
      expandableFaqs.add(expandableFaq);
    });

    super.didChangeDependencies();
  }

  Widget _listTitleWidget(String title) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Text(
              title,
              style: TextStyle(
                color: MainColors.grey_100,
                fontSize: 16,
                fontFamily: "NotoSansKR",
                fontWeight: FontWeight.w700
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 60, right: 60),
              child: Text(
                Strings.mypage_help_script,
                style: TextStyle(
                    color: MainColors.grey_100,
                    fontSize: 16,
                    fontFamily: "NotoSansKR",
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              margin: EdgeInsets.only(left: 60, right: 60),
              child: Text(
                Strings.mypage_help_title,
                style: TextStyle(
                    color: MainColors.grey_100,
                    fontSize: 24,
                    fontFamily: "TmoneyRound",
                    fontWeight: FontWeight.w700
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                margin: EdgeInsets.only(left: 60, right: 60),
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.only(left: 0),
                  itemCount: expandableFaqs.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: _listTitleWidget(expandableFaqs[index].question),
                      children: <Widget>[
                        Column(
                          children: _buildExpandableContent(expandableFaqs[index]),
                        )
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildExpandableContent(ExpandableFaq expandableFaq) {
    List<Widget> columnContent = [];
      for(String str in expandableFaq.answers) {
        columnContent.add(
          ListTile(
            title: Container(
              padding: EdgeInsets.all(16),
              color: MainColors.grey_30,
              child: Text(
                str,
                style: TextStyle(
                  color: MainColors.grey_answer,
                  fontSize: 16,
                  fontFamily: "NotoSansKR",
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
          )
        );
      }
    return columnContent;
  }
}
