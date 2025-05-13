import 'dart:io';

import 'package:archive/archive.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_archive/flutter_archive.dart';

import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../server/CustomInAppLocalhostServer.dart';

// this is work
// String serviceURL = 'https://drive.usercontent.google.com/download?id=1WVDinT28cLMOTq6r2UcCiDqFPXSKk49L&export=download&authuser=0&confirm=t&uuid=0f16710c-e210-43ec-a58d-c1e2ba767d80&at=ALoNOgmz8NH8LvyhFP13FKZun3O3%3A1746969924620';
String serviceURL =
    'https://drive.usercontent.google.com/download?id=1vD9qN75I6jJgmvF5BZfGyozK_yKltk2B&export=download&authuser=0&confirm=t&uuid=7a4f8326-c623-49d0-a400-08c07b94372a&at=ALoNOgktzpJMAE4AijIAME2Av65y:1747130130230';
//String serviceURL = 'https://drive.usercontent.google.com/download?id=17B7J9A4UFwdtW25BdzIs9g7XopSFGKXU&export=download&authuser=0&confirm=t&uuid=900eacde-a137-4792-b514-0561c1b92651&at=ALoNOgl9NUZcnovldcXh7hiYnq2T%3A1746965764624';
// String serviceURL = 'https://drive.google.com/uc?export=download&id=1jNZaTK6PMC_aTwZ8PHJQfEO3r2OyGFRy';


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
        '${CommonProperties.serverRootPath}/miniApp/v${event.miniApp.latestVersion.versionNumber}';
    File file = File('$dir/index.html');
    bool exists = await file.exists();
    if (exists) {
      await startLocalHostServer(dir);
      String servicePath = '$dir/index.html'.replaceAll(
          CommonProperties.serverRootPath!, "http://localhost:8080");
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

      serviceDownloadPath =
          '${CommonProperties.serverRootPath!}/$dir/v$version';
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
    serviceDownloadPath =
        await prepareDownloadPath("miniApp", event.miniApp.latestVersion.versionNumber);

    if (serviceDownloadPath != null) {
      await startLocalHostServer(serviceDownloadPath);
      var zippedFile = await _downloadFile(
          event.miniApp.latestVersion.serviceUrl, serviceDownloadPath!, event.miniApp.serviceName);
      if (zippedFile != null) {
        String? indexPath =
            await unarchiveAndSave(zippedFile, serviceDownloadPath!);
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

  // Future<File?> _downloadFile(
  //     Emitter emitter, String url, String fileName) async {
  //   var tempDir = await getTemporaryDirectory();
  //   String fullPath = "${tempDir.path}/$fileName.zip'";
  //   File file = File(fullPath);
  //   if (await file.exists()) {
  //     return file;
  //   } else {
  //     WebService webService = sl<WebService>();
  //     try {
  //       Response response = await webService.dio.get(
  //         url,
  //         onReceiveProgress: (received, total) {
  //           if (total != -1) {
  //             emitter(
  //               MiniAppsEngineLoadingState(
  //                 progress: (received / total * 100).toStringAsFixed(1),
  //               ),
  //             );
  //           }
  //         },
  //         options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           validateStatus: (status) {
  //             return (status ?? 501) < 500;
  //           },
  //         ),
  //       );
  //       print(response.headers);
  //       File file = File(fullPath);
  //     //  var raf = file.openSync(mode: FileMode.write);
  //       // response.data is List<int> type
  //        file.writeAsBytes(response.data,flush: true);
  //       //raf.writeByte(response.data);
  //      // await raf.close();
  //       return file;
  //     } catch (error, stackTrace) {
  //       print(error);
  //     }
  //     return null;
  //   }
  // }

  Future<File?> _downloadFile(
      String url, String downloadPath, String zipFileName) async {
    try {
      var req = await http.Client().get(Uri.parse(url));
      if (req.statusCode == 200) {
        var file = File('$downloadPath/${zipFileName}.zip');

        return file.writeAsBytes(req.bodyBytes);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  unarchiveAndSave(var zippedFile, String extractPath) async {
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
                CommonProperties.serverRootPath!, "http://localhost:8080");
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

  startLocalHostServer(serverPath) async {
    try {
      bool exists = await Directory(serverPath).exists();
      if (exists == false) {
        await Directory(serverPath).create();
      }

      final localhostServer = CustomInAppLocalhostServer(
          PlatformInAppLocalhostServerCreationParams(
              documentRoot: serverPath, port: 8080, shared: true));
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
