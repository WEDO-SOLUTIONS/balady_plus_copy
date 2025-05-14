import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'MimeTypeResolver.dart';

class CustomInAppLocalhostServer extends PlatformInAppLocalhostServer {

  bool _started = false;
  HttpServer? _server;
  int _port = 8080;
  bool _shared = false;
  String _directoryIndex = 'index.html';
  String _documentRoot = './';

  CustomInAppLocalhostServer(PlatformInAppLocalhostServerCreationParams params)
      : super.implementation(
    params is DefaultInAppLocalhostServerCreationParams
        ? params
        : DefaultInAppLocalhostServerCreationParams
        .fromPlatformInAppLocalhostServerCreationParams(params),
  ) {
    this._port = params.port;
    this._directoryIndex = params.directoryIndex;
    this._documentRoot = (params.documentRoot.endsWith('/'))
        ? params.documentRoot
        : '${params.documentRoot}/';
    this._shared = params.shared;
  }

  @override
  int get port => _port;

  @override
  String get directoryIndex => _directoryIndex;

  @override
  String get documentRoot => _documentRoot;

  @override
  bool get shared => _shared;

  @override
  Future<void> start() async {
    if (this._started) {
      throw Exception('Server already started on http://localhost:$_port');
    }
    this._started = true;

    final completer = Completer();

    runZonedGuarded(() {
      HttpServer.bind('127.0.0.1', _port, shared: _shared).then((server) {
        print('Server running on http://localhost:' + _port.toString());

        this._server = server;

        server.listen((HttpRequest request) async {
          Uint8List body = Uint8List(0);

          var path = request.requestedUri.path;
          path = (path.startsWith('/')) ? path.substring(1) : path;
          path += (path.endsWith('/')) ? _directoryIndex : '';
          if (path == '') {
            // if the path still empty, try to load the index file
            path = _directoryIndex;
          }
          path = _documentRoot + path;

          try {
            if (Platform.isAndroid) {

              final file =  File(Uri.decodeFull(path));
              body = await file.readAsBytes();
            }
            else {
              body = (await rootBundle.load(Uri.decodeFull(path)))
                  .buffer
                  .asUint8List();
            }

          } catch (e) {
            print(Uri.decodeFull(path));
            print(e.toString());
            request.response.close();
            return;
          }

          var contentType = ContentType('text', 'html', charset: 'utf-8');
          if (!request.requestedUri.path.endsWith('/') &&
              request.requestedUri.pathSegments.isNotEmpty) {
            final mimeType = MimeTypeResolver.lookup(request.requestedUri.path);
            if (mimeType != null) {
              contentType = _getContentTypeFromMimeType(mimeType);
            }
          }

          request.response.headers.contentType = contentType;
          request.response.headers.add("Access-Control-Allow-Origin", "*");
          request.response.headers.add("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
          request.response.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
          request.response.add(body);
          request.response.close();
        });

        completer.complete();
      });
    }, (e, stackTrace) => print('Error: $e $stackTrace'));

    return completer.future;
  }

  @override
  Future<void> close() async {
    if (this._server == null) {
      return;
    }
    await this._server!.close(force: true);
    print('Server running on http://localhost:$_port closed');
    this._started = false;
    this._server = null;
  }

  @override
  bool isRunning() {
    return this._server != null;
  }

  ContentType _getContentTypeFromMimeType(String mimeType) {
    final contentType = mimeType.split('/');
    String? charset;

    if (_isTextFile(mimeType)) {
      charset = 'utf-8';
    }

    return ContentType(contentType[0], contentType[1], charset: charset);
  }

  bool _isTextFile(String mimeType) {
    final textFile = RegExp(r'^text\/|^application\/(javascript|json)');
    return textFile.hasMatch(mimeType);
  }


}