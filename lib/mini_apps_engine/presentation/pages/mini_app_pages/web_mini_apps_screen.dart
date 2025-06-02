import 'dart:io';
import 'package:balady_plus/super_app_js_bridge/js_bridge_listener.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/core/services/local/navigation_services.dart';
import '../../../../app/core/utils/common_functions.dart';
import '../../../../app/features/_shared_feature_/presentation/dialogs/camera_permission_dialog.dart';
import '../../../../app/features/_shared_feature_/presentation/dialogs/location_permission_dialog.dart';
import '../../../../app/features/_shared_feature_/presentation/dialogs/location_service_dialog.dart';

class WebMiniAppsScreen extends StatefulWidget {
  String servicePath;

  WebMiniAppsScreen({super.key, required this.servicePath});

  @override
  State<WebMiniAppsScreen> createState() => _WebMiniAppsScreenState();
}

class _WebMiniAppsScreenState extends State<WebMiniAppsScreen> {
  late final DWebViewController _controller;
  bool _isLoading = true;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    if (widget.servicePath.contains("index.html")) {
      // #docregion platform_features
      late final PlatformWebViewControllerCreationParams params;
      // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      //   params = WebKitWebViewControllerCreationParams(
      //     allowsInlineMediaPlayback: true,
      //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      //
      //   );
      // } else {
      params = const PlatformWebViewControllerCreationParams();
      // }
      final DWebViewController controller =
          DWebViewController.fromPlatformCreationParams(
        params,
        onPermissionRequest: (request) {
          try{
            request.grant();
          }catch(e){
            print(e);
          }
        },
      );
      _controller = controller;

      controller
        ..setBackgroundColor(Colors.white)
        ..clearCache()
        ..loadRequest(Uri.parse(widget.servicePath))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptObject(JsBridgeListener())
        ..setNavigationDelegate(NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (url) async {
            // setState(() {
            //   _isLoading = true;
            // });
            await CommonFunctions.checkCameraSettings(
              NavigationService.navigatorKey.currentContext!,
            );
          },
          onPageFinished: (url) {
            // setState(() {
            //   _isLoading = false;
            // });
            _injectPermissionHandlingScript();
          },
          onWebResourceError: (WebResourceError error) {
          setState(() {
            _isLoading = false;
          });
          },
        ));

      _injectPermissionHandlingScript();

      if (Platform.isAndroid) {
        (_controller.platform as AndroidWebViewController)
            .setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            // Handle permission request
            return const GeolocationPermissionsResponse(
              allow: true, // Or implement your own permission logic
              retain: true,
            );
          },
        );

        (_controller.platform as AndroidWebViewController)
            .setAllowContentAccess(true);
        (_controller.platform as AndroidWebViewController)
            .setAllowFileAccess(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // return   InAppWebView(
    //   initialSettings: InAppWebViewSettings(
    //     useHybridComposition: true,
    //     javaScriptEnabled: true,
    //     useShouldOverrideUrlLoading: true,
    //   ),
    //   shouldOverrideUrlLoading: (controller, action) async {
    //     return NavigationActionPolicy.ALLOW;
    //   },
    //   onWebViewCreated: (InAppWebViewController controller) {
    //     // _controller = controller;
    //   },
    //   initialUrlRequest: URLRequest(
    //     // url: Uri.parse('https://flutter.dev/'),
    //     url: WebUri(widget.servicePath),
    //   ),
    // );
    return DWebViewWidget(controller: _controller);
    return Stack(children: [
      DWebViewWidget(controller: _controller),
      if (_isLoading)
        Column(
          children: [
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
    ]);
  }

  void _injectPermissionHandlingScript() {
    _controller.runJavaScript('''
      // This helps some websites recognize permissions are granted
      navigator.mediaDevices.getUserMedia =
        navigator.mediaDevices.getUserMedia ||
        navigator.webkitGetUserMedia ||
        navigator.mozGetUserMedia;
    ''');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
