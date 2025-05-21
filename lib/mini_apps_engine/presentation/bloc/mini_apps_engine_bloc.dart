import 'dart:io';

import 'package:archive/archive.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';

import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../server/CustomInAppLocalhostServer.dart';

// this is work
String serviceURL =
    'https://drive.usercontent.google.com/download?id=1Ccv-YQ0A9MkrUBBaj_PnfP7vGY_OK3qU&export=download&authuser=0&confirm=t&uuid=78c3a28a-3558-450c-9c16-0bd501fdafef&at=ALoNOgl36R9HkZ6L-LYJetxWXktb:1747768857912';
String serviceURLSnapAndSend =
    'https://drive.usercontent.google.com/download?id=1pP7dq3vm0_eJ_LO2xal-yhFklz0sQ6J0&export=download&authuser=0&confirm=t&uuid=978d22d5-08e3-40ab-bc6b-ec1da8e8999e&at=ALoNOgly3Q4x1aTS5XlGdAT0QZcq:1747730928317';

String? serviceDownloadPath;

class MiniAppsEngineBloc
    extends Bloc<MiniAppsEngineEvent, MiniAppsEngineState> {
  final MiniAppModel miniApp;

  // final GetSearchEvents _getSearchEvents;
  // final GetEventDetails _getEventDetails;

  MiniAppsEngineBloc({required this.miniApp})
      :
        // _getSearchEvents = GetSearchEvents(repository: sl()),
        // _getEventDetails = GetEventDetails(repository: sl()),
        super(const MiniAppsEngineInitialState()) {
    on<CheckMiniAppsEngineEvent>(_checkMiniAppsEngine);

    on<DownloadMiniAppsEngineEvent>(_downloadMiniAppsEngine);

    add(CheckMiniAppsEngineEvent(miniApp: miniApp));
  }

  void _checkMiniAppsEngine(
      CheckMiniAppsEngineEvent event, Emitter emit) async {
    await prepareServerPath();

    /// TODO : Need replace teh "miniApp" from teh event.miniApp.dir or event.miniApp.nameKey
    String dir =
        '${CommonProperties.serverRootPath}/${event.miniApp.serviceKey}/${event.miniApp.latestVersion?.versionNumber}';
    File file = File('$dir/index.html');
    bool exists = await file.exists();
    if (exists) {
      await startLocalHostServer(dir, event.miniApp.serviceKey);
      String servicePath = '$dir/index.html'.replaceAll(
          CommonProperties.serverRootPath!, "http://localhost:${event.miniApp.serviceKey == "municipalservice" ? 8282 : 8383}");
      emit(MiniAppsEngineLoadedState(servicePath: servicePath));
    } else {
      add(DownloadMiniAppsEngineEvent(miniApp: event.miniApp));
    }

    return;
  }

  Future<String?> prepareDownloadPath(String dir, String version) async {
    try {
      serviceDownloadPath = '${CommonProperties.serverRootPath!}/$dir';
      bool exists = await Directory(serviceDownloadPath!).exists();
      if (exists == false) {
        await Directory(serviceDownloadPath!).create();
      }

      serviceDownloadPath = '${CommonProperties.serverRootPath!}/$dir/$version';
      exists = await Directory(serviceDownloadPath!).exists();
      if (exists == false) {
        await Directory(serviceDownloadPath!).create();
      }

      return serviceDownloadPath;
    } catch (e) {
      return null;
    }
  }

  prepareServerPath() async {
    try {
      String serverRootPath =
          "${(await getApplicationDocumentsDirectory()).path}/www";
      bool existsss = await Directory(serverRootPath).exists();
      if (existsss == false) {
        await Directory(serverRootPath).create();
      }
      CommonProperties.serverRootPath = serverRootPath;
    } catch (e) {}
  }

  void _downloadMiniAppsEngine(
      DownloadMiniAppsEngineEvent event, Emitter emit) async {
    emit(const MiniAppsEngineLoadingState(progress: '0'));

    /// TODO : Need replace teh "miniApp" from teh event.miniApp.dir or event.miniApp.nameKey
    serviceDownloadPath = await prepareDownloadPath(
        "${event.miniApp.serviceKey}",
        event.miniApp.latestVersion!.versionNumber!);

    if (serviceDownloadPath != null) {
      await startLocalHostServer(serviceDownloadPath,event.miniApp.serviceKey);
      print("object");

      var zippedFile = await _downloadFile(
        event.miniApp.latestVersion?.packageMetaDataDto?.id ?? "",
        serviceDownloadPath!,
        event.miniApp.serviceName!,
        event.miniApp.serviceKey!,
        emit,
      );
      if (zippedFile != null) {

        String? indexPath =
            await unarchiveAndSave(zippedFile, serviceDownloadPath!,event.miniApp.serviceKey ?? "");
        if (indexPath == null) {
          if (zippedFile.existsSync()) {
            zippedFile.delete();
          }

          emit(const MiniAppsEngineErrorState(
              errorMessage: "Failed to unarchive the file"));
          return;
        }
        emit(MiniAppsEngineLoadedState(servicePath: indexPath));
      } else {
        emit(const MiniAppsEngineErrorState(
            errorMessage: "Failed to download the file"));
      }
    }
  }

  Future<File?> _downloadFile(
    String fileId,
    String downloadPath,
    String fileName,
    String serviceKey,
    Emitter emitter,
  ) async {
    WebService webService = sl<WebService>();
    try {
      Response response = await webService.dio.get(
        "v1/dms-mobile/files/$fileId",
        // serviceKey == "municipalservice" ? serviceURL : serviceURLSnapAndSend,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            emitter(
              MiniAppsEngineLoadingState(
                progress: (received / total * 100).toStringAsFixed(1),
              ),
            );
          }
        },
        options: Options(
          headers: {"X-Service-Id": 3},
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return (status ?? 501) < 500;
          },
        ),
      );
      var file = File('$downloadPath/$fileName.zip');
      return file.writeAsBytes(response.data);
    } catch (error, stackTrace) {
      print(error);
    }
    return null;
  }

  // Future<File?> _downloadFile(
  //   String url,
  //   String downloadPath,
  //   String zipFileName,
  // ) async {
  //   try {
  //     var req = await http.Client().get(Uri.parse(serviceURL));
  //     if (req.statusCode == 200) {
  //       var file = File('$downloadPath/$zipFileName.zip');
  //
  //       return file.writeAsBytes(req.bodyBytes);
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  //   return null;
  // }

  unarchiveAndSave(var zippedFile, String extractPath,String serviceKey) async {
    String indexFilePath = "";
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    try {
      for (var file in archive) {
        //  var fileName = '${CommonProperties.serverRootPath}/${file.name}';

        if (file.isFile && !file.name.contains("__MACOSX")) {
          var outFile = File('$extractPath/${file.name}');

          if (file.name.contains("index.html")) {
            indexFilePath = outFile.path.replaceAll(
                CommonProperties.serverRootPath!, "http://localhost:${serviceKey == "municipalservice" ? 8282 : 8383}");
          }

          outFile = await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content);
        }
      }
    } catch (e) {
      print("Test");
    }

    return indexFilePath;
  }

