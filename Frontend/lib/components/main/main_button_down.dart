import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:button_animations/button_animations.dart';
import 'package:button_animations/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_widget/home_widget.dart';
import 'package:homealone/api/api_kakao.dart';
import 'package:homealone/api/api_message.dart';
import 'package:homealone/components/dialog/basic_dialog.dart';
import 'package:homealone/components/dialog/report_dialog.dart';
import 'package:homealone/components/dialog/sos_dialog.dart';
import 'package:homealone/constants.dart';
import 'package:homealone/pages/emergency_manual_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:volume_control/volume_control.dart';

import 'main_page_animated_button.dart';

ApiKakao apiKakao = ApiKakao();
ApiMessage apiMessage = ApiMessage();

String kakaoMapKey = "";

double initLat = 37.5;
double initLon = 127.5;

bool emergencyFromWidget = false;

class MainButtonDown extends StatefulWidget {
  const MainButtonDown({Key? key}) : super(key: key);

  @override
  State<MainButtonDown> createState() => _MainButtonDownState();
}

class _MainButtonDownState extends State<MainButtonDown> {
  final _authentication = FirebaseAuth.instance;
  Map<String, dynamic>? user;
  List<Map<String, dynamic>> emergencyCallList = [];
  Timer? timer;
  String message = "";
  List<String> recipients = [];
  late BuildContext dialogContext;
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool useSiren = false;
  String address = "";
  static const platform = MethodChannel('com.ssafy.homealone/channel');

  Future _getKakaoKey() async {
    await dotenv.load();
    kakaoMapKey = dotenv.get('kakaoMapAPIKey');
    FirebaseFirestore.instance
        .collection("user")
        .doc(_authentication.currentUser?.uid)
        .get()
        .then((response) {
      user = response.data() as Map<String, dynamic>;
    });
    return kakaoMapKey;
  }

