import 'dart:io';

import 'package:balady_plus/super_app_js_bridge/js_bridge_listener.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


class WebMiniAppsScreen extends StatefulWidget {
  String servicePath;

  WebMiniAppsScreen({super.key,required this.servicePath});

  @override
  State<WebMiniAppsScreen> createState() => _WebMiniAppsScreenState();
}

class _WebMiniAppsScreenState extends State<WebMiniAppsScreen> {
  late final DWebViewController _controller;

  @override
  void initState() {
    super.initState();
    if(widget.servicePath.contains("index.html")) {
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


      controller
        ..setBackgroundColor(Colors.white)
        ..loadRequest(Uri.parse(widget.servicePath))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptObject(JsBridgeListener())
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
  }

  @override
  Widget build(BuildContext context) {

   return  DWebViewWidget(controller: _controller);
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}