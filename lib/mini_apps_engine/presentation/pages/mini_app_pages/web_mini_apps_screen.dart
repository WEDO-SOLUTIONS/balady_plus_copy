import 'dart:io';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:balady_plus/super_app_js_bridge/js_bridge_listener.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebMiniAppsScreen extends StatefulWidget {
  const WebMiniAppsScreen({super.key});

  @override
  State<WebMiniAppsScreen> createState() => _WebMiniAppsScreenState();
}

class _WebMiniAppsScreenState extends State<WebMiniAppsScreen> {
  late final DWebViewController _controller;
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);

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
        DWebViewController.fromPlatformCreationParams(params);
    _controller = controller;


    controller
      ..setBackgroundColor(Colors.white)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          print("onProgress : $progress");
        },
        onPageStarted: (url) async {
          print("onPageStarted");
          _injectPermissionHandlingScript();
        },
        onPageFinished: (url) {
          print("onPageFinished");
          _injectPermissionHandlingScript();
        },
        onWebResourceError: (WebResourceError error) {},
      ));

    // MiniAppsEngineBloc miniAppsEngineBloc = context.watch<MiniAppsEngineBloc>();
    // if(miniAppsEngineBloc.miniApp.latestVersion?.serviceUrl != null) {
    //   controller.clearCache();
    // }

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
    MiniAppsEngineBloc miniAppsEngineBloc = context.watch<MiniAppsEngineBloc>();
    MiniAppsEngineLoadedState state =
        miniAppsEngineBloc.state as MiniAppsEngineLoadedState;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        bool canGoBack = await _controller.canGoBack();
        if (canGoBack) {
          await _controller.goBack();
          return;
        } else {
          Navigator.of(context).pop();
        }
      },
      // onPopInvoked: (didPop) async {
      //   bool canGoBack = await _controller.canGoBack();
      //   if (canGoBack) {
      //     await _controller.goBack();
      //   } else {
      //     Navigator.of(context).pop();
      //   }
      //
      // },
      child: Stack(
        children: [
          //DWebViewWidget
          DWebViewWidget(
            controller: _controller
              ..loadRequest(Uri.parse(state.servicePath))
              ..addJavaScriptObject(
                JsBridgeListener(
                  miniAppsEngineBloc: miniAppsEngineBloc,
                  isLoading: _isLoading,
                ),
              ),
          ),

          /// When Open Url From Sevrver Side Not Show Loading Indicator
          miniAppsEngineBloc.miniApp.latestVersion?.serviceUrl == null
              ? ValueListenableBuilder(
                  valueListenable: _isLoading,
                  builder: (context, value, _) {
                    return value
                        ? Container(
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.white,
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  "service_will_available_shortly".tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                )
              : const SizedBox(),
        ],
      ),
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
    _controller.dispose();
    _isLoading.dispose();
    super.dispose();
  }
}