// Future<String?> unarchiveAndSave(File zippedFile,emitter) async {
  //   String dir = CommonProperties.serverRootPath!;
  //   String? indexFilePath;
  //   await ZipFile.extractToDirectory(
  //       zipFile: zippedFile,
  //       destinationDir: Directory(dir),
  //       onExtracting: (zipEntry, progress) {
  //         print('progress: ${progress.toStringAsFixed(1)}%');
  //         emitter(
  //           MiniAppsEngineLoadingState(
  //             progress: progress.toStringAsFixed(1),
  //           ),
  //         );
  //
  //         if(zipEntry.name.contains("index.html"))
  //           {
  //             indexFilePath = zipEntry.name;
  //           }
  //         print('name: ${zipEntry.name}');
  //         print('isDirectory: ${zipEntry.isDirectory}');
  //         print(
  //             'modificationDate: ${zipEntry.modificationDate?.toLocal().toIso8601String()}');
  //         print('uncompressedSize: ${zipEntry.uncompressedSize}');
  //         print('compressedSize: ${zipEntry.compressedSize}');
  //         print('compressionMethod: ${zipEntry.compressionMethod}');
  //         print('crc: ${zipEntry.crc}');
  //         return ZipFileOperation.includeItem;
  //       });
  //   return indexFilePath;
  // }

  startLocalHostServer(serverPath, serviceKey) async {
    try {
      bool exists = await Directory(serverPath).exists();
      if (exists == false) {
        await Directory(serverPath).create();
      }

      final localhostServer = CustomInAppLocalhostServer(
          PlatformInAppLocalhostServerCreationParams(
              documentRoot: serverPath,
              port: serviceKey == "municipalservice" ? 8282 : 8383,
              shared: true));
      if (!localhostServer.isRunning()) {
        await localhostServer.start();
        if (defaultTargetPlatform == TargetPlatform.android) {
          await InAppWebViewController.setWebContentsDebuggingEnabled(
              kDebugMode);
        }
      }

      CommonProperties.serverRootPath = serverPath;
    } catch (e) {
      print(e);
    }
  }
}
