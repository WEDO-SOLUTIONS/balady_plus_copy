import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../customer_voice_exports.dart'
    show DownloadFileResult, FullImageView, PDFViewer;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class AttachmentSection extends StatelessWidget {
  List<DownloadFileResult> files;
  bool isMSR;

  AttachmentSection({Key? key, required this.files, this.isMSR = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: isMSR
              ? EdgeInsets.zero
              : const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    Constants.imgPath + "attachment@3x.png",
                    height: 25,
                    width: 24,
                  ),
                  const CustomHorizontalSpace(
                    width: 10,
                  ),
                  CustomTextWidget(
                    ("bookNewAppointmentAttachmentsWord").tr(),
                    fontColor: AppColor.black,
                    fontSize: 17,
                  ),
                ],
              ),
              if (!isMSR)
                Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffe6e6e6)),
                    child: Center(
                      child: CustomTextWidget(
                        "${files.length}",
                        fontColor: AppColor.black,
                        fontSize: 11,
                        fontFamily: Constants.lucidaGrandFontType,
                      ),
                    ))
            ],
          ),
        ),
        const CustomVerticalSpace(height: 16),
        Column(
            children: List<Widget>.from(files.map((e) {
          return AttachmentItem(
            file: e,
          );
        }).toList())),
      ],
    );
  }
}

class AttachmentItem extends StatefulWidget {
  DownloadFileResult file;

  AttachmentItem({Key? key, required this.file}) : super(key: key);

  @override
  _AttachmentItemState createState() => _AttachmentItemState();
}

class _AttachmentItemState extends State<AttachmentItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showFile(widget.file);
      },
      child: Container(
          height: 56,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
          color: AppColor.white4,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: getAttachmentIcon(),
              ),
              Constants.horizontalSpaceSmall,
              // attachment name
              Expanded(
                child: CustomTextWidget(
                  widget.file.attachName,
                  fontColor: AppColor.black,
                  textAlign: TextAlign.start,
                  fontSize: 13.0,
                  maxLines: 1,
                ),
              ),
            ],
          )),
    );
  }

  Image getAttachmentIcon() {
    if (widget.file.attachName.contains(".pdf")) {
      return Image.asset(
        "assets/images/pdfIcon@3x.png",
        height: 32,
        width: 32,
      );
    } else {
      return Image.memory(
        base64Decode(widget.file.attachmentStream),
        fit: BoxFit.cover,
        height: 32.0,
        cacheHeight: 32,
        cacheWidth: 32,
        width: 32.0,
      );
    }
  }

  void showFile(DownloadFileResult file) async {
    try {
      if (file.attachName.toLowerCase().contains(".pdf")) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PDFViewer(
                      file: base64.decode(file.attachmentStream),
                      title: file.attachName,
                    )));
      } else if (file.attachName.toLowerCase().contains(".png") ||
          file.attachName.toLowerCase().contains(".jpeg") ||
          file.attachName.toLowerCase().contains(".jpg")) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FullImageView(imageBase64: file.attachmentStream)));
      } else {
        try {
          final encodedStr = file.attachmentStream;
          Uint8List bytes = base64.decode(encodedStr);
          String dir = (await getTemporaryDirectory()).path;
          File filetemp = File("$dir/" + file.attachName);
          await filetemp.writeAsBytes(bytes);
          OpenFile.open(filetemp.path);
        } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
      }
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }
}
