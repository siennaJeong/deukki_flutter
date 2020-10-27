
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          Strings.mypage_report_wait_update,
          style: TextStyle(
            fontSize: 16,
            fontFamily: "TmoneyRound",
            fontWeight: FontWeight.w700,
            color: MainColors.grey_100
          ),
        ),
      ),
    );
  }
}
