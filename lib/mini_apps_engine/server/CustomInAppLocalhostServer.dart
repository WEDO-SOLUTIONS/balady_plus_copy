import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'MimeTypeResolver.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

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


    final handler = const Pipeline()
      //  .addMiddleware(_addCorsHeaders as Middleware)
        .addHandler((Request request) async {
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
        if( targetUrl.origin.toString().contains("localhost")==true && request.url.queryParameters['url'] == null&& request.url.queryParameters['zip'] == null) {
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
            }
            else {
              body = (await rootBundle.load(Uri.decodeFull(path)))
                  .buffer
                  .asUint8List();
            }
          } catch (e) {
            return Response.badRequest(
              body: 'can not load url',
            );
          }

         // var contentType = ContentType('text', 'html', charset: 'utf-8');
          String content= "text/html";
          if (!request.requestedUri.path.endsWith('/') &&

              request.requestedUri.pathSegments.isNotEmpty) {
            final mimeType = MimeTypeResolver.lookup(request.requestedUri.path);
            if (mimeType != null) {
             // contentType = _getContentTypeFromMimeType(mimeType);
              content=  _getContentTypeFromMimeType(mimeType);
            }
          }

          final corsHeaders = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',

            "Content-Type": content,
          };
        return  Response.ok(
            body,
            headers: corsHeaders,
          );


        }

        else {


          var requestUrl = request.url.queryParameters['url'];
          requestUrl ??= request.url.queryParameters['zip'];
          final client = HttpClient();
          final proxyRequest = await client.getUrl(Uri.parse(requestUrl!));
          final proxyResponse = await proxyRequest.close();
          final corsHeaders = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
          };
          return Response.ok(
            proxyResponse,
            headers: corsHeaders,
          );
        }

      } catch (e) {
        return Response.internalServerError(body: 'Error: $e');
      }
    });


    final server = await io.serve(handler, '127.0.0.1', _port, shared: _shared);
    this._server = server;

    // runZonedGuarded(() {
    //  // HttpServer.bind('127.0.0.1', _port, shared: _shared).then((server) {
    //
    //     this._server = server;
    //
    //     // server.listen((HttpRequest request) async {
    //     //   Uint8List body = Uint8List(0);
    //     //   var path = request.requestedUri.path;
    //     //   path = (path.startsWith('/')) ? path.substring(1) : path;
    //     //   path += (path.endsWith('/')) ? _directoryIndex : '';
    //     //   if (path == '') {
    //     //     // if the path still empty, try to load the index file
    //     //     path = _directoryIndex;
    //     //   }
    //     //   path = _documentRoot + path;
    //     //
    //     //   try {
    //     //     if (Platform.isAndroid) {
    //     //
    //     //       final file =  File(Uri.decodeFull(path));
    //     //       body = await file.readAsBytes();
    //     //     }
    //     //     else {
    //     //       body = (await rootBundle.load(Uri.decodeFull(path)))
    //     //           .buffer
    //     //           .asUint8List();
    //     //     }
    //     //
    //     //   } catch (e) {
    //     //     print(Uri.decodeFull(path));
    //     //     print(e.toString());
    //     //     request.response.close();
    //     //     return;
    //     //   }
    //     //
    //     //   var contentType = ContentType('text', 'html', charset: 'utf-8');
    //     //   if (!request.requestedUri.path.endsWith('/') &&
    //     //       request.requestedUri.pathSegments.isNotEmpty) {
    //     //     final mimeType = MimeTypeResolver.lookup(request.requestedUri.path);
    //     //     if (mimeType != null) {
    //     //       contentType = _getContentTypeFromMimeType(mimeType);
    //     //     }
    //     //   }
    //     //   request.response.headers.contentType = contentType;
    //     //  // await _proxyRequest(request);
    //     //   request.response.add(body);
    //     //   request.response.close();
    //     //
    //     // });
    //
    //
    //   //  completer.complete();
    //  // });
    // }, (e, stackTrace) => print('Error: $e $stackTrace'));

   // return completer.future;
  }


  Middleware _addCorsHeaders() {
    return (Handler innerHandler) {
      return (Request request) async {
        // Handle OPTIONS preflight request
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: _corsHeaders);
        }

        // Process the request
        final response = await innerHandler(request);

        // Add CORS headers to response
        return response.change(headers: _corsHeaders);
      };
    };
  }

// CORS headers
  final _corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': '*',
  };

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

  String _getContentTypeFromMimeType(String mimeType) {
    final contentType = mimeType.split('/');
    String? charset;

    if (_isTextFile(mimeType)) {
      charset = 'utf-8';
      return "${contentType[0]}/${contentType[1]};$charset";
    }
    else {
      return "${contentType[0]}/${contentType[1]}";
    }


    //return ContentType(contentType[0], contentType[1], charset: charset);
  }

  bool _isTextFile(String mimeType) {
    final textFile = RegExp(r'^text\/|^application\/(javascript|json)');
    return textFile.hasMatch(mimeType);
  }





}