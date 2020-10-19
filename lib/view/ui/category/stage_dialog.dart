
import 'dart:ui';

import 'package:deukki/data/model/stage_vo.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class StageDialog extends StatefulWidget {
  final String title;

  StageDialog({@required this.title});

  @override
  _StageDialogState createState() => _StageDialogState();
}

class _StageDialogState extends State<StageDialog> {
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;

  String _title;

  @override
  void initState() {
    _title = widget.title;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    super.didChangeDependencies();
  }

  Widget _listWidget() {
    return Selector<CategoryProvider, List<StageVO>>(
      selector: (context, categoryProvider) => categoryProvider.stageList,
      builder: (context, stages, child) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 8, bottom: 30, left: 36),
            child: StaggeredGridView.countBuilder(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 1,
              crossAxisSpacing: 10.0,
              scrollDirection: Axis.horizontal,
              itemCount: stages.length,
              itemBuilder: (BuildContext context, index) {
                return _listItemWidget(stages[index]);
              },
              staggeredTileBuilder: (index) => StaggeredTile.fit(2),
            ),
          ),
        );
      }
    );
  }

  Widget _listItemWidget(StageVO stageVO) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 9.2, sigmaY: 9.2),
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
        ),
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 24, bottom: 4),
                  child: Text('$_title', style: Theme.of(context).textTheme.headline4),
                ),
                Text(
                  Strings.stage_script,
                  style: TextStyle(
                    color: MainColors.grey_90,
                    fontSize: 16,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w400
                  ),
                ),
                //  ListView
              ],
            ),
          ),
        )
      ],
    );
  }
}
