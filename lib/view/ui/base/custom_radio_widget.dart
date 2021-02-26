
import 'package:deukki/view/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;
  final double topPadding;
  final String title;

  CustomRadioWidget({ this.value, this.groupValue, this.onChanged, this.width = 24, this.height = 24, this.topPadding, this.title });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              onChanged(this.value);
            },
            child: Container(
              width: this.width,
              height: this.height,
              decoration: BoxDecoration(
                border: value == groupValue ? Border.all(color: MainColors.purple_100, width: 6) : Border.all(color: MainColors.grey_border, width: 2),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Center(
                child: Container(
                  width: this.width - 2,
                  height: this.height - 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            this.title,
            style: TextStyle(
              color: MainColors.grey_100,
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w400,
              fontSize: 16
            ),
          )
        ],
      )
    );
  }

}