  void _sendSMS(String message, List<String> recipients) async {
    await Permission.sms.request();
    if (await Permission.sms.isDenied) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicDialog(EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0.5.h),
                15.h, 'SMS ?????? ????????? ??????\n ????????? ????????? ??? ????????????.', null);
          });
      return;
    }
    String _result = await platform.invokeMethod(
        'sendTextMessage', {'message': message, 'recipients': recipients});
    if (_result == "sent") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicDialog(EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0.5.h),
                12.5.h, '?????? ?????? ???????????? ??????????????????.', null);
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicDialog(EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0.5.h),
                12.5.h, "????????? ????????? ??????????????????.", null);
          });
    }
  }

  void _sendMMS(XFile file, String message, List<String> recipients) async {
    Map<String, dynamic> _result =
        await apiMessage.sendMMSMessage(file, recipients, message);
    if (_result["statusCode"] == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicDialog(EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0.5.h),
                12.5.h, '?????? ???????????? ??????????????????.', null);
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicDialog(EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0.5.h),
                12.5.h, _result["message"], null);
          });
    }
  }

  void sendEmergencyMessage() async {
    prepareMessage();
    timer = Timer(Duration(seconds: 5), () async {
      Navigator.pop(dialogContext);
      if (await Permission.location.isDenied) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return BasicDialog(EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0.5.h),
                  15.h, '?????? ????????? ??????\n?????? ?????? ????????? ??????????????????.', null);
            });
        return;
      } else if (recipients.isEmpty) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return BasicDialog(EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 0.5.h),
                  12.5.h, '?????????????????? ??????????????????.', null);
            });
        return;
      }
      _sendSMS(message, recipients);
      SharedPreferences pref = await SharedPreferences.getInstance();
      useSiren =
          pref.getBool('useSiren') == null ? false : pref.getBool('useSiren')!;
      debugPrint('----------------------${pref.getBool('useSiren')}');
      if (useSiren) {
        await _sosSoundSetting();
        VolumeControl.setVolume(1);
        assetsAudioPlayer.open(Audio("assets/sounds/siren.mp3"),
            audioFocusStrategy:
                AudioFocusStrategy.request(resumeAfterInterruption: true));
      }
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return SOSDialog();
        }).then((value) {
      timer?.cancel();
    });
  }

  Future<void> _sosSoundSetting() async {
    try {
      final String result = await platform.invokeMethod('sosSoundSetting');
    } on PlatformException catch (e) {
      debugPrint('sound setting failed');
    }
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    initLat = position.latitude;
    initLon = position.longitude;
    address =
        await apiKakao.searchRoadAddr(initLat.toString(), initLon.toString());
  }

  void prepareMessage() async {
    await getCurrentLocation();
    message =
        "${user?["name"]} ?????? WatchOut ????????? SOS ????????? ???????????????. ?????? ????????? ???????????????. \n?????? ?????? ?????? : ${address}\n ??? ???????????? WatchOut?????? ?????? ????????? ??????????????????.";
    await getEmergencyCallList();
    recipients = [];
    for (var i = 0; i < emergencyCallList.length; i++) {
      recipients.add(emergencyCallList[i]["number"]);
    }
  }

  Future<List<Map<String, dynamic>>> getEmergencyCallList() async {
    final firstResponder = await FirebaseFirestore.instance
        .collection("user")
        .doc(_authentication.currentUser?.uid)
        .collection("firstResponder");
    final result = await firstResponder.get();
    setState(() {
      emergencyCallList = [];
    });
    result.docs.forEach((value) => {
          emergencyCallList
              .add({"name": value.id, "number": value.get("number")})
        });
    return emergencyCallList;
  }

  void sendReportMessage(XFile file) async {
    await getCurrentLocation();
    message =
        "${user?["name"]} ?????? WatchOut ????????? ?????? ????????? ???????????????. ?????? ????????? ??? ????????? ????????????. ?????? ????????? ???????????????. \n????????? ?????? : ${user?["phone"]}\n?????? ?????? ?????? : ${address}\n ??? ???????????? WatchOut?????? ?????? ????????? ??????????????????.";
    recipients = ["112"];
    _sendMMS(file, message, recipients);
  }

  void _takePhoto() async {
    ImagePicker()
        .getImage(
            source: ImageSource.camera,
            maxHeight: 1500,
            maxWidth: 1500,
            imageQuality: 50)
        .then((PickedFile? recordedImage) {
      if (recordedImage != null) {
        GallerySaver.saveImage(recordedImage.path, albumName: 'Watch OuT')
            .then((bool? success) {});

        XFile file = XFile(recordedImage!.path);
        sendReportMessage(file);
      }
    });
  }

  void _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ReportDialog(_takePhoto);
        });
  }

  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (uri?.host == 'sos' && !emergencyFromWidget) {
      sendEmergencyMessage();
      emergencyFromWidget = true;
    }
  }

  void _widgetClicked(Uri? uri) {
    if (uri?.host == 'sos') {
      sendEmergencyMessage();
      emergencyFromWidget = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _getKakaoKey();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_widgetClicked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: AnimatedButton(
                    width: 30.w,
                    blurRadius: 7.5,
                    isOutline: true,
                    type: null,
                    color: oColor,
                    onTap: _showReportDialog,
                    child: Text(
                      '??????',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: bColor,
                        fontFamily: 'HanSan',
                      ),
                    ),
                  ),
                ),
                MainPageAniBtn(
                  margins: EdgeInsets.only(bottom: 4),
                  types: PredefinedThemes.warning,
                  ontaps: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 0.8,
                          child: Container(
                            height: 450.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            child: EmergencyManual(), // ?????? ??????
                          ),
                        );
                      },
                    );
                  },
                  texts: '???????????? \n???????????????',
                  colors: bColor,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: AnimatedButton(
              height: 17.5.h,
              width: 50.w,
              blurRadius: 7.5,
              isOutline: true,
              type: PredefinedThemes.danger,
              onTap: () async {
                if (await Permission.sms.isGranted != true) {
                  await showDialog(
                      context: context,
                      builder: (context) => BasicDialog(
                          EdgeInsets.fromLTRB(5.w, 2.5.h, 5.w, 1.25.h),
                          23.h,
                          "WatchOuT?????? '?????? ?????? ??????', '????????? ??????', '????????? ??????????????? ??????' ???????????? '?????? ?????? ??????'??? ????????? ??? ????????? 'SMS ??????'??? ????????? ?????????."
                          "?????? ?????????????????? ?????? ?????? ?????? ????????? ?????? ?????? ????????? ???????????????.",
                          null));
                  await Permission.sms.request();
                }
                return sendEmergencyMessage();
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      child: Image.asset(
                        "assets/icons/shadowsiren1.png",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'S\nO\nS',
                      style: TextStyle(
                        fontSize: 17.5.sp,
                        fontFamily: 'HanSan',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
