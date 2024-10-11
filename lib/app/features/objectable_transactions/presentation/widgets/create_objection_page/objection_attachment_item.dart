import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../../../../../core/services/global/web_service.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/apis/api_info.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/pages/pdf_view.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../objections/domain/entities/objection_details.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class ObjectionAttachmentItem extends StatefulWidget {
  ReasonAttachment file;
  String? name;
  double? width;
  String? sessionId; 

  ObjectionAttachmentItem({Key? key, required this.file, this.name, this.width, this.sessionId})
      : super(key: key);

  @override
  _ObjectionAttachmentItemState createState() =>
      _ObjectionAttachmentItemState();
}

class _ObjectionAttachmentItemState extends State<ObjectionAttachmentItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showFile(widget.file);
      },
      child: Container(
          height: 56,
          width: widget.width,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0x80E6EFEF),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ((widget.file.fileName
                          ?.split(".")
                          .last
                          .toLowerCase()
                          .contains("pdf") ??
                      false))
                  ? const CustomSvgIconWidget(IconPath.pdf)
                  : CustomNetworkImageWidget(
                    
                    widget.sessionId !=null ?( widget.file.getV2Url(widget.sessionId!) ?? "")  :  widget.file.getUrl() ?? "",
                      imageWidth: 24,
                   addHeader: true,
                      imageHeight: 28,
                         sso: widget.sessionId!=null ?  true : false,

                    ),
              CustomHorizontalSpace(width: 8),
              Flexible(
                child: CustomTextWidget(
                  widget.name ?? (widget.file.fileName ?? ""),
                  fontColor: AppColor.blackModern700Light,
                  fontSize: 12,
                  maxLines: 1,
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ],
          )),
    );
  }

  Image getAttachmentIcon() {
    if (widget.file.fileName?.contains(".pdf") ?? false) {
      return Image.asset(
        "assets/images/pdfIcon@3x.png",
        height: 32,
        width: 32,
      );
    } else {
      return Image.asset(
        "assets/images/attachmentIcon@3x.png",
        fit: BoxFit.cover,
        height: 32.0,
        cacheHeight: 32,
        cacheWidth: 32,
        width: 32.0,
      );
    }
  }

  void showFile(ReasonAttachment file) async {

    String? url = widget.sessionId!=null ? file.getV2Url(widget.sessionId!) : file.getUrl();
    try {
      if (file.fileName!.toLowerCase().contains(".png") ||
          file.fileName!.toLowerCase().contains(".jpeg") ||
          file.fileName!.toLowerCase().contains(".jpg")) {
        //MM
        NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.dmsImageFullScreen, arguments: url);
      } else {
        try {
          EasyLoading.show();
          File fileDownloaded = await createFileOfPdfUrl( url ?? "");
          EasyLoading.dismiss();

          /*  final encodedStr = file.attachmentStream;
          Uint8List bytes = base64.decode(encodedStr);
          String dir = (await getTemporaryDirectory()).path;
          File filetemp = File("$dir/" + file.attachName);
          await filetemp.writeAsBytes(bytes);
          print(filetemp.path);*/

          if (file.fileName?.toLowerCase().contains(".pdf") ?? false) {
            Uint8List bytes = fileDownloaded.readAsBytesSync();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PDFViewer(
                          file: bytes,
                          title: file.fileName,
                        )));
          } else {
            OpenFile.open(fileDownloaded.path);
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

  Future<File> createFileOfPdfUrl(String fileUrl) async {
    final url = fileUrl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    Dio dio = Dio();
    dio.options.baseUrl = RemoteConfig.apigeeURL;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.responseType = ResponseType.bytes;
    dio.addSentry();

    dio.interceptors.add(AppInterceptors());
    ;
    Response r = await WebService(dio: dio)
        .dio
        .getUri(Uri.parse(url), options: Options(headers: {"X-Service-Id": 2,  'Authorization': 'Bearer ${CommonProperties.token}',}));

    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(r.data);
    return file;
  }
}
