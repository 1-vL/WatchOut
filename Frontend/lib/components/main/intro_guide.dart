import 'package:button_animations/button_animations.dart';
import 'package:button_animations/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:homealone/components/main/main_page_animated_button.dart';
import 'package:homealone/constants.dart';
import 'package:sizer/sizer.dart';

class MainGuide extends StatefulWidget {
  const MainGuide({Key? key}) : super(key: key);

  @override
  State<MainGuide> createState() => _MainGuideState();
}

class _MainGuideState extends State<MainGuide> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'WatchOuT',
            style:
                TextStyle(color: yColor, fontSize: 20.sp, fontFamily: 'HanSan'),
          ),
          backgroundColor: bColor,
          actions: [
            Container(
              padding: EdgeInsets.fromLTRB(1.w, 1.h, 1.w, 1.h),
              child: IntroStepBuilder(
                order: 1,
                // text: '클릭시 개인 정보 수정 화면',
                text: Text(
                  '클릭시 SOS 버튼',
                ).data,
                padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                onWidgetLoad: () {
                  Intro.of(context).start();
                },
                builder: (context, key) => CircleAvatar(
                    backgroundImage: AssetImage('assets/icons/shadowsiren.png'),
                    key: key),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                height: kToolbarHeight - 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  children: [
                    IntroStepBuilder(
                      order: 2,
                      text: '클릭 시 홈 화면',
                      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                      builder: (context, key) => Expanded(
                        key: key,
                        flex: 1,
                        child: Container(
                          height: kToolbarHeight - 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: bColor,
                          ),
                          child: Center(
                            child: Text(
                              '홈',
                              style: TextStyle(
                                color: yColor,
                                fontFamily: 'HanSan',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IntroStepBuilder(
                      order: 3,
                      text: '클릭 시 안전 지도 화면',
                      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                      builder: (context, key) => Expanded(
                        key: key,
                        flex: 1,
                        child: Container(
                          height: kToolbarHeight - 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: Text(
                              '안전 지도',
                              style: TextStyle(
                                color: bColor,
                                fontFamily: 'HanSan',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IntroStepBuilder(
                      order: 4,
                      text: '클릭 시 귀가 공유 화면',
                      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                      builder: (context, key) => Expanded(
                        key: key,
                        flex: 1,
                        child: Container(
                          height: kToolbarHeight - 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: Text(
                              '귀가 공유',
                              style: TextStyle(
                                color: bColor,
                                fontFamily: 'HanSan',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IntroStepBuilder(
                      order: 5,
                      text: '클릭 시 설정 화면',
                      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                      builder: (context, key) => Expanded(
                        key: key,
                        flex: 1,
                        child: Container(
                          height: kToolbarHeight - 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: Text(
                              '설정',
                              style: TextStyle(
                                color: bColor,
                                fontFamily: 'HanSan',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Text('가이드 보러가기',
                          style: TextStyle(
                            fontFamily: 'HanSan',
                          )),
                      margin: EdgeInsets.all(8),
                    ),
                    IntroStepBuilder(
                      order: 6,
                      text: '클릭 시 가이드 화면',
                      padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                      builder: (context, key) => ElevatedButton(
                        key: key,
                        onPressed: () {},
                        child: Icon(Icons.question_mark, color: yColor),
                        style: IconButton.styleFrom(
                          shape: CircleBorder(),
                          minimumSize: Size.zero,
                          padding: EdgeInsets.all(2),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: bColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IntroStepBuilder(
                  order: 7,
                  text: '클릭 시 유투브 화면',
                  padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                  builder: (context, key) => ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    key: key,
                    child: Image.asset(
                      'assets/guidesample.jpg',
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: IntroStepBuilder(
                            order: 8,
                            text: '클릭 시 홈캠 화면',
                            padding: EdgeInsets.fromLTRB(
                                -2.w, -2.25.h, -2.w, -2.25.h),
                            builder: (context, key) => AnimatedButton(
                              key: key,
                              height: 17.5.h,
                              width: 50.w,
                              blurRadius: 7.5,
                              isOutline: true,
                              type: PredefinedThemes.light,
                              onTap: () {},
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Text(
                                        'C\nA\nM',
                                        style: TextStyle(
                                            fontSize: 17.5.sp,
                                            fontFamily: 'HanSan'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: ClipRRect(
                                      child: Image.asset(
                                        "assets/icons/shadowcctvreverse.png",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IntroStepBuilder(
                              order: 9,
                              text: '클릭 시 안심귀가 서비스 화면',
                              padding:
                                  EdgeInsets.fromLTRB(-2.5.w, 2, -2.5.w, 2),
                              builder: (context, key) => AnimatedButton(
                                key: key,
                                width: 30.w,
                                blurRadius: 7.5,
                                isOutline: true,
                                type: null,
                                color: nColor,
                                onTap: () async {},
                                child: Text(
                                  '성범죄자\n알림e',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'HanSan',
                                  ),
                                ),
                              ),
                            ),
                            IntroStepBuilder(
                              order: 10,
                              text: '클릭 시 성범죄자 알림e 화면',
                              padding:
                                  EdgeInsets.fromLTRB(-2.5.w, 2, -2.5.w, -1),
                              builder: (context, key) => MainPageAniBtn(
                                key: key,
                                margins: EdgeInsets.only(bottom: 4),
                                types: PredefinedThemes.primary,
                                ontaps: () {},
                                texts: '안심귀가\n서비스',
                                colors: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IntroStepBuilder(
                              order: 11,
                              text: '클릭 시 신고 화면',
                              padding:
                                  EdgeInsets.fromLTRB(-2.5.w, 2, -2.5.w, -1),
                              builder: (context, key) => MainPageAniBtn(
                                key: key,
                                margins: EdgeInsets.only(bottom: 4),
                                types: PredefinedThemes.warning,
                                ontaps: () {},
                                texts: '신고',
                                colors: bColor,
                              ),
                            ),
                            IntroStepBuilder(
                              order: 12,
                              text: '클릭 시 위기상황 대처메뉴얼 화면',
                              padding:
                                  EdgeInsets.fromLTRB(-2.5.w, -1, -2.5.w, 2),
                              builder: (context, key) => MainPageAniBtn(
                                key: key,
                                margins: EdgeInsets.only(top: 4),
                                types: PredefinedThemes.warning,
                                ontaps: () {},
                                texts: '위기상황 \n대처메뉴얼',
                                colors: bColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: IntroStepBuilder(
                          order: 13,
                          // 화면에 안 나옴
                          text: '클릭 시 SOS 화면',
                          padding:
                              EdgeInsets.fromLTRB(-2.w, -2.25.h, -2.w, -2.25.h),
                          overlayBuilder: (params) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    // 화면에 나옴
                                    '클릭 시 SOS 화면',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IntroButton(
                                          onPressed: () {
                                            params.onFinish();
                                            Navigator.of(context).pop();
                                          },
                                          text: '완료',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          builder: (context, key) => AnimatedButton(
                            key: key,
                            height: 17.5.h,
                            width: 50.w,
                            blurRadius: 7.5,
                            isOutline: true,
                            type: PredefinedThemes.danger,
                            onTap: () {},
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
                                  child: Container(
                                    child: Text(
                                      'S\nO\nS',
                                      style: TextStyle(
                                          fontSize: 17.5.sp,
                                          fontFamily: 'HanSan'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   style: ElevatedButton.styleFrom(backgroundColor: bColor),
              //   child: Text(
              //     '돌아가기',
              //     style: TextStyle(color: yColor),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
