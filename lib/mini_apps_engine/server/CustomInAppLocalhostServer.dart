import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'MimeTypeResolver.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

class CustomInAppLocalhostServer {
  bool _started = false;
  HttpServer? _server;
  int _port = 8080;
  bool _shared = false;
  String _directoryIndex = 'index.html';
  String _documentRoot = './';

  CustomInAppLocalhostServer(PlatformInAppLocalhostServerCreationParams params) {
    _port = params.port;
    _directoryIndex = params.directoryIndex;
    _documentRoot = (params.documentRoot.endsWith('/')) ? params.documentRoot : '${params.documentRoot}/';
    _shared = params.shared;
  }

  int get port => _port;

  String get directoryIndex => _directoryIndex;

  String get documentRoot => _documentRoot;

  bool get shared => _shared;

  Future<void> start() async {
    try {
      if (_started) {
        throw Exception('Server already started on http://localhost:$_port');
      }
      _started = true;

      final handler = const Pipeline().addHandler((Request request) async {
        if (request.method == 'OPTIONS') {
          final corsHeaders = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
          };
          return Response.ok('', headers: corsHeaders);
        }
        // Proxy request to target server
        final targetUrl = request.requestedUri;

        try {
          if (targetUrl.origin.toString().contains("localhost") == true &&
              request.url.queryParameters['url'] == null &&
              request.url.queryParameters['zip'] == null) {
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
                final file = File(Uri.decodeFull(path));
                body = await file.readAsBytes();
              } else {
                body = (await rootBundle.load(Uri.decodeFull(path))).buffer.asUint8List();
              }
            } catch (e) {
              return Response.badRequest(body: 'can not load url');
            }

            // var contentType = ContentType('text', 'html', charset: 'utf-8');

            String content = "text/html";
            if (!request.requestedUri.path.endsWith('/') && request.requestedUri.pathSegments.isNotEmpty) {
              final mimeType = MimeTypeResolver.lookup(request.requestedUri.path);
              if (mimeType != null) {
                // contentType = _getContentTypeFromMimeType(mimeType);
                content = _getContentTypeFromMimeType(mimeType);
              }
            }

            final corsHeaders = {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers': '*',
              "Content-Type": content,
            };
            return Response.ok(body, headers: corsHeaders);
          } else {
            var requestUrl = request.url.queryParameters['url'];
            // requestUrl ??= request.url.queryParameters['zip'];
            final client = HttpClient();
            final proxyRequest = await client.getUrl(Uri.parse(requestUrl!));
            final proxyResponse = await proxyRequest.close();
            final corsHeaders = {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers': '*',
            };
            return Response.ok(proxyResponse, headers: corsHeaders);
          }
        } catch (e) {
          return Response.internalServerError(body: 'Error: $e');
        }
      });

      try {
        final server = await io.serve(handler, '127.0.0.1', _port, shared: _shared);

        _started = true;
        _server = server;
        debugPrint('✅ Server successfully started on http://localhost:$_port');
      } on SocketException catch (e) {
        // Port is already in use
        _started = false;
        debugPrint('❌ Port $_port is already in use!');
        debugPrint('Error details: ${e.message}');

        // Rethrow so calling code can handle it
        throw Exception('Failed to start server: Port $_port is already in use. ${e.message}');
      }
    } catch (e) {
      _started = false;
      debugPrint('❌ Failed to start server: ${e.toString()}');
      rethrow; // Rethrow to let calling code handle it
    }
  }

  ///flutter: Server running on http://localhost:8080 closed

  Future<void> close() async {
    if (_server == null) {
      return;
    }
    await _server!.close(force: true);
    debugPrint('Server running on http://localhost:$_port closed');
    _started = false;
    _server = null;
  }

  bool isRunning() {
    return _server != null && _started == true;
  }

  String _getContentTypeFromMimeType(String mimeType) {
    final contentType = mimeType.split('/');
    String? charset;

    if (_isTextFile(mimeType)) {
      charset = 'utf-8';
      return "${contentType[0]}/${contentType[1]};$charset";
    } else {
      return "${contentType[0]}/${contentType[1]}";
    }

    //return ContentType(contentType[0], contentType[1], charset: charset);
  }

  bool _isTextFile(String mimeType) {
    final textFile = RegExp(r'^text\/|^application\/(javascript|json)');
    return textFile.hasMatch(mimeType);
  }
}
