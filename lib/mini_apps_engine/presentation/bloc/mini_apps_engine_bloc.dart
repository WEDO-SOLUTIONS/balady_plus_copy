import 'dart:io';
import 'dart:math';

import 'package:archive/archive.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';

import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

import '../../server/CustomInAppLocalhostServer.dart';

String serviceURL =
    'https://drive.usercontent.google.com/download?id=1cFnJwYST3UGxv8MP04hdlhMpzF-mXuQR&export=download&authuser=0&confirm=t&uuid=489fbdee-00d8-4b99-8106-1946cafe8666&at=ALoNOgntH0wxKTJ4ylnHh3aZgNEO:1748266272571';
String serviceURLSnapAndSend =
    'https://drive.usercontent.google.com/download?id=1inW0IpeLsw5UJnP21A6pQaRXK1CegHdz&export=download&authuser=0&confirm=t&uuid=e27f5920-063f-4d81-bd44-dcd1a3cc918c&at=ALoNOgl2f3AAQ6OXXDWzposlI4OD:1748266479101';

// CustomInAppLocalhostServer? localhostServer;
int portNumber = 8080;

class MiniAppsEngineBloc
    extends Bloc<MiniAppsEngineEvent, MiniAppsEngineState> {
  final MiniAppModel miniApp;
  CustomInAppLocalhostServer? localhostServer;
  String? serviceDownloadPath;
  late String basePathService;

  MiniAppsEngineBloc({required this.miniApp})
      : super(const MiniAppsEngineInitialState()) {
    on<CheckMiniAppsEngineEvent>(_checkMiniAppsEngine);

    on<DownloadMiniAppsEngineEvent>(_downloadMiniAppsEngine);
    on<OpenServerEngineEvent>(_openLocalHostServer);

    add(CheckMiniAppsEngineEvent(miniApp: miniApp));
  }

  void _checkMiniAppsEngine(
      CheckMiniAppsEngineEvent event, Emitter emit) async {
    // await prepareServerPath();
    basePathService = "${(await getApplicationDocumentsDirectory()).path}/www/";
    String dir =
        '$basePathService${event.miniApp.serviceKey}/${event.miniApp.latestVersion!.versionNumber!}';
    File file = File('$dir/index.html');
    bool exists = await file.exists();
    if (exists) {
      add(OpenServerEngineEvent(miniApp: miniApp));
    } else {
      add(DownloadMiniAppsEngineEvent(miniApp: event.miniApp));
    }
    return;
  }

  // Future<String?> prepareDownloadPath(String dir, String version) async {
  //   try {
  //     serviceDownloadPath = '${CommonProperties.serverRootPath!}/$dir';
  //     bool exists = await Directory(serviceDownloadPath!).exists();
  //     if (exists == false) {
  //       await Directory(serviceDownloadPath!).create();
  //     }
  //
  //     serviceDownloadPath = '${CommonProperties.serverRootPath!}/$dir/$version';
  //     exists = await Directory(serviceDownloadPath!).exists();
  //     if (exists == false) {
  //       await Directory(serviceDownloadPath!).create();
  //     }
  //
  //     return serviceDownloadPath;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // prepareServerPath() async {
  //   try {
  //     String serverRootPath =
  //         "${(await getApplicationDocumentsDirectory()).path}/www";
  //     bool existsss = await Directory(serverRootPath).exists();
  //     if (existsss == false) {
  //       await Directory(serverRootPath).create();
  //     }
  //     CommonProperties.serverRootPath = serverRootPath;
  //   } catch (e) {}
  // }

  void _downloadMiniAppsEngine(
      DownloadMiniAppsEngineEvent event, Emitter emit) async {
    emit(const MiniAppsEngineLoadingState(progress: '0'));

    serviceDownloadPath = "$basePathService${event.miniApp.serviceKey}";
    Directory directoryApp = Directory(serviceDownloadPath!);
    bool exists = await directoryApp.exists();
    // chick if have old version of the app delete it
    if(exists) {
      await directoryApp.delete(recursive: true);
      serviceDownloadPath = "$serviceDownloadPath/${event.miniApp.latestVersion!.versionNumber!}";
      directoryApp = Directory(serviceDownloadPath!);
      await directoryApp.create(recursive: true);
    } else {
      serviceDownloadPath = "$serviceDownloadPath/${event.miniApp.latestVersion!.versionNumber!}";
      directoryApp = Directory(serviceDownloadPath!);
      await directoryApp.create(recursive: true);
    }
    var zippedFile = await _downloadFile(
      event.miniApp.latestVersion?.packageMetaDataDto?.id ?? "",
      serviceDownloadPath!,
      event.miniApp.serviceKey!,
      emit,
    );
    if (zippedFile != null) {
      await unarchiveAndSave(zippedFile, serviceDownloadPath!);
      add(OpenServerEngineEvent(miniApp: event.miniApp));
    } else {
      emit(
        const MiniAppsEngineErrorState(
          errorMessage: "Failed to download the file",
        ),
      );
    }
  }


  void _openLocalHostServer(OpenServerEngineEvent event, Emitter emit) async {
    try {
      // await startLocalHostServer(serviceDownloadPath, event.miniApp.serviceKey);
      String pathService =
          '$basePathService/${event.miniApp.serviceKey}/${event.miniApp.latestVersion!.versionNumber!}';

      localhostServer ??= CustomInAppLocalhostServer(
        PlatformInAppLocalhostServerCreationParams(
          documentRoot: pathService,
          port: generateRandomPort(portNumber),
          shared: true,
        ),
      );
      bool isRunning = localhostServer!.isRunning();
      if (isRunning) {
        await localhostServer?.close();
        await localhostServer!.start();
      } else {
        await localhostServer!.start();
      }

      String servicePath = '$pathService/index.html'.replaceAll(
        pathService,
        "http://localhost:${localhostServer!.port}",
      );

      emit(MiniAppsEngineLoadedState(servicePath: servicePath));
    } catch (e) {
      print(e.toString());
    }
  }


  Future<File?> _downloadFile(
    String fileId,
    String downloadPath,
    String serviceKey,
    Emitter emitter, {
    int retryCounter = 0,
  }) async {
    WebService webService = sl<WebService>();
    try {
      Response response = await webService.dio.get(
        // fileId,
        // "v1/dms-mobile/files/$fileId",
        serviceKey == "municipalservice" ? serviceURL : serviceURLSnapAndSend,
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

      var file = File('$downloadPath/$serviceKey.zip');
      return file.writeAsBytes(response.data);
    } catch (error, stackTrace) {
      if (retryCounter < 3) {
        // Retry downloading the file up to 3 times
        return _downloadFile(
          fileId,
          downloadPath,
          serviceKey,
          emitter,
          retryCounter: retryCounter + 1,
        );
      } else {
        emit(const FailedDownloadState());
      }
      print(error);
    }
    return null;
  }

  unarchiveAndSave(var zippedFile, String extractPath) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    try {
      for (var file in archive) {
        //  var fileName = '$basePathService/${file.name}';
        if (file.isFile && !file.name.contains("__MACOSX")) {
          var outFile = File('$extractPath/${file.name}');
          if (file.name.contains("index.html")) {
            // indexFilePath = outFile.path.replaceAll(
            //   basePathService,
            //   "http://localhost:$portNumber",
            // );
          }
          outFile = await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content);
        }
      }
    } catch (e) {
      print("Test");
    }
    // return indexFilePath;
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

  int generateRandomPort(int oldPort) {
    final random = Random();
    int newPort = 8080 + random.nextInt(22); // 8080 to 8090 inclusive

    if (newPort != oldPort) {
      return newPort;
    } else {
      return generateRandomPort(oldPort);
    }
  }

  @override
  Future<void> close() async {
    await localhostServer?.close();
    return super.close();
  }
}
