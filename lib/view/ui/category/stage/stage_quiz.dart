import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:deukki/common/analytics/analytics_service.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/audio_file_path_vo.dart';
import 'package:deukki/data/model/bookmark_vo.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/provider/resource/stage_provider.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/ui/base/ripple_animation.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:volume/volume.dart';
import 'package:hardware_buttons/hardware_buttons.dart';

class StageQuiz extends StatefulWidget {
  @override
  _StageQuizState createState() => _StageQuizState();
}

class _StageQuizState extends State<StageQuiz> with TickerProviderStateMixin {
  static const String PAGE_LEARNING = "Learning";
  CategoryProvider categoryProvider;
  UserProviderModel userProviderModel;
  AuthServiceAdapter authServiceAdapter;
  ResourceProviderModel resourceProviderModel;
  StageProvider stageProvider;

  final random = Random();

  AudioManager _audioManager;
  StreamSubscription _volumeButtonEvent;
  AudioFilePathVO randomPath;

  int maxVol, currentVol;
  var deviceWidth;
  var deviceHeight;
  String resultBgImage, resultText;

  List<BookmarkVO> _bookmarkList = [];
  Future<void> analyticsResult;

  AnimationController _playController, _answerController;
  bool _isPlayAnimation = true;
  bool _isAnswerAnimation = true;

  @override
  void initState() {
    userProviderModel = Provider.of<UserProviderModel>(context, listen: false);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);
    _audioManager = AudioManager.STREAM_MUSIC;

    if(!Platform.isIOS) {
      _volumeButtonEvent = volumeButtonEvents.listen((event) {
        switch(event) {
          case VolumeButtonEvent.VOLUME_UP:
            _setVolume(true);
            break;
          case VolumeButtonEvent.VOLUME_DOWN:
            _setVolume(false);
            break;
        }
      });
    }

    if(!Platform.isIOS) {
      initVolume();
    }

