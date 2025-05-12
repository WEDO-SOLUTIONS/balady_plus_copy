import 'dart:io';

import 'package:archive/archive.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class FileDownloaderAndExtractor {


  static final FileDownloaderAndExtractor _singleton = FileDownloaderAndExtractor._internal();
  FileDownloaderAndExtractor._internal();
  factory FileDownloaderAndExtractor() {
    return _singleton;
  }







  Future<void> startDownlaod(String downloaderURl, String zipFileName,Function(String? indexFilePath) callBack) async {

      var zippedFile = await _downloadFile(downloaderURl, "$zipFileName.zip");
      if (zippedFile != null) {
       String indexFilePath= await unarchiveAndSave(zippedFile);

        if (indexFilePath.isNotEmpty) {
          callBack(indexFilePath);
        }
        else
          {
            callBack(null);
          }
      }


  }
  Future<File?> _downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    if(req.statusCode==200) {

      String serverPath="${(await getApplicationDocumentsDirectory()).path}/www";
      var file = File('$serverPath/$fileName');

      return file.writeAsBytes(req.bodyBytes);
    }
    return null;
  }

  unarchiveAndSave(var zippedFile) async {

    String indexFilePath="";
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    try {

      for (var file in archive) {

        var fileName = '${CommonProperties.serverRootPath}/${file.name}';

        if (file.isFile && !fileName.contains("__MACOSX")) {
          var outFile = File(fileName);

          if (fileName.contains("index.html")) {
            indexFilePath = outFile.path.replaceAll(CommonProperties.serverRootPath!, "http://localhost:8080");

          }

          outFile = await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content);
        }
      }


    }
    catch(e)
    {

    }

    return indexFilePath;
  }



}