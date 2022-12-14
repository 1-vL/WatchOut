import 'package:flutter/material.dart';
import 'package:homealone/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CallDialog extends StatelessWidget {
  final String? titles;
  final String names;
  final String phones;
  final String? texts;
  final Widget Function(BuildContext)? pageBuilder;

  final Map<String, String> emoji = {
    "편의점": "🏪",
    "파출소": "🚔",
    "약국": "💊",
    "병원": "🏥",
    "안심 택배": "🎁",
    "비상벨": "🔔"
  };

  CallDialog(this.titles, this.names, this.phones, this.texts, this.pageBuilder,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
      child: Container(
        padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 1.5.h),
        height: (this.texts == null) ? 15.h : 25.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Title(
              color: bColor,
              child: (this.titles == null)
                  ? Text(
                      names,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontFamily: 'HanSan',
                      ),
                    )
                  : Text(emoji[titles]! + " " + names,
                      style: TextStyle(fontSize: 12.5.sp)),
            ),
            Text(phones.isEmpty ? "등록된 번호가 없습니다." : phones),
            (this.texts == null)
                ? Padding(padding: EdgeInsets.zero)
                : Text(texts!, textAlign: TextAlign.center),
            Container(
              width: 35.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  phones.isEmpty
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yColor,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: null,
                          child: Text(
                            "통화",
                            style: TextStyle(color: bColor),
                          ))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yColor,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          onPressed: () {
                            UrlLauncher.launchUrl(Uri.parse("tel:" + phones));
                          },
                          child: Text(
                            "통화",
                            style: TextStyle(
                              color: bColor,
                              fontFamily: 'HanSan',
                            ),
                          ),
                        ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: b25Color,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onPressed: () {
                      if (pageBuilder == null) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.push(
                            context, MaterialPageRoute(builder: pageBuilder!));
                      }
                    },
                    child: Text(
                      "취소",
                      style: TextStyle(
                        color: bColor,
                        fontFamily: 'HanSan',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