    _playController = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this);

    _answerController = AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    resourceProviderModel = Provider.of<ResourceProviderModel>(context);
    categoryProvider = Provider.of<CategoryProvider>(context);
    stageProvider = Provider.of<StageProvider>(context);

    analyticsResult ??= AnalyticsService().sendAnalyticsEvent(
      "${AnalyticsService.VISIT}$PAGE_LEARNING",
      <String, dynamic> {
        'sentence_id': categoryProvider.selectedSentence.id,
        'stage_number': categoryProvider.selectStageIndex
      },
    );

    if(_isAnswerAnimation && categoryProvider.playCount > 0 && !categoryProvider.isPlaying) {
      _answerController.repeat(reverse: true);
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if(!Platform.isIOS) {
      _volumeButtonEvent?.cancel();
    }
    stageProvider.stopLearnTime();
    _playController?.dispose();
    _answerController?.dispose();
    super.dispose();
  }

  Future<void> initVolume() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
    currentVol = await Volume.getVol;
    maxVol = await Volume.getMaxVol;
  }

  _setVolume(bool isUp) async {
    if(isUp) {
      currentVol++;
      if(currentVol >= maxVol) {
        currentVol = maxVol;
      }
      Volume.setVol(currentVol);
    }else {
      currentVol--;
      if(currentVol <= 0) {
        currentVol = 0;
      }
      Volume.setVol(currentVol);
    }
  }

  Widget _header() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Positioned(left: 0, child: _backButtonWidget()),
        Positioned(
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 40),
            alignment: AlignmentDirectional.center,
            child: Text(
              '${categoryProvider.getSentenceTitle()}',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(right: 0, child: _bookMarkWidget())
      ],
    );
  }

  Widget _backButtonWidget() {            //  Back Button
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: MainColors.green_100, width: 2.0),
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(100.0),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.arrow_back, color: MainColors.green_100, size: 30),
          ),
          onTap: () {
            AnalyticsService().sendAnalyticsEvent("$PAGE_LEARNING Back", <String, dynamic> {'round': stageProvider.round});
            _showExitDialog();
          },
        ),
      ),
    );
  }

  Widget _bookMarkWidget() {          //  Bookmark Button
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
            "$PAGE_LEARNING Bookmark",
            <String,dynamic> {
              'sentence_id': categoryProvider.selectedSentence.id,
              'stage_number': categoryProvider.selectStageIndex,
              'play_pronunciation_id': stageProvider.playPIdx,
              'play_repeat': stageProvider.soundRepeat,
              'round': stageProvider.round
            }
          );

          if(categoryProvider.isBookmark) {
            categoryProvider.onBookMark(false);
            BookmarkVO bookmarkVO = userProviderModel.currentBookmarkList.singleWhere((element) => element.stageIdx == categoryProvider.selectStageIdx, orElse: null);
            userProviderModel.deleteBookmark(authServiceAdapter.authJWT, bookmarkVO.bookmarkIdx);
            userProviderModel.currentBookmarkList.removeWhere((element) => element.stageIdx == categoryProvider.selectStageIdx);
          }else {
            categoryProvider.onBookMark(true);
            userProviderModel.updateBookmark(authServiceAdapter.authJWT, categoryProvider.selectedSentence.id, categoryProvider.selectStageIdx);
          }
        },
      ),
    );
  }

  Widget _bottom(double width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _stepIndicatorWidget(width),
        _playButtonContainer(width * 0.32),
      ],
    );
  }

  Widget _stepIndicatorWidget(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: width + 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(width: ((width + 32) - (36 * 5)) / 5),
              Container(
                alignment: AlignmentDirectional.topStart,
                width: 32,
                child: Icon(Icons.flag, size: 32, color: MainColors.green_100,),
              ),
              SizedBox(width: ((width + 32) - (36 * 5)) / 5),
              Container(
                alignment: AlignmentDirectional.topStart,
                width: 32,
                child: Icon(
                  categoryProvider.stepProgress >= 0.4 ? Icons.flag : Icons.outlined_flag,
                  size: categoryProvider.stepProgress >= 0.4 ? 32 : 24,
                  color: categoryProvider.stepProgress >= 0.4 ? MainColors.green_100 : MainColors.grey_google,
                ),
              ),
              SizedBox(width: ((width + 32) - (36 * 5)) / 5),
              Container(
                alignment: AlignmentDirectional.topStart,
                width: 32,
                child: Icon(
                  categoryProvider.stepProgress >= 0.6 ? Icons.flag : Icons.outlined_flag,
                  size: categoryProvider.stepProgress >= 0.6 ? 32 : 24,
                  color: categoryProvider.stepProgress >= 0.6 ? MainColors.green_100 : MainColors.grey_google,
                ),
              ),
              SizedBox(width: ((width + 32) - (36 * 5)) / 5),
              Container(
                alignment: AlignmentDirectional.topStart,
                width: 32,
                child: Icon(
                  categoryProvider.stepProgress >= 0.8 ? Icons.flag : Icons.outlined_flag,
                  size: categoryProvider.stepProgress >= 0.8 ? 32 : 24,
                  color: categoryProvider.stepProgress >= 0.8 ? MainColors.green_100 : MainColors.grey_google,
                ),
              ),
              SizedBox(width: ((width + 32) - (36 * 5)) / 5),
              Container(
                alignment: AlignmentDirectional.topStart,
                width: 32,
                child: Icon(
                  categoryProvider.stepProgress >= 1.0 ? Icons.flag : Icons.outlined_flag,
                  size: categoryProvider.stepProgress >= 1.0 ? 32 : 24,
                  color: categoryProvider.stepProgress >= 1.0 ? MainColors.green_100 : MainColors.grey_google,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: width,
          child: LinearProgressIndicator(
            value: categoryProvider.stepProgress,
            valueColor: AlwaysStoppedAnimation<Color>(MainColors.purple_80),
            backgroundColor: MainColors.grey_google,
            minHeight: 4.0,
          ),
        ),
      ],
    );
  }

  Widget _playButtonContainer(double width) {              //  Play button
    String playSpeed;
    String soundIcons;    // speed : 0.8, 0.95, 1.1, 1.25, 1.4
    if(stageProvider.playRate >= 0.95 && stageProvider.playRate < 1.1) {
      playSpeed = Strings.play_speed_15;
    }else if(stageProvider.playRate >= 1.1 && stageProvider.playRate < 1.25) {
      playSpeed = Strings.play_speed_20;
    }else if(stageProvider.playRate >= 1.25 && stageProvider.playRate < 1.4){
      playSpeed = Strings.play_speed_25;
    }else if(stageProvider.playRate >= 1.4) {
      playSpeed = Strings.play_speed_30;
    }else {
      playSpeed = "";
    }

    if(!categoryProvider.isPlaying) {
      if(stageProvider.playRate > 1.0) {
        soundIcons = AppImages.playFast;
      }else {
        soundIcons = AppImages.playNormal;
      }
    }else {
      soundIcons = AppImages.speaker;
    }

    return Container(
      width: width + 2,
      margin: EdgeInsets.only(top: 32),
      child: _playButtonAnimation(width, soundIcons, playSpeed),
    );
  }

  Widget _playButtonAnimation(double width, String soundIcons, String playSpeed) {
    if(userProviderModel.learnGuide == 0) {
      return RippleAnimation(
        controller: _playController,
        color: MainColors.purple_80,
        rippleTarget: _playButtonWidget(width, soundIcons, playSpeed),
        radius: 40.0,
      );
    }else {
      return _playButtonWidget(width, soundIcons, playSpeed);
    }
  }

  Widget _playButtonWidget(double width, String soundIcons, String playSpeed) {
    return RaisedButton(
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
      color: !categoryProvider.isPlaying ? MainColors.purple_80 : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          side: BorderSide(
              color: MainColors.purple_80,
              width: 2.0
          )
      ),
      child: _dataLoadingWidget(soundIcons, playSpeed),
      onPressed: () {               //  Play Button Click
        _playController.reset();
        _isPlayAnimation = false;
        AnalyticsService().sendAnalyticsEvent("$PAGE_LEARNING Play", <String, dynamic> {'play_pronunciation_id': stageProvider.playPIdx});

        if(!categoryProvider.isPlaying) {
          categoryProvider.play(randomPath.path, stageProvider.playRate);
          categoryProvider.setPlaying(true);
          stageProvider.setSoundRepeat();
        }
      },
    );
  }

  Widget _dataLoadingWidget(String soundIcons, String playSpeed) {
    final saveAudioFile = resourceProviderModel.value.saveAudioFile;
    if(saveAudioFile.hasData) {
      if(_isPlayAnimation) {
        _playController.repeat(reverse: true);
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            !categoryProvider.isPlaying ? Strings.play_btn : "",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "TmoneyRound",
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 2),
          Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(soundIcons, height: 24),
                ],
              )
          ),
          Container(
            child: Text(
              playSpeed,
              style: TextStyle(
                  fontSize: !categoryProvider.isPlaying ? 12 : 0,
                  fontFamily: "NotoSansKR",
                  fontWeight: FontWeight.w400,
                  color: Colors.white
              ),
            ),
          ),
        ],
      );
    }else {
      return Container(
        width: 24,
        height: 24,
        child: CupertinoActivityIndicator(radius: 14),
      );
    }
  }

  Widget _listWidget(double width) {            //  ListView
    int crossAxisCount;
    double mainAxisCellCount;
    PronunciationVO rightPronunciation = categoryProvider.getRightPronun();
    if(categoryProvider.pronunciationList.length > 2) {
      if(categoryProvider.pronunciationList.length % 2 == 0) {
        crossAxisCount = 2;
        mainAxisCellCount = (width - 16) * 0.44;
      }else {
        crossAxisCount = 1;
        mainAxisCellCount = (width - 32) * 0.28;
      }
    }else {
      crossAxisCount = 1;
      mainAxisCellCount = (width - 16) * 0.44;
    }
    return Selector<CategoryProvider, List<PronunciationVO>>(
      selector: (context, categoryProvider) => categoryProvider.pronunciationList,
      builder: (context, pronunciations, child) {
        return Expanded(
          child: StaggeredGridView.countBuilder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 0),
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            scrollDirection: Axis.horizontal,
            itemCount: pronunciations.length,
            itemBuilder: (BuildContext context, index) {
              return _listItemWidget(pronunciations[index], rightPronunciation.pronunciation, index);
            },
            staggeredTileBuilder: (index) => StaggeredTile.extent(crossAxisCount, mainAxisCellCount),
          ),
        );
      },
    );
  }

  Widget _listItemWidget(PronunciationVO pronunciationVO, String rightPronunciation, int index) {
    Color cardColor, textColor;
    if(categoryProvider.isPlaying) {
      if(stageProvider.selectAnswerIndex.contains(index)) {
        cardColor = Colors.white;
        textColor = Colors.white;
      }else {
        cardColor = MainColors.yellow_opacity50;
        textColor = MainColors.grey_70;
      }
    }else {
      if(categoryProvider.playCount > 0) {
        if(stageProvider.selectAnswerIndex.contains(index)) {
          cardColor = Colors.white;
          textColor = Colors.white;
        }else {
          cardColor = MainColors.yellow_40;
          textColor = MainColors.grey_100;
        }
      }else {
        cardColor = MainColors.yellow_opacity50;
        textColor = MainColors.grey_70;
      }
    }
    return GestureDetector(
      child: _listItemAnimation(pronunciationVO, rightPronunciation, index, cardColor, textColor),
      onTap: () {                   // List Item Click (Quiz answer click)
        _answerController.reset();
        _isAnswerAnimation = false;
        if(!categoryProvider.isPlaying
            && categoryProvider.playCount > 0
            && (stageProvider.selectAnswerIndex.singleWhere((it) => it == index, orElse: () => null)) == null) {
          stageProvider.onSelectedAnswer(index, pronunciationVO.pronunciation);
          if(pronunciationVO.pIdx == randomPath.stageIdx) {
            AnalyticsService().sendAnalyticsEvent(
              "$PAGE_LEARNING Right",
              <String, dynamic> {
                'pronunciation_id': pronunciationVO.pIdx,
                'play_pronunciation_id': randomPath.stageIdx
              }
            );
            stageProvider.historyInit(randomPath.stageIdx);
          }else {
            AnalyticsService().sendAnalyticsEvent(
              "$PAGE_LEARNING Wrong",
              <String, dynamic> {
                'pronunciation_id': pronunciationVO.pIdx,
                'play_pronunciation_id': randomPath.stageIdx
              }
            );
            stageProvider.setSelectPIdx(pronunciationVO.pIdx);
            stageProvider.setCorrect(false);
            stageProvider.setOneTimeAnswerCount();
            resultBgImage = AppImages.incorrectAnimation;
            resultText = Strings.quiz_answer_incorrect;
          }
          _answerResultDialog(pronunciationVO.pIdx);
          stageProvider.setRound();
          categoryProvider.setStepProgress();
        }
      },
    );
  }

  Widget _listItemAnimation(PronunciationVO pronunciationVO, String rightPronunciation, int index, Color cardColor, Color textColor) {
    if(userProviderModel.learnGuide == 0) {
      return RippleAnimation(
        controller: _answerController,
        color: MainColors.yellow_60,
        rippleTarget: _itemWidget(pronunciationVO, rightPronunciation, index, cardColor, textColor),
        radius: 24.0,
      );
    }else {
      return _itemWidget(pronunciationVO, rightPronunciation, index, cardColor, textColor);
    }
  }

  Widget _itemWidget(PronunciationVO pronunciationVO, String rightPronunciation, int index, Color cardColor, Color textColor) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: _answerWidget(index, pronunciationVO.pronunciation, textColor, pronunciationVO.wrongIndex),
          ),
          Positioned(
              left: 0,
              top: 0,
              child: (stageProvider.selectAnswerIndex.singleWhere((it) => it == index, orElse: () => null)) != null
                  ? Container(color: Colors.white,)
                  : _rightPronunciationTagWidget(pronunciationVO.pronunciation, rightPronunciation)
          ),
        ],
      ),
    );
  }

  Widget _answerWidget(int index, String pronunciation, Color textColor, int wrongIndex) {
    if((stageProvider.selectAnswerIndex.singleWhere((it) => it == index, orElse: () => null)) != null) {
      return DottedBorder(
        color: MainColors.yellow_100,
        dashPattern: [2, 8],
        strokeWidth: 3,
        borderType: BorderType.RRect,
        radius: Radius.circular(16),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: AlignmentDirectional.center,
          child: Text(
            pronunciation,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: "TmoneyRound",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        alignment: AlignmentDirectional.center,
        child: _pronunciationWidget(pronunciation, wrongIndex, textColor),
      );
    }
  }

  /// 틀린 글자 위치 표시
  ///   - 첫번째 글자가 틀렸을때,
  ///   - 중간 글자가 툴렸을때,
  ///   - 마지막 글자가 틀렸을때,
  Widget _pronunciationWidget(String pronunciation, int wrongIndex, Color textColor) {
    if(wrongIndex != null) {
      if(wrongIndex <= 0) {
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 22,
              fontFamily: "TmoneyRound",
              fontWeight: FontWeight.w700
            ),
            children: <TextSpan>[
              TextSpan(
                text: pronunciation.substring(0, 1),
                style: TextStyle(color: categoryProvider.isPlaying || categoryProvider.playCount <= 0 ? Colors.red.shade200 : Colors.red),
              ),
              TextSpan(
                text: pronunciation.substring(1),
                style: TextStyle(color: textColor),
              )
            ]
          ),
        );
      }else {
        if(wrongIndex < (pronunciation.length - 1)) {
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 22,
                fontFamily: "TmoneyRound",
                fontWeight: FontWeight.w700,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: pronunciation.substring(0, wrongIndex),
                  style: TextStyle(color: textColor),
                ),
                TextSpan(
                  text: pronunciation.substring(wrongIndex, wrongIndex + 1),
                  style: TextStyle(color: categoryProvider.isPlaying || categoryProvider.playCount <= 0 ? Colors.red.shade200 : Colors.red),
                ),
                TextSpan(
                  text: pronunciation.substring(wrongIndex + 1),
                  style: TextStyle(color: textColor),
                )
              ]
            ),
          );
        }else {
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 22,
                fontFamily: "TmoneyRound",
                fontWeight: FontWeight.w700,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: pronunciation.substring(0, wrongIndex),
                  style: TextStyle(color: textColor),
                ),
                TextSpan(
                  text: pronunciation.substring(wrongIndex),
                  style: TextStyle(color: categoryProvider.isPlaying || categoryProvider.playCount <= 0 ? Colors.red.shade200 : Colors.red)
                )
              ]
            ),
          );
        }
      }
    }else {
      return Text(
        pronunciation,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontFamily: "TmoneyRound",
          fontWeight: FontWeight.w700
        ),
      );
    }
  }

  Widget _rightPronunciationTagWidget(String pronunciation, String rightPronunciation) {
    if(rightPronunciation == pronunciation) {
      return Container(
        margin: EdgeInsets.only(top: 6, left: 6),
        padding: EdgeInsets.only(top: 3, bottom: 3, left: 6, right: 6),
        decoration: BoxDecoration(
            color: !categoryProvider.isPlaying && categoryProvider.playCount > 0 ? Colors.white : MainColors.blue_100,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Center(
          child: Text(
            Strings.right_pronunciation,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontFamily: "NotoSansKR",
                fontWeight: FontWeight.w400,
                color: !categoryProvider.isPlaying && categoryProvider.playCount > 0 ? MainColors.blue_opacity50 : Colors.white
            ),
          ),
        ),
      );
    }else {
      return Container();
    }
  }

  void _answerResultDialog(int pIdx) {
    if(stageProvider.oneTimeAnswerCount <= 0) {
      resultBgImage = AppImages.correctAnimation;
      resultText = Strings.quiz_answer_correct;
      stageProvider.setSelectPIdx(pIdx);
      stageProvider.setCorrect(true);
      stageProvider.setCountCorrectAnswer();
      stageProvider.addHistory();
      _showResultDialog(resultBgImage, resultText);
      stageProvider.setLevel();
      stageProvider.setPlayRate();
      stageProvider.historyInit(randomPath.stageIdx);
      stageProvider.initSelectAnswer();
    }else {
      stageProvider.addHistory();
      _showResultDialog(resultBgImage, resultText);
      stageProvider.historyInit(randomPath.stageIdx);
      stageProvider.initSelectAnswer();
    }
    randomPath = resourceProviderModel.audioFilePath[random.nextInt(resourceProviderModel.audioFilePath.length)];
  }

  void _showResultDialog(String bgImages, String answerResult) {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 700), () {
            Navigator.pop(context);
            stageProvider.onSelectedAnswer(-1, "");
          });
          return Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 9.2, sigmaY: 9.2),
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: deviceWidth * 0.35,
                    child: Lottie.asset(
                      bgImages,
                      repeat: false,
                      width: (deviceWidth * 0.35) * 0.85,
                      height: (deviceWidth * 0.35) * 0.85,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Text(
                      answerResult,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ],
              ),
            ],
          );
        });

    if(stageProvider.round >= 5) {
      Future.delayed(Duration(milliseconds: 700), () {
        stageProvider.stopLearnTime();
        userProviderModel.recordLearning(
            authServiceAdapter.authJWT,
            categoryProvider.selectedSentence.id,
            stageProvider.generateLearningRecord(categoryProvider.selectStageIdx)
        ).then((value) {
          RouteNavigator().go(GetRoutesName.ROUTE_STAGE_COMPLETE, context);
        });
      });
    }
    categoryProvider.playCount = 0;
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
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
                width: deviceWidth * 0.6,
                height: deviceHeight * 0.51,
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 32, bottom: 30, left: 60, right: 60),
                          child: Text(
                            Strings.quiz_exit_script,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: (deviceWidth * 0.6) * 0.38,
                              child: CommonRaisedButton(
                                textColor: MainColors.purple_100,
                                buttonColor: Colors.white,
                                borderColor: MainColors.purple_100,
                                buttonText: Strings.common_btn_exit,
                                fontSize: 16,
                                voidCallback: _exit,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: (deviceWidth * 0.6) * 0.38,
                              child: CommonRaisedButton(
                                textColor: Colors.white,
                                buttonColor: MainColors.purple_100,
                                borderColor: MainColors.purple_100,
                                buttonText: Strings.common_btn_stay,
                                fontSize: 16,
                                voidCallback: _dismissDialog,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  void _dismissDialog() {
    Navigator.of(context).pop();
  }

  void _exit() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    final bookmarkList = userProviderModel.value.getBookmark;

    stageProvider.startLearnTime();

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    var ratioWidth = deviceWidth * 0.6;

    if(randomPath == null) {
      if(resourceProviderModel.audioFilePath.length > 0 && categoryProvider.pronunciationList.length > 0) {
        randomPath = resourceProviderModel.audioFilePath[random.nextInt(resourceProviderModel.audioFilePath.length)];
        stageProvider.setPlayPIdx(randomPath.stageIdx);
      }
    }

    if(bookmarkList.hasData) {
      _bookmarkList = bookmarkList.result.asValue.value;
    }

    return WillPopScope(
      onWillPop: () async {
        //  왼쪽 -> 오른쪽 Swipe 시에 뒤로가기 방지
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          left: false,
          right: false,
          child: Center(
            child: Container(
              width: deviceWidth,
              height: deviceHeight,
              margin: EdgeInsets.only(top: 14, bottom: 10, left: deviceWidth * 0.05, right: deviceWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _header(),
                  _listWidget(deviceWidth),
                  _bottom(ratioWidth)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
