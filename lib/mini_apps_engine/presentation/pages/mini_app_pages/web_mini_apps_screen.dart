import 'dart:io';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_state.dart';
import 'package:balady_plus/super_app_js_bridge/js_bridge_listener.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/shared/providers/app_language.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebMiniAppsScreen extends ConsumerStatefulWidget {
  const WebMiniAppsScreen({super.key});

  @override
  ConsumerState<WebMiniAppsScreen> createState() => _WebMiniAppsScreenState();
}

class _WebMiniAppsScreenState extends ConsumerState<WebMiniAppsScreen> {
  late final DWebViewController _controller;
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);

  String _currentLanguage = '';
  String? _cachedMiniAppsLanguage = '';

  @override
  void initState() {
    super.initState();
    bool clearCache = false;

    _currentLanguage = translator.activeLanguageCode;
    _cachedMiniAppsLanguage = ref.read(appLanguageProvider.notifier).getCachedMiniAppsLanguage();

    if (_currentLanguage != _cachedMiniAppsLanguage) {
      clearCache = true;

      ref.read(appLanguageProvider.notifier).updateCachedMiniAppsLanguage(
        _currentLanguage,
      );
    }
    late final PlatformWebViewControllerCreationParams params;
    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,
      mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    );
    final DWebViewController controller = DWebViewController.fromPlatformCreationParams(params);
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
        },
        onPageFinished: (url) {
          print("onPageFinished");
        },
        onWebResourceError: (WebResourceError error) {},
      ));

    if (clearCache) {
      controller.clearCache();
    }

    if (Platform.isAndroid) {
      (_controller.platform as AndroidWebViewController).setGeolocationPermissionsPromptCallbacks(
        onShowPrompt: (request) async {
          return const GeolocationPermissionsResponse(allow: true, retain: true);
        },
      );

      (_controller.platform as AndroidWebViewController).setAllowContentAccess(true);
      (_controller.platform as AndroidWebViewController).setAllowFileAccess(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    MiniAppsEngineBloc miniAppsEngineBloc = context.watch<MiniAppsEngineBloc>();
    MiniAppsEngineLoadedState state = miniAppsEngineBloc.state as MiniAppsEngineLoadedState;
    return WillPopScope(
      onWillPop: () async {
        bool canPop = await _controller.canGoBack();
        return !canPop;
      },
      child: DWebViewWidget(
        controller: _controller
        //https://baladyapps.momra.gov.sa/tawakkalna/baladyplus
        //https://services-dev.balady.gov.sa/miniapps/municipal
          ..loadRequest(Uri.parse(state.servicePath))
          ..addJavaScriptObject(
            JsBridgeListener(
              miniAppsEngineBloc: miniAppsEngineBloc,
              isLoading: _isLoading,
            ),
          ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _isLoading.dispose();
    super.dispose();
  }
}