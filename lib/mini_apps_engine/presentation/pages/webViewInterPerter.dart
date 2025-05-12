
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:dsbridge_flutter/dsbridge_flutter.dart';

import '../../../super_app_js_bridge/js_bridge_listener.dart';
class WebviewInterperter extends StatefulWidget {
  String servicePath;

   WebviewInterperter({super.key,required this.servicePath});

  @override
  State<WebviewInterperter> createState() => _WebviewInterperterState();
}

class _WebviewInterperterState extends State<WebviewInterperter> {
  late final DWebViewController _controller;

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,

        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final DWebViewController controller =
    DWebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setBackgroundColor(Colors.white)

     ..loadRequest(Uri.parse(widget.servicePath))
      ..addJavaScriptObject(JsBridgeListener())
      //..clearCache()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

      ..disableJavaScriptDialogBlock(true)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          print('process=$progress');
        },
        onPageStarted: (url) {
          print('url onPageStarted');
        },
        onPageFinished: (url) {
          print('url onPageFinished');
        },
      ));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('mini Apps viewer'),
      ),
      body: DWebViewWidget(controller: _controller),
      // floatingActionButton: favoriteButton(),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
