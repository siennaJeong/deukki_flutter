import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:deukki/common/utils/route_util.dart';
import 'package:deukki/data/model/audio_file_path_vo.dart';
import 'package:deukki/data/model/pronunciation_vo.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/provider/resource/stage_provider.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hardware_buttons/hardware_buttons.dart';
import 'package:provider/provider.dart';
import 'package:volume/volume.dart';

class StageQuiz extends StatefulWidget {
  @override
  _StageQuizState createState() => _StageQuizState();
}

class _StageQuizState extends State<StageQuiz> with SingleTickerProviderStateMixin {
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;
  StageProvider stageProvider;
  AnimationController _controller;
  Animation _animation, _delayAnimation;

  final random = Random();
  AudioPlayer _audioPlayer;
  AudioManager _audioManager;
  StreamSubscription _volumeButtionEvent;
  AudioFilePathVO randomPath;
  int maxVol, currentVol;
  var deviceWidth;
  var deviceHeight;


  @override
  void initState() {
    _controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _audioPlayer = AudioPlayer();
    _audioManager = AudioManager.STREAM_MUSIC;
    _volumeButtionEvent = volumeButtonEvents.listen((event) {
      switch(event) {
        case VolumeButtonEvent.VOLUME_UP:
          _setVolume(true);
          break;
        case VolumeButtonEvent.VOLUME_DOWN:
          _setVolume(false);
          break;
      }
    });
    initVolume();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    stageProvider = Provider.of<StageProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _volumeButtionEvent?.cancel();
    super.dispose();
    stageProvider.dispose();
  }

