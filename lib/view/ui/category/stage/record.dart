import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:deukki/data/service/signin/auth_service_adapter.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/record_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/view/ui/base/base_widget.dart';
import 'package:deukki/view/ui/base/common_button_widget.dart';
import 'package:deukki/view/values/app_images.dart';
import 'package:deukki/view/values/colors.dart';
import 'package:deukki/view/values/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Record extends BaseWidget {
  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  AuthServiceAdapter authServiceAdapter;
  ResourceProviderModel resourceProviderModel;
  CategoryProvider categoryProvider;
  RecordProvider recordProvider;

  FlutterAudioRecorder _recorder;
  Recording _recording;
  RecordingStatus _recordingStatus = RecordingStatus.Unset;
  double _avgPower = 0.0;
  String tempPath, dirPath;
  Directory directory;
  File file;

  var deviceWidth, deviceHeight;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  @override
  void didChangeDependencies() {
    recordProvider = Provider.of<RecordProvider>(context);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    authServiceAdapter = Provider.of<AuthServiceAdapter>(context, listen: false);

    super.didChangeDependencies();
  }

  void _initRecorder() async {
    try{
      //String pIdx = "_${categoryProvider.getRightPronun().pIdx}";
      tempPath = "/record_${DateTime.now().millisecond}.aac";
      directory = await getTemporaryDirectory();
      dirPath = directory.path;

      if(await FlutterAudioRecorder.hasPermissions) {
        print("temporary directory : " + dirPath + tempPath);
        _recorder = FlutterAudioRecorder(dirPath + tempPath);
        await _recorder.initialized;

        var current = await _recorder.current(channel: 0);
        setState(() {
          _recording = current;
          _recordingStatus = current.status;
          _avgPower = (_recording.metering.averagePower + 120.0) / 360;
        });
      }else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(Strings.permission_script)));
      }
    }catch(e) {
      print(e);
    }
  }

  void _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _recording = recording;
      });

      recordProvider.setIsRecord(true);

      const tick = const Duration(milliseconds: 5);
      new Timer.periodic(tick, (Timer t) async {
        if(_recordingStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        setState(() {
          _recording = current;
          _recordingStatus = _recording.status;
          if(_recording.metering.averagePower < -29) {
            _avgPower = ((_recording.metering.averagePower + 120.0) / 240) / 10;
          }else {
            _avgPower = ((_recording.metering.averagePower + 120.0) / 240);
          }
        });
      });
    }catch(e) {
      print(e);
    }
  }

  void _stop() async {
    recordProvider.setIsRecord(false);
    var stop = await _recorder.stop();

    setState(() {
      _avgPower = 0.0;
      _recording = stop;
      _recordingStatus = _recording.status;
      print("record duration : " + _recording.duration.toString());
    });
  }

  void _recordButtonCallback() {                //  Record Button Click
    switch(_recordingStatus) {
      case RecordingStatus.Initialized:
        _start();
        break;
      case RecordingStatus.Recording:
        _stop();

        if(_recording.duration >= Duration(milliseconds: 20000)) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(Strings.record_over_time)));
        }else {
          recordProvider.setRoundCount();
          showDialog(             //  Record 끝난 후 Dialog
              context: context,
              builder: (BuildContext context) {
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
                        SizedBox(height: 10),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Positioned(
                              child: Container(
                                width: deviceWidth * 0.35,
                                child: Image.asset(AppImages.yellowBgImage),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                child: Text(
                                  Strings.thank_you,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: "TmoneyRound",
                                    fontWeight: FontWeight.w700,
                                    color: MainColors.blue_100,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: deviceWidth * 0.2,
                              child: CommonRaisedButton(            //  다시 발음하기 Button
                                borderColor: MainColors.purple_100,
                                buttonColor: Colors.white,
                                textColor: MainColors.purple_100,
                                buttonText: Strings.record_again,
                                fontSize: 16,
                                voidCallback: _recordAgain,
                              ),
                            ),
                            SizedBox(width: 16),
                            Container(
                              width: deviceWidth * 0.2,
                              child: CommonRaisedButton(            //  확인 Button
                                borderColor: MainColors.purple_100,
                                buttonColor: MainColors.purple_100,
                                textColor: Colors.white,
                                buttonText: Strings.common_btn_ok,
                                fontSize: 16,
                                voidCallback: _recordDone,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                );
              }
          );
        }
        break;
    }
  }

  Future<void> _recordUpload(int roundCount) async {
    file = File(dirPath + tempPath);
    resourceProviderModel.recordUpload(
        authServiceAdapter.authJWT,
        file,
        categoryProvider.selectStageIndex + 1,    //  stage
        roundCount,                               //  round
        categoryProvider.getSentenceTitle()       //  sentenceId
    );
  }

  void _recordAgain() {
    _recordUpload(recordProvider.roundCount);
    _initRecorder();
    Navigator.pop(context);
  }

  void _recordDone() {
    Navigator.pop(context);
    _recordUpload(recordProvider.roundCount);
    Navigator.pop(context);
  }

  Widget _closeButtonWidget() {               //  close button
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(24),
        child: Image.asset(AppImages.xButton, width: 24, height: 24,),
      ),
      onTap: () => { Navigator.pop(context) },
    );
  }

  Widget _tabButtonWidget(double deviceHeight) {
    if(recordProvider.isRecord) {
      return GestureDetector(
        child: Container(
          height: deviceHeight * 0.13,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: MainColors.purple_100, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Lottie.asset(
            AppImages.lottieAnimation,
            width: 55,
            height: 24
          ),
        ),
        onTap: () => _recordButtonCallback(),
      );
    }else {
      return CommonRaisedButton(
        buttonText: Strings.tap_record,
        buttonColor: MainColors.purple_100,
        textColor: Colors.white,
        borderColor: MainColors.purple_100,
        fontSize: 16,
        voidCallback: _recordButtonCallback,
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Positioned(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(top: 35),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        Strings.record_script,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "NotoSansKR",
                            fontWeight: FontWeight.w700,
                            color: MainColors.grey_100
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 32),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            elevation: 0,
                            color: MainColors.grey_google,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Container(
                              width: deviceWidth * 0.3,
                              height: deviceHeight * 0.22,
                              alignment: AlignmentDirectional.center,
                              child: Text(
                                  categoryProvider.getSentenceTitle(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "TmoneyRound",
                                      fontWeight: FontWeight.w400,
                                      color: MainColors.grey_100
                                  )
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.arrow_forward, size: 32, color: MainColors.green_100),
                          SizedBox(width: 16),
                          Card(
                            elevation: 0,
                            color: MainColors.yellow_40,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  child: Container(
                                    width: deviceWidth * 0.53,
                                    height: deviceHeight * 0.22,
                                    alignment: AlignmentDirectional.center,
                                    child: Text(
                                      categoryProvider.getRightPronun().pronunciation,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "TmoneyRound",
                                        fontWeight: FontWeight.w700,
                                        color: MainColors.grey_100
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 6, left: 6),
                                    padding: EdgeInsets.only(top: 3, bottom: 3, left: 6, right: 6),
                                    decoration: BoxDecoration(
                                        color: MainColors.blue_100,
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
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(                //  progress indicator
                      width: deviceWidth * 0.5,
                      margin: EdgeInsets.only(top: 24),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: <Widget>[
                          Positioned(
                            child: LinearProgressIndicator(
                              minHeight: 7,
                              backgroundColor: MainColors.grey_google,
                              value: _avgPower,
                              valueColor: AlwaysStoppedAnimation(MainColors.yellow_100),
                            ),
                          ),
                          Positioned(
                            child: Column(
                              children: <Widget>[
                                Container(child: Image.asset(AppImages.dropDown, width: 12, height: 12), margin: EdgeInsets.only(left: (deviceWidth * 0.5) * 0.35),),
                                Container(width: 1, height: 8, color: MainColors.yellow_100, margin: EdgeInsets.only(left: (deviceWidth * 0.5) * 0.35))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 7),
                    Container(
                      child: Text(
                        Strings.record_quiet_script,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "NotoSansKR",
                          fontWeight: FontWeight.w400,
                          color: MainColors.grey_80
                        ),
                      ),
                    ),
                    SizedBox(height: 22),
                    Container(                      //  Record Button
                      width: deviceWidth * 0.4,
                      padding: EdgeInsets.only(top: 13, bottom: 13, right: 14, left: 14),
                      child: _tabButtonWidget(deviceHeight)
                    )
                  ],
                ),
              ),
            ),
            Positioned(right: 0, top: 0, child: _closeButtonWidget()),

          ],
        ),
      ),
    );
  }
}
