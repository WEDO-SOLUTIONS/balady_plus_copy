import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/pages/pdf_view.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';


class AttachmentShowWidget extends StatelessWidget {
  final String fileName;
  final String name;
  final String filePath;

  const AttachmentShowWidget({
    super.key,
    required this.fileName,
    required this.name,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0x80E6EFEF),
      ),
      child: InkWell(
        onTap: () => CommonFunctions.showApigeeFile(filePath, fileName),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ((fileName.split(".").last.toLowerCase().contains("pdf")))
                      ? const CustomSvgIconWidget(IconPath.pdf)
                      : filePath.startsWith("http")
                          ? Container()
                          : Image.file(
                              File(filePath),
                              width: 24,
                              height: 28,
                            ),
                  const CustomHorizontalSpace(width: 8),
                  Flexible(
                    child: CustomTextWidget(
                      name,
                      fontColor: AppColor.blackModern700Light,
                      fontSize: 12,
                      maxLines: 1,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ),
                ],
              ),
            ),
            fileName.isNotEmpty
                ? const DrawIconBasedTypeWidget(icon: IconPath.download)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void showFile(String fileUrl, String fileName) async {
    try {
      if (fileName.toLowerCase().contains(".png") ||
          fileName.toLowerCase().contains(".jpeg") ||
          fileName.toLowerCase().contains(".jpg")) {
        NavigationService.navigatorKey.currentState!.pushNamed(
          CommercialRouteName.apigeeImageFullScreen,
          arguments: fileUrl,
        );
      } else {
        try {
          EasyLoading.show();
          File fileDownloaded = await createFileOfPdfUrl(fileUrl, fileName);
          EasyLoading.dismiss();
          if (fileName.toLowerCase().contains(".pdf")) {
            Uint8List bytes = fileDownloaded.readAsBytesSync();
            NavigationService.navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => PDFViewer(
                  file: bytes,
                  title: fileName,
                ),
              ),
            );
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

  Future<File> createFileOfPdfUrl(String fileUrl, String fileName) async {
    final url = fileUrl;
    Dio dio = Dio();
    dio.options.baseUrl = RemoteConfig.apigeeURL;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.addSentry();
    dio.options.responseType = ResponseType.bytes;
    dio.interceptors.add(AppInterceptors());
    Response r = await WebService(dio: dio).dio.getUri(Uri.parse(url));
    String dir = (await getTemporaryDirectory()).path;
    File file = File('$dir/$fileName');
    await file.writeAsBytes(r.data);
    return file;
  }
}
