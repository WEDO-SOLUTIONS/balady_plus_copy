import 'dart:io';
import 'package:archive/archive.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/domain/use_cases/get_cookie.dart';
import 'package:balady_plus/mini_apps_engine/helper/port_helper.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_event.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:balady_plus/mini_apps_engine/server/CustomInAppLocalhostServer.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

// CustomInAppLocalhostServer? localhostServer;
int portNumber = 8080;

class MiniAppsEngineBloc
    extends Bloc<MiniAppsEngineEvent, MiniAppsEngineState> {
  final MiniApp miniApp;

  CustomInAppLocalhostServer? localhostServer;
  String? serviceDownloadPath;
  late String basePathService;
  ServerSocket? dummyServer;

  // String serverPath;

  MiniAppsEngineBloc({
    required this.miniApp,
  }) //required this.serverPath
      : super(const MiniAppsEngineInitialState()) {
    on<CheckMiniAppsEngineEvent>(_checkMiniAppsEngine);

    on<DownloadMiniAppsEngineEvent>(_downloadMiniAppsEngine);
    on<OpenServerEngineEvent>(_openLocalHostServer);

    add(CheckMiniAppsEngineEvent(miniApp: miniApp));
  }

  String getLocalizedURL(String serviceUrl){
    if(serviceUrl.contains("ewaa")&& CommonFunctions.isAppAR==false) {
      serviceUrl = "$serviceUrl/en/normal_profile";
    }



    return serviceUrl;

  }

  void _checkMiniAppsEngine(
      CheckMiniAppsEngineEvent event, Emitter emit) async {
    if (event.miniApp.latestVersion?.serviceUrl != null) {
      if (event.miniApp.nafathLogin) {
        GetCookie getCookie = GetCookie(repository: sl());
        final failureOrSuccessForCookie = await getCookie(true);
      }
      String serviceUrl= getLocalizedURL(event.miniApp.latestVersion!.serviceUrl!);



      emit(
        MiniAppsEngineLoadedState(
          servicePath: serviceUrl,
          path: event.miniApp.path ?? "",
        ),
      );
    } else {
      basePathService =
      "${(await getApplicationDocumentsDirectory()).path}/www/";
      String dir =
          '$basePathService${event.miniApp.serviceKey}/${event.miniApp.latestVersion!.versionNumber}';
      File file = File('$dir/index.html');
      bool exists = await file.exists();
      if (exists) {
        /// This simulation code is for testing port conflict handling
        // await initDummyServer(miniApp.portNumber ?? generateRandomPort(portNumber, miniApp.name, miniApp.serviceKey));
        add(OpenServerEngineEvent(miniApp: miniApp));
      } else {
        add(DownloadMiniAppsEngineEvent(miniApp: event.miniApp));
      }
    }
    return;
  }

  void _downloadMiniAppsEngine(
      DownloadMiniAppsEngineEvent event, Emitter emit) async {
    emit(const MiniAppsEngineLoadingState(progress: '0'));

    serviceDownloadPath = "$basePathService${event.miniApp.serviceKey}";
    Directory directoryApp = Directory(serviceDownloadPath!);
    bool exists = await directoryApp.exists();
    // chick if have old version of the app delete it
    if (exists) {
      await directoryApp.delete(recursive: true);
      serviceDownloadPath =
      "$serviceDownloadPath/${event.miniApp.latestVersion!.versionNumber}";
      directoryApp = Directory(serviceDownloadPath!);
      await directoryApp.create(recursive: true);
    } else {
      serviceDownloadPath =
      "$serviceDownloadPath/${event.miniApp.latestVersion!.versionNumber}";
      directoryApp = Directory(serviceDownloadPath!);
      await directoryApp.create(recursive: true);
    }
    var zippedFile = await _downloadFile(
      event.miniApp.latestVersion?.packageMetaDataDto?.id ?? "",
      serviceDownloadPath!,
      event.miniApp.serviceKey,
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

  // ============ TEST CODE: Occupy the port first ============
  Future<void> initDummyServer(int portToUse) async {
    try {
      // Start a dummy server on the same port to simulate port conflict
      dummyServer = await ServerSocket.bind('127.0.0.1', portToUse);
      print('🔴 TESTING: Dummy server occupying port $portToUse');

      // Keep it running for a moment to ensure conflict
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print('⚠️ Could not start dummy server: $e');
    }
  }

  void _openLocalHostServer(OpenServerEngineEvent event, Emitter emit) async {
    try {
      if (state is MiniAppsEngineLoadingState) {
        MiniAppsEngineLoadingState tempState =
        state as MiniAppsEngineLoadingState;
        if (!tempState.progress.contains("100")) {
          return;
        }
      }
      String pathService =
          '$basePathService${event.miniApp.serviceKey}/${event.miniApp.latestVersion!.versionNumber}';
      CommonProperties.currentLocalServerDirectory = pathService;

      /// Testing implementation
      // this is fixed port for testing purpose
      // this port is net::ERR_UNSAFE_PORT in webview
      // int portToUse = 5061;

      /// Real implementation
      int portToUse = event.miniApp.portNumber ??
          PortHelper.generateRandomPort(
            portNumber,
            event.miniApp.name,
            event.miniApp.serviceKey,
          );

      if (PortHelper.isPortUnsafe(portToUse)) {
        portToUse = PortHelper.generateRandomPort(
            portToUse, event.miniApp.name, event.miniApp.serviceKey);
      }

      if (localhostServer == null || localhostServer!.port != portToUse) {
        localhostServer = CustomInAppLocalhostServer(
          PlatformInAppLocalhostServerCreationParams(
            documentRoot: pathService,
            port: portToUse,
            shared: true,
          ),
        );
      }

      bool isRunning = localhostServer!.isRunning();
      if (isRunning) {
        await localhostServer?.close();
        await localhostServer!.start();
      } else {
        await localhostServer!.start();
      }

      String servicePath = "http://localhost:${localhostServer!.port}/";

      emit(
        MiniAppsEngineLoadedState(
          servicePath: servicePath,
          path: event.miniApp.path ?? "",
        ),
      );
    } catch (e) {
      // print(e.toString());
      print('Error in _openLocalHostServer: ${e.toString()}');
      add(OpenServerEngineEvent(
          miniApp: event.miniApp.copyWith(
              portNumber: PortHelper.generateRandomPort(
                  portNumber, event.miniApp.name, event.miniApp.serviceKey))));
    }
  }

  Future<File?> _downloadFile(
      String urlDownload,
      String downloadPath,
      String serviceKey,
      Emitter emitter, {
        int retryCounter = 0,
      }) async {
    WebService webService = sl<WebService>();
    try {
      Response response = await webService.dio.get(
        urlDownload,
        // 'https://drive.usercontent.google.com/download?id=1GQPmEossQAHw_Wk-KR1u7lhj-TeXkWAv&export=download',
       // "https://drive.usercontent.google.com/download?id=1C4oR_afe51mlTI2UxaUBHVM-GEh8udKS&export=download&authuser=0&confirm=t&uuid=602fd070-7cf5-42aa-bea7-d02af5b7028b&at=APcXIO3jtBR2vV5JP0-zptBbo-am:1770715929482",
        // "https://drive.usercontent.google.com/download?id=1nC1zR8cuIl6i6uBpvnO-vMKwhj3B0kv0&export=download&authuser=0&confirm=t&uuid=b7976914-b291-4b41-a4b9-38ad1200a404&at=ANTm3czE5Cl5y-4kNQ4TmYFJA97o:1768127493910",
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
    } catch (error) {
      if (retryCounter < 3) {
        // Retry downloading the file up to 3 times
        return _downloadFile(
          urlDownload,
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

  Future<void> unarchiveAndSave(var zippedFile, String extractPath) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    try {
      for (var file in archive) {
        //  var fileName = '$basePathService/${file.name}';
        if (file.isFile && !file.name.contains("__MACOSX")) {
          var outFile = File('$extractPath/${file.name}');
          if (file.name.contains("index.html")) {}
          outFile = await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content);
        }
      }
    } catch (e) {
      print("Test");
    }
  }

  @override
  Future<void> close() async {
    await localhostServer?.close();
    return super.close();
  }
}