  _setRandomPath() {
    randomPath = resourceProviderModel.audioFilePath[random.nextInt(resourceProviderModel.audioFilePath.length)];
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

  _playLocal(String filePath, double speed) async {
    await _audioPlayer.play(filePath, isLocal: true);
    _audioPlayer.setVolume((currentVol / maxVol) * 10);
    _audioPlayer.setPlaybackRate(playbackRate: speed);
    _playStateListener();
  }

  _playStateListener() async {
    _audioPlayer.onPlayerCompletion.listen((event) {
      stageProvider.setPlaying(false);
      stageProvider.setPlayCount();
    });
  }

  Widget _header() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Positioned(left: 0, child: _backButtonWidget()),
        Positioned(
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 52),
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
      margin: EdgeInsets.only(bottom: 32),
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
          onTap: () => { Navigator.of(context).pop() },
        ),
      ),
    );
  }

  Widget _bookMarkWidget() {          //  Bookmark Button
    print("bookmark widget");
    return Container(
      margin: EdgeInsets.only(bottom: 32),
      child: InkWell(
        child: Image.asset(
          categoryProvider.isBookmark ? AppImages.bookmarkActive : AppImages.bookmarkNormal,
          width: 50,
          height: 50,
        ),
        onTap: () => {
          categoryProvider.isBookmark ? categoryProvider.onBookMark(false) : categoryProvider.onBookMark(true)
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
        _playButtonWidget(width * 0.32),
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

  Widget _playButtonWidget(double width) {              //  Play button
    String playSpeed;
    String soundIcons;
    if(stageProvider.playRate == 1.25 ) {
      playSpeed = Strings.play_speed_15;
    }else if(stageProvider.playRate == 1.5) {
      playSpeed = Strings.play_speed_20;
    }else if(stageProvider.playRate == 1.75){
      playSpeed = Strings.play_speed_25;
    }else if(stageProvider.playRate == 2.0) {
      playSpeed = Strings.play_speed_30;
    }else {
      playSpeed = "";
    }

    if(!stageProvider.isPlaying) {
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
      child: RaisedButton(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
        color: !stageProvider.isPlaying ? MainColors.purple_80 : Colors.white,
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
          if(!stageProvider.isPlaying) {
            _playLocal(randomPath.path, stageProvider.playRate);
            stageProvider.setPlaying(true);
            stageProvider.setFirstHeight(14);
            stageProvider.setSecondHeight(18);
          }
        },
      ),
    );
  }

  Widget _dataLoadingWidget(String soundIcons, String playSpeed) {
    if(resourceProviderModel.audioFilePath.length > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            !stageProvider.isPlaying ? Strings.play_btn : "",
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
                  Image.asset(soundIcons, width: 24, height: 24),
                ],
              )
          ),
          Container(
            child: Text(
              playSpeed,
              style: TextStyle(
                  fontSize: !stageProvider.isPlaying ? 12 : 0,
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
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white), strokeWidth: 1.0,),
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
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
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
    if(stageProvider.isPlaying) {
      cardColor = MainColors.yellow_opacity50;
      textColor = MainColors.grey_70;
    }else {
      if(stageProvider.playCount > 0) {
        if(stageProvider.selectedAnswerIndex == index) {
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
    print("list item widget");
    return GestureDetector(
      child: Card(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: _answerWidget(index, pronunciationVO.pronunciation, rightPronunciation, textColor),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: stageProvider.selectedAnswerIndex == index
                  ? Container(color: Colors.white,)
                  : _rightPronunciationTagWidget(pronunciationVO.pronunciation, rightPronunciation)
            ),
          ],
        ),
      ),
      onTap: () => {                   // List Item Click (Quiz answer click)
        if(!stageProvider.isPlaying && stageProvider.playCount > 0) {
          stageProvider.onSelectedAnswer(index, pronunciationVO.pronunciation),
          stageProvider.setAnswerCount(),
          _answerResultDialog(pronunciationVO.pIdx),
        }
      },
    );
  }

  Widget _answerWidget(int index, String pronunciation, String rightPronunciation, Color textColor) {
    if(stageProvider.selectedAnswerIndex == index) {
      print("answer widget index dot : " + stageProvider.selectedAnswerIndex.toString());
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
      print("answer widget index : " + stageProvider.selectedAnswerIndex.toString());
      return Container(
        width: double.infinity,
        height: double.infinity,
        alignment: AlignmentDirectional.center,
        child: Text(
          pronunciation,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontFamily: "TmoneyRound",
            fontWeight: FontWeight.w700,
          ),
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
            color: !stageProvider.isPlaying && stageProvider.playCount > 0 ? Colors.white : MainColors.blue_100,
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
                color: !stageProvider.isPlaying && stageProvider.playCount > 0 ? MainColors.blue_opacity50 : Colors.white
            ),
          ),
        ),
      );
    }else {
      return Container();
    }
  }

  void _answerResultDialog(int pIdx) {
    String bgImages, answerResult;
    if(stageProvider.answerCount < 5) {
      if(pIdx == randomPath.stageIdx) {
        bgImages = AppImages.blueBgImage;
        answerResult = Strings.quiz_result_great;
        stageProvider.setPlayRate();
      }else {
        bgImages = AppImages.greenBgImage;
        answerResult = Strings.quiz_result_good;
      }
      //  정답지 레이아웃 다시. path 랜덤 시키기.
      categoryProvider.setStepProgress();
      randomPath = resourceProviderModel.audioFilePath[random.nextInt(resourceProviderModel.audioFilePath.length)];
      print("random : " + randomPath.stageIdx.toString());

      showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 1), () {
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
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Positioned(
                        child: Container(
                          width: deviceWidth * 0.35,
                          child: Image.asset(bgImages),
                        )
                    ),
                    Positioned(
                      child: Container(
                        child: Text(
                          answerResult,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          });
    }else {
      //  Stage 완료 했을때. -> play speed 가 2 이상일때는 별 3개 1.25 ~ 1.5 일때 별 2개 1일때 별 1개. 별 2개부터 great!
      if(stageProvider.playRate <= 1.0) {
        categoryProvider.setStageScore(1);
      }else if(stageProvider.playRate > 1.0 && stageProvider.playRate <= 1.5) {
        categoryProvider.setStageScore(2);
      }else {
        categoryProvider.setStageScore(3);
      }
      categoryProvider.updateScore(categoryProvider.stageScore);
      RouteNavigator().go(GetRoutesName.ROUTE_STAGE_COMPLETE, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    var ratioWidth;
    ratioWidth = deviceWidth * 0.64;

    if(randomPath == null) {
      if(resourceProviderModel.audioFilePath.length > 0 && categoryProvider.pronunciationList.length > 0) {
        _setRandomPath();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          margin: EdgeInsets.only(top: 14, bottom: 32, left: deviceWidth * 0.05, right: deviceWidth * 0.05),
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
    );
  }

}
