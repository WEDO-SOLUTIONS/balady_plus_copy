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

//!
class WebMiniAppsScreen extends ConsumerStatefulWidget {
  const WebMiniAppsScreen({super.key});

  @override
  ConsumerState<WebMiniAppsScreen> createState() => _WebMiniAppsScreenState();
}

class _WebMiniAppsScreenState extends ConsumerState<WebMiniAppsScreen> {
  late final DWebViewController _controller;
  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  bool _initialized = false; // prevent multiple re-inits

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
      ref.read(appLanguageProvider.notifier).updateCachedMiniAppsLanguage(_currentLanguage);
    }

    late final PlatformWebViewControllerCreationParams params;
    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,
      mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    );

    final DWebViewController controller = DWebViewController.fromPlatformCreationParams(params);
    _controller = controller;

    controller.setBackgroundColor(Colors.transparent);

    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          _isLoading.value = true;
        },
        onPageFinished: (url) async {
          try {
            await controller.runJavaScriptReturningResult("""
            new Promise(resolve => {
              if (document.readyState === 'complete') {
                resolve(true);
              } else {
                window.addEventListener('load', () => resolve(true));
              }
            });
          """);
          } catch (_) {}
          _isLoading.value = false;
        },
        onWebResourceError: (_) {
          _isLoading.value = false;
        },
      ),
    );

    if (clearCache) {
      controller.clearCache();
    }

    if (Platform.isAndroid) {
      final androidController = _controller.platform as AndroidWebViewController;
      androidController.setGeolocationPermissionsPromptCallbacks(
        onShowPrompt: (request) async {
          return const GeolocationPermissionsResponse(allow: true, retain: true);
        },
      );
      androidController.setAllowContentAccess(true);
      androidController.setAllowFileAccess(true);

      androidController.setBackgroundColor(const Color(0x00000000));
    }
  }

  @override
  Widget build(BuildContext context) {
    final miniAppsEngineBloc = context.watch<MiniAppsEngineBloc>();
    final state = miniAppsEngineBloc.state as MiniAppsEngineLoadedState;

    if (!_initialized) {
      _controller
        ..loadRequest(Uri.parse("${state.servicePath}#${state.path}"))
        ..addJavaScriptObject(JsBridgeListener(miniAppsEngineBloc: miniAppsEngineBloc, isLoading: _isLoading));
      _initialized = true;
    }

    return PopScope(
      // Back first walks the web view's own history; only when it has none left
      // does the route itself go. `canGoBack` is async, so the decision cannot
      // be made in `canPop` - the route is held and popped by hand instead.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        // Resolved before the await: `context` here is the build parameter, not
        // `State.context`, so a `mounted` check afterwards would not cover it.
        final navigator = Navigator.of(context);
        if (await _controller.canGoBack()) {
          await _controller.goBack();
          return;
        }
        navigator.pop();
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (context, isLoading, child) {
          return Visibility(
            visible: !isLoading,
            child: DWebViewWidget(controller: _controller),
          );
        },
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
