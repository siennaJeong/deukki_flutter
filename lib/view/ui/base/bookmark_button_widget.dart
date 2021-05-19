
import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookmarkButtonWidget extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final UserProviderModel userProviderModel;
  final String playPronId, playRepeat, round, authJWT, analyticsName;

  BookmarkButtonWidget({@required this.categoryProvider, @required this.userProviderModel,
      @required this.playPronId, @required this.playRepeat, @required this.round, @required this.authJWT, @required this.analyticsName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: InkWell(
        child: Image.asset(
          categoryProvider.isBookmark ? AppImages.bookmarkActive : AppImages.bookmarkNormal,
          width: 50,
          height: 50,
        ),
        onTap: () {
          AnalyticsService().sendAnalyticsEvent(
              analyticsName,
              <String,dynamic> {
                'sentence_id': categoryProvider.selectedSentence.id,
                'stage_number': categoryProvider.selectStageIndex,
                'play_pronunciation_id': playPronId,
                'play_repeat': playRepeat,
                'round': round
              }
          );

          if(categoryProvider.isBookmark) {
            categoryProvider.onBookMark(false);
            BookmarkVO bookmarkVO = userProviderModel.currentBookmarkList.singleWhere((element) => element.stageIdx == categoryProvider.selectStageIdx, orElse: null);
            userProviderModel.deleteBookmark(authJWT, bookmarkVO.bookmarkIdx);
            userProviderModel.currentBookmarkList.removeWhere((element) => element.stageIdx == categoryProvider.selectStageIdx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.bookmark_cancel), duration: Duration(milliseconds: 700),));
          }else {
            categoryProvider.onBookMark(true);
            userProviderModel.updateBookmark(authJWT, categoryProvider.selectedSentence.id, categoryProvider.selectStageIdx);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(Strings.bookmark_done), duration: Duration(milliseconds: 700),));
          }
        },
      ),
    );
  }
}
