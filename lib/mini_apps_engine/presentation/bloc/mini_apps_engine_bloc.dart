import 'dart:io';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_archive/flutter_archive.dart';

import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';


final testMiniApp = MiniAppModel(
  url:
      "https://drive.usercontent.google.com/download?id=1NdNhkOoClf8yTSVwFlHTTXziDbsM_GDk&export=download&authuser=0&confirm=t&uuid=b04073e3-3fff-4cff-807c-e1b422db15b0&at=APcmpozg5H4sbkOVxmCWL0KiiiXH%3A1746617874644",
  name: "municipal_services",
);

class MiniAppsEngineBloc
    extends Bloc<MiniAppsEngineEvent, MiniAppsEngineState> {
  // final GetSearchEvents _getSearchEvents;
  // final GetEventDetails _getEventDetails;

  MiniAppsEngineBloc()
      :
        // _getSearchEvents = GetSearchEvents(repository: sl()),
        // _getEventDetails = GetEventDetails(repository: sl()),
        super(const MiniAppsEngineInitialState()) {
    on<CheckMiniAppsEngineEvent>(_checkMiniAppsEngine);

    on<DownloadMiniAppsEngineEvent>(_downloadMiniAppsEngine);

    add(CheckMiniAppsEngineEvent(miniApp: testMiniApp));

    startLocalHostServer();
  }

  void _checkMiniAppsEngine(
      CheckMiniAppsEngineEvent event, Emitter emit) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/${event.miniApp.name}/index.html');
    bool exists = await file.exists();
    if (exists) {
      emit(const MiniAppsEngineLoadedState(servicePath: "index.html"));
    } else {
      add(DownloadMiniAppsEngineEvent(miniApp: event.miniApp));
    }

    return;
  }

  void _downloadMiniAppsEngine(
      DownloadMiniAppsEngineEvent event, Emitter emit) async {
    emit(const MiniAppsEngineLoadingState(progress: '0'));
    var zippedFile = await _downloadFile(emit,event.miniApp.url, event.miniApp.name);
    if (zippedFile != null) {
      String? indexPath = await unarchiveAndSave(zippedFile,emit);
      if (indexPath == null) {
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

  Future<File?> _downloadFile(
      Emitter emitter, String url, String fileName) async {
    var tempDir = await getTemporaryDirectory();
    String fullPath = "${tempDir.path}/$fileName.zip'";
    File file = File(fullPath);
    if (await file.exists()) {
      return file;
    } else {
      WebService webService = sl<WebService>();
      try {
        Response response = await webService.dio.get(
          url,
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
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return (status ?? 501) < 500;
            },
          ),
        );
        print(response.headers);
        File file = File(fullPath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        await raf.close();
        return file;
      } catch (error, stackTrace) {
        print(error);
      }
      return null;
    }
  }

  Future<String?> unarchiveAndSave(File zippedFile,emitter) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    await ZipFile.extractToDirectory(
        zipFile: zippedFile,
        destinationDir: Directory(dir),
        onExtracting: (zipEntry, progress) {
          print('progress: ${progress.toStringAsFixed(1)}%');
          emitter(
            MiniAppsEngineLoadingState(
              progress: progress.toStringAsFixed(1),
            ),
          );
          print('name: ${zipEntry.name}');
          print('isDirectory: ${zipEntry.isDirectory}');
          print(
              'modificationDate: ${zipEntry.modificationDate?.toLocal().toIso8601String()}');
          print('uncompressedSize: ${zipEntry.uncompressedSize}');
          print('compressedSize: ${zipEntry.compressedSize}');
          print('compressionMethod: ${zipEntry.compressionMethod}');
          print('crc: ${zipEntry.crc}');
          return ZipFileOperation.includeItem;
        });
    return "index.html";
  }

  void startLocalHostServer() async {
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      final localhostServer = InAppLocalhostServer(
        port: 43432,
        documentRoot: "$dir/web",
      );
      if (!localhostServer.isRunning()) {
        await localhostServer.start();
        if (defaultTargetPlatform == TargetPlatform.android) {
          await InAppWebViewController.setWebContentsDebuggingEnabled(
              kDebugMode);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
