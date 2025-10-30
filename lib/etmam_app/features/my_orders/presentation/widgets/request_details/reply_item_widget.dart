import 'dart:io';

import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/my_orders/presentation/widgets/request_details/reply_badge_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../../../../../../app/core/services/global/web_service.dart';
import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/core/utils/constants/paths/icon_paths.dart';
import '../../../../../../app/core/utils/constants/remote_config.dart';
import '../../../../../../app/core/utils/enums/app_font_weights.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../core/utils/constants/api_url.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class ReplyItemWidget extends StatelessWidget {
  final String name;
  final int number;
  final bool accepted;
  final String? financialAttachmentId;
  final String? technicalAttachmentId;
  const ReplyItemWidget(
      {super.key,
      required this.name,
      required this.number,
      this.financialAttachmentId,
      this.technicalAttachmentId,
      this.accepted = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomVerticalSpace(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              name,
              fontColor: AppColor.kGray115,
            ),
            ReplyBadgeWidget(
                text: accepted == true
                    ? trans("offer_aceepted")
                    : trans("reply").replaceAll("{}", number.toString()))
          ],
        ),
        if (financialAttachmentId != null || technicalAttachmentId != null) ...[
          CustomVerticalSpace(height: 16),
          if (financialAttachmentId != null)
            GestureDetector(
              onTap: () {
                showApigeeFile(financialAttachmentId!);
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
          if (technicalAttachmentId != null)
            GestureDetector(
              onTap: () {
                showApigeeFile(technicalAttachmentId!);
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
        ],
        CustomVerticalSpace(height: 16),
        DrawLineWidget(lineColor: AppColor.black.withOpacity(0.1)),
      ],
    );
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
