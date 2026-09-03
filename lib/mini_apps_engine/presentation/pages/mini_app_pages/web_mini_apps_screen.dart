import 'dart:async';
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

  /// Pigeon calls against a torn-down platform view reject their Futures;
  /// ours are fire-and-forget, so without a handler each rejection became an
  /// unhandled zone error billed to telemetry (part of the ~56k/7d wkwebview
  /// channel-error flood). The plugin's constructor-internal calls cannot be
  /// reached from app code — those are covered by the reporting-path filter
  /// (BALADY-3943); this covers every call we own.
  void _quiet(Future<void> future) {
    unawaited(future.catchError((_) {}));
  }

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

    _quiet(controller.setBackgroundColor(Colors.transparent));

    _quiet(controller.setJavaScriptMode(JavaScriptMode.unrestricted));
    _quiet(
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
      ),
    );

    if (clearCache) {
      _quiet(controller.clearCache());
    }

    if (Platform.isAndroid) {
      final androidController = _controller.platform as AndroidWebViewController;
      _quiet(
        androidController.setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            return const GeolocationPermissionsResponse(allow: true, retain: true);
          },
        ),
      );
      _quiet(androidController.setAllowContentAccess(true));
      _quiet(androidController.setAllowFileAccess(true));

      _quiet(androidController.setBackgroundColor(const Color(0x00000000)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final miniAppsEngineBloc = context.watch<MiniAppsEngineBloc>();
    final state = miniAppsEngineBloc.state as MiniAppsEngineLoadedState;

    if (!_initialized) {
      _quiet(_controller.loadRequest(Uri.parse("${state.servicePath}#${state.path}")));
      _controller.addJavaScriptObject(JsBridgeListener(miniAppsEngineBloc: miniAppsEngineBloc, isLoading: _isLoading));
      _initialized = true;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canGoBack = await _controller.canGoBack();
        if (canGoBack) {
          _controller.goBack();
        } else if (context.mounted) {
          Navigator.of(context).maybePop();
        }
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
    try {
      // dsbridge's dispose drops a removeJavaScriptChannel Future on the
      // floor; if the platform view is already gone it rejects into the zone.
      _controller.dispose();
    } catch (_) {}
    _isLoading.dispose();
    super.dispose();
  }
}
