import 'dart:io';
import 'package:balady_plus/super_app_js_bridge/js_bridge_listener.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../../../app/core/services/local/navigation_services.dart';
import '../../../../app/core/utils/common_functions.dart';

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

    // _controller = WebViewController()
    //   ..loadRequest(Uri.parse(widget.servicePath))
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(Colors.white)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onPageStarted: (url) {
    //         print("onPageStarted");
    //         setState(() {
    //           _isLoading = true;
    //         });
    //       },
    //       onPageFinished: (url) {
    //         print("onPageFinished");
    //         setState(() {
    //           _isLoading = false;
    //         });
    //       },
    //       onWebResourceError: (error) {
    //         print("onWebResourceError");
    //         setState(() {
    //           _isLoading = false;
    //         });
    //       },
    //     ),
    //   );

    // if (widget.servicePath.contains("index.html")) {
      // #docregion platform_features
      late final PlatformWebViewControllerCreationParams params;
      // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      // } else {
      //   params = const PlatformWebViewControllerCreationParams();
      // }
      final DWebViewController controller =
          DWebViewController.fromPlatformCreationParams(
        params,
        onPermissionRequest: (request) {
          try {
            request.grant();
          } catch (e) {
            print(e);
          }
        },
      );
      _controller = controller;

      controller
        ..setBackgroundColor(Colors.white)
        // ..clearCache()
        ..loadRequest(Uri.parse(widget.servicePath))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptObject(JsBridgeListener())
        ..setNavigationDelegate(NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });

            print("onProgress : $_progress");
          },
          onPageStarted: (url) async {
            print("onPageStarted");
            // setState(() {
            //   _isLoading = true;
            // });
            // await CommonFunctions.checkCameraSettings(
            //   NavigationService.navigatorKey.currentContext!,
            // );
            _injectPermissionHandlingScript();
          },
          onPageFinished: (url) {
            print("onPageFinished");
            setState(() {
              _isLoading = false;
            });

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
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[200],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'سيتم فتحه خلال لحظات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _injectPermissionHandlingScript() {
    // _controller.runJavaScript('''
    //   // This helps some websites recognize permissions are granted
    //   navigator.mediaDevices.getUserMedia =
    //     navigator.mediaDevices.getUserMedia ||
    //     navigator.webkitGetUserMedia ||
    //     navigator.mozGetUserMedia;
    // ''');
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }
}
