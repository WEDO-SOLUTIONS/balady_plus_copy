import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class GaussianSplattingPage extends ConsumerWidget {
  const GaussianSplattingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _GaussianSplattingPageWidget(ref: ref);
  }
}

class _GaussianSplattingPageWidget extends StatefulWidget {
  final WidgetRef ref;

  const _GaussianSplattingPageWidget({required this.ref});

  @override
  State<_GaussianSplattingPageWidget> createState() =>
      _GaussianSplattingPageWidgetState();
}

class _GaussianSplattingPageWidgetState
    extends State<_GaussianSplattingPageWidget> {
  late final WebViewController _controller;
  bool _isLoading = true;

  String _getVirtualTourUrl() {
    final language = widget.ref.read(appLanguageProvider);
    final pilgrimFeature = widget.ref.read(showPilgrimFeatureProvider);
    final baseUrl = pilgrimFeature?.url ?? 'https://pilgrim.thedatum.ai/kaaba';
    return '$baseUrl?lang=${language.baladyCompat}';
  }

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) {
                // Mute all audio/video elements
                _controller.runJavaScript('''
                  document.querySelectorAll('video, audio').forEach(function(el) {
                    el.muted = true;
                    el.volume = 0;
                  });
                  // Also mute any future media elements
                  var observer = new MutationObserver(function(mutations) {
                    document.querySelectorAll('video, audio').forEach(function(el) {
                      el.muted = true;
                      el.volume = 0;
                    });
                  });
                  observer.observe(document.body, { childList: true, subtree: true });
                ''');
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              },
              onWebResourceError: (_) {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(_getVirtualTourUrl()));
  }

  @override
  void dispose() {
    // Stop any playing media by loading an empty page before disposing
    _controller.loadRequest(Uri.parse('about:blank'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.backgroundSurface4,
    body: Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => context.router.maybePop(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        'Balady',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
