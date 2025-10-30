import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../core/models/download_file_result.dart';
import '../request_service/attachment_section.dart';

class INQResponseCard extends StatelessWidget {
  final List<DownloadFileResult>? files;
  final String? statusWork;
  final String? resolvedDate;
  final String? reply;

  INQResponseCard({this.files, this.statusWork, this.resolvedDate, this.reply});
  @override
  Widget build(BuildContext context) {
    return (reply != null && reply!.isNotEmpty)
        ? INQFinishedResponse(
            files: this.files,
            resolvedDate: resolvedDate,
            reply: reply,
          )
        : INQPendingResponse();
  }
}

class INQFinishedResponse extends StatelessWidget {
  final List<DownloadFileResult>? files;
  final String? resolvedDate;
  final String? reply;
  INQFinishedResponse({this.files, this.resolvedDate, this.reply});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 24, left: 16, right: 16),
        margin: EdgeInsets.only(left: 16, right: 16, top: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x33000000),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                  spreadRadius: 0)
            ],
            color: Colors.white),
        child: Column(
          children: [
            Image.asset(
              "assets/images/responseIcon@3x.png",
              height: 48,
              width: 48,
            ),
            SizedBox(
              height: 12,
            ),
            Text(("inq_replied").tr(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: Constants.appFontType,
                    fontStyle: FontStyle.normal,
                    fontSize: 17.0),
                textAlign: TextAlign.center),
            SizedBox(
              height: 8,
            ),
            (resolvedDate != null && resolvedDate!.isNotEmpty)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/streamlineIconCalendar14X14@3x.png",
                        height: 10.0,
                        width: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Text(
                          resolvedDate ?? "",
                          style: TextStyle(
                              color: Color(0xff737373),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          textScaleFactor: 1.0,
                        ),
                      )
                    ],
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            if (reply != null && reply!.isNotEmpty)
              RichText(
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontFamily: Constants.appFontType,
                            fontStyle: FontStyle.normal,
                            fontSize: 13.0),
                        text: ("inq_support").tr()),
                    TextSpan(
                        style: const TextStyle(
                            color: const Color(0xff737373),
                            fontWeight: FontWeight.w500,
                            fontFamily: Constants.appFontType,
                            fontStyle: FontStyle.normal,
                            fontSize: 13.0),
                        text: reply)
                  ])),
            SizedBox(height: 16),
            if (this.files != null && this.files!.isNotEmpty) greyLine(),
            SizedBox(height: 22),
            if (this.files != null && this.files!.isNotEmpty)
              AttachmentSection(
                files: this.files!,
              )
          ],
        ));
  }

  Widget greyLine() {
    return Container(
      height: 1,
      color: Color(0xff979797).withOpacity(0.2),
    );
  }
}

class INQPendingResponse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 24, left: 16, right: 16),
        margin: EdgeInsets.only(left: 16, right: 16, top: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x33000000),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                  spreadRadius: 0)
            ],
            color: Colors.white),
        child: Column(
          children: [
            Image.asset(
              "assets/images/responseIcon@3x.png",
              height: 48,
              width: 48,
            ),
            SizedBox(
              height: 12,
            ),
            Text(("inq_waiting").tr(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: Constants.appFontType,
                    fontStyle: FontStyle.normal,
                    fontSize: 17.0),
                textAlign: TextAlign.center),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Text(("inq_wait_response").tr(),
                  style: const TextStyle(
                      color: const Color(0xff737373),
                      fontWeight: FontWeight.w500,
                      fontFamily: Constants.appFontType,
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0,
                      height: 1.6),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }
}
