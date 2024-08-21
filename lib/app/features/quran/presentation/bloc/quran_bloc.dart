import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/quran/data/models/quran_sura_model.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

import '../../../../core/services/local/shared_prefs_manager.dart';
import '../../data/models/quran_aya_model.dart';
import '../../data/models/quran_book_mark_item_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'quran_event.dart';

part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  PageController controller = PageController(viewportFraction: 0.98);
  late Directory appDocumentsDirectory;

  QuranBloc({required int initialSuraNo})
      : super(QuranState(currentPageValue: initialSuraNo)) {
    on<QuranEvent>((event, emit) {});

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    on<initQuranEvent>(_initQuran);
    on<ChangePageEvent>(_getTitle);
    on<ToggleDetailsEvent>(_toggleDetailsEvent);
    on<MoveToPageEvent>(_moveToPageEvent);
    on<SaveBookMarkEvent>(_saveBookMarkEvent);

    add(initQuranEvent());
  }

  Future<void> _moveToPageEvent(MoveToPageEvent e, Emitter emitter) async {
    controller.jumpToPage(e.page - 1);
    ChangePageEvent(page: e.page - 1);
    add(ToggleDetailsEvent());
  }

  Future<void> _saveBookMarkEvent(SaveBookMarkEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    bool isAdded = await sharedPrefs.saveQuranBookMark(QuranBookMarkItemModel(
        pageNumber: state.currentPageValue + 1,
        suraName: state.currentTitle ?? "",
        suraNo: state.currentSuraNo ?? 0));

    emitter(state.copyWith(showBookMark: isAdded, status: BlocStatus.success));
  }

  Future<void> _toggleDetailsEvent(
      ToggleDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(showDetails: !(state.showDetails ?? false)));
  }

  Future<File?> downloadQuran(Emitter emitter) async {
    var tempDir = await getTemporaryDirectory();
    String fullPath = "${tempDir.path}/quran.zip'";
    File file = File(fullPath);
    if (await file.exists()) {
      return file;
    } else {
      WebService webService = sl();
      try {
        Response response = await webService.dio.get(
          '${RemoteConfig.baladyBaseUrl}/${ApiUrl.quranUrlDownload}',
          onReceiveProgress: (received, total) {
            if (total != -1) {
              emitter(
                state.copyWith(
                  status: BlocStatus.loading,
                  progressDownload: (received / total * 100).toInt(),
                ),
              );
            }
          },
          //Received data with List<int>
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return (status ?? 501) < 500;
              }),
        );
        print(response.headers);
        File file = File(fullPath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        raf.writeFromSync(response.data);
        await raf.close();
        return file;
      } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
        print(error);
      }
      return null;
    }
  }

  Future<void> unzipArchive(Emitter emitter) async {
    File? file = await downloadQuran(emitter);
    // ByteData data = await rootBundle.load('assets/quran/data2.zip');
    // List<int> bytes = data.buffer.asUint8List();
    List<int> bytes = await file!.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    try {
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          final outputFile =
              await File("${appDocumentsDirectory.path}/$filename")
                  .create(recursive: true, exclusive: true);
          await outputFile.writeAsBytes(data);
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

  File getImagePath(String pageNumper) {
    return File(
        '${appDocumentsDirectory.path}/data2/${pageNumper.padLeft(3, "0")}___Hafs39__DM-01.svg');
  }

  Future<void> _initQuran(initQuranEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    await Permission.storage.request();
    appDocumentsDirectory = await getTemporaryDirectory();

    String quran =
        await rootBundle.loadString("assets/quran/hafs_smart_v8.json");
    await unzipArchive(emitter);
    var r = json.decode(quran);
    emitter(state.copyWith(status: BlocStatus.success));

    List<QuranAyaModel> quranAyat =
        List<QuranAyaModel>.from(r.map((x) => QuranAyaModel.fromMap(x)));

    Map<int, List<QuranAyaModel>> pages = {};
    Map<int, String> sura = {};

    Map<int, String>? pagesStr = {};

    Map<int, List<QuranSuraModel>>? suras = {};

    pages = {};
    quranAyat.forEach((element) {
      if (pages.containsKey(element.page)) {
        pages[element.page]!.add(element);
      } else {
        pages[element.page] = [element];
      }
    });

    quranAyat.forEach((element) {
      if (!sura.containsKey(element.suraNo)) {
        sura[element.suraNo] = element.suraNameAr;
      }
    });

    Map<int, Map<int, QuranSuraModel>>? pagesSuras = {};

    pages.forEach((key, value) {
      Map<int, QuranSuraModel> surasInPage = {};
      pagesSuras[key] = surasInPage;
      int i = 0;
      int oldI = i;
      value.forEachIndexed(
        (index, element) {
          if (element.ayaNo == 1 || element.lineStart == 1) i++;

          if (!surasInPage.containsKey(i)) {
            surasInPage[i] = QuranSuraModel(
                jozz: element.jozz,
                suraName: element.suraNameAr,
                suraNo: element.suraNo,
                suraAyat: [
                  {element.ayaNo: element.ayaText}
                ],
                suraAyatNormal: [
                  {element.ayaNo: element.ayaTextEmlaey}
                ]);
          } else {
            surasInPage[i]!.suraAyat.add({element.ayaNo: element.ayaText});
            surasInPage[i]!
                .suraAyatNormal
                .add({element.ayaNo: element.ayaTextEmlaey});
          }
        },
      );

      pagesSuras[key] = surasInPage;
    });

    emitter(state.copyWith(
        pages: pages,
        pagesStr: pagesStr,
        quranAyat: quranAyat,
        suraIndex: sura,
        suras: pagesSuras));

    controller.jumpToPage(getSuraPageNumber(state.currentPageValue + 1));

    add(ChangePageEvent(page: getSuraPageNumber(state.currentPageValue + 1)));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.performing) return;
    int nextPage = state.currentPageValue + 1;
    if (nextPage < 0 || nextPage > 604) return;

    emitter(state.copyWith(
      status: BlocStatus.performing,
    ));

    //  controller.jumpToPage(nextPage);

    await controller.animateToPage(nextPage,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);

    emitter(
        state.copyWith(status: BlocStatus.success, currentPageValue: nextPage));
    ChangePageEvent(page: nextPage);

    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    int prvoiusPage = state.currentPageValue - 1;
    if (prvoiusPage < 0 || prvoiusPage > 604) return;
    emitter(state.copyWith(
      status: BlocStatus.performing,
    ));

    await controller.animateToPage(prvoiusPage,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);

    emitter(state.copyWith(
        status: BlocStatus.success, currentPageValue: prvoiusPage));

    ChangePageEvent(page: prvoiusPage);
    hideKeyboard();
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _getTitle(ChangePageEvent e, Emitter emitter) async {
    try {
      int currentPage = e.page ?? 0;
      String suraName = "";
      state.suras?[currentPage + 1]?.values.forEachIndexed((index, element) {
        suraName =
            state.suras?[currentPage + 1]?.values.toList()[index].suraName ??
                "";

        if (element.suraName != suraName) suraName = element.suraName;
        emitter(state.copyWith(
            currentTitle: suraName,
            currentJozz: element.jozz,
            currentSuraNo: element.suraNo,
            currentPageValue: currentPage));
      });

      bool isMarked = await sharedPrefs.checkBookMark(QuranBookMarkItemModel(
          pageNumber: state.currentPageValue + 1,
          suraName: state.currentTitle ?? "",
          suraNo: state.currentSuraNo ?? 0));

      emitter(state.copyWith(showBookMark: isMarked));
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

  int getSuraPageNumber(int suraNumber) {
    int pageNo = -1;
    state.pages?.forEach((key, value) {
      QuranAyaModel? model =
          value.firstWhereOrNull((element) => element.suraNo == suraNumber);
      if (model != null && pageNo == -1) {
        pageNo = model.page;
      }
    });
    return pageNo - 1;
  }

  int getJozzPageNumber(int jozz) {
    int pageNo = -1;
    state.pages?.forEach((key, value) {
      QuranAyaModel? model =
          value.firstWhereOrNull((element) => element.jozz == jozz);
      if (model != null && pageNo == -1) {
        pageNo = model.page;
      }
    });
    return pageNo - 1;
  }
}
