import 'dart:io';

import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/api_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../../../../../app/core/services/global/web_service.dart';
import '../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../app/core/utils/constants/paths/icon_paths.dart';
import '../../../../../app/core/utils/constants/remote_config.dart';
import '../../../../../app/features/_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../core/utils/constants/app_config.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class OfferCostNotesDialog extends StatefulWidget {
  final String notes;
  final String? financialAttachmentId;
  final String? technicalAttachmentId;
  const OfferCostNotesDialog(
      {super.key,
      required this.notes,
      this.financialAttachmentId,
      this.technicalAttachmentId});

  @override
  State<OfferCostNotesDialog> createState() => _OfferCostNotesDialogState();
}

class _OfferCostNotesDialogState extends State<OfferCostNotesDialog> {
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(children: [
          const DrawLineWidget(
            lineWidth: 70.0,
            lineHeight: 6.0,
            lineColor: Color(0xFFE5E5E5),
            radius: 46.0,
          ),
          // header
          DialogHeader(
            title: trans('cost_details'),
          ),
          const CustomVerticalSpace(height: 20),
          Flexible(
            child: CustomTextWidget(
              widget.notes,
              fontColor: AppColor.kGray153,
              fontWeight: AppFontWeight.medium,
              fontSize: 16,
              maxLines: 900,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          if (widget.financialAttachmentId != null)
            GestureDetector(
              onTap: () {
                showApigeeFile(widget.financialAttachmentId!);
              },
              child: Container(
                  height: 56,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0x80E6EFEF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomSvgIconWidget(IconPath.pdf),
                      CustomHorizontalSpace(width: 8),
                      Flexible(
                        child: CustomTextWidget(
                          trans("financialAttachmentId"),
                          fontColor: AppColor.blackModern700Light,
                          fontSize: 12,
                          maxLines: 1,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ],
                  )),
            ),
          CustomVerticalSpace(
            height: 16,
          ),
          if (widget.technicalAttachmentId != null)
            GestureDetector(
              onTap: () {
                showApigeeFile(widget.technicalAttachmentId!);
              },
              child: Container(
                  height: 56,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0x80E6EFEF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomSvgIconWidget(IconPath.pdf),
                      CustomHorizontalSpace(width: 8),
                      Flexible(
                        child: CustomTextWidget(
                          trans("technicalAttachmentId"),
                          fontColor: AppColor.blackModern700Light,
                          fontSize: 12,
                          maxLines: 1,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ],
                  )),
            )
        ]));
  }

  static void showApigeeFile(String fileUrl) async {
    try {
      try {
        EasyLoading.show();
        File fileDownloaded =
            await createFileOfPdfUrl("${ApiUrl.bidAttachments}/$fileUrl");
        EasyLoading.dismiss();

        /*  if (fileName.toLowerCase().contains(".pdf")) {
            Uint8List bytes = fileDownloaded.readAsBytesSync();

            Navigator.push(
                NavigationService.navigatorKey.currentContext!,
                MaterialPageRoute(
                    builder: (context) => PDFViewer(
                          file: bytes,
                          title: fileName,
                        )));
          } else {*/
        OpenFile.open(fileDownloaded.path);
        //  }
      } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
        EasyLoading.dismiss();

        print(error);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      EasyLoading.dismiss();
    }
  }

  static Future<File> createFileOfPdfUrl(String fileUrl) async {
    final url = fileUrl;
    Dio dio = Dio();
    dio.options.baseUrl = RemoteConfig.apigeeURL;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);

    dio.options.receiveTimeout = const Duration(milliseconds: 60000);

    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.addSentry();

    dio.options.responseType = ResponseType.bytes;
    dio.interceptors.add(AppInterceptors());
    ;
    Response r = await WebService(dio: dio).dio.getUri(Uri.parse(url));
    String extension =
        r.headers["Content-Type"].toString().split("/")[1].replaceAll("]", "");
    print(r.headers["Content-Type"]);
    String dir = (await getTemporaryDirectory()).path;
    File file =
        new File('$dir/${DateTime.now().millisecond.toString()}.$extension');
    await file.writeAsBytes(r.data);
    return file;
  }
}
