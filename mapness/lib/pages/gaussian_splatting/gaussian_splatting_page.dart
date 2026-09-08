import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class GaussianSplattingPage extends ConsumerWidget {
  const GaussianSplattingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => _GaussianSplattingPageWidget(ref: ref);
}

class _GaussianSplattingPageWidget extends StatefulWidget {
  final WidgetRef ref;

  const _GaussianSplattingPageWidget({required this.ref});

  @override
  State<_GaussianSplattingPageWidget> createState() => _GaussianSplattingPageWidgetState();
}

class _GaussianSplattingPageWidgetState extends State<_GaussianSplattingPageWidget> {
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

    // Track page opened
    Metrics.logEventAdvanced(
      MetricsConstants.kaabaTourKeys.pageOpened,
      group: MetricsConstants.kaabaTourTag,
      props: {'url': _getVirtualTourUrl()},
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            // Track page load completed
            Metrics.logEventAdvanced(
              MetricsConstants.kaabaTourKeys.pageLoadCompleted,
              group: MetricsConstants.kaabaTourTag,
            );
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
          onWebResourceError: (error) {
            // Track page load failed
            Metrics.logEventAdvanced(
              MetricsConstants.kaabaTourKeys.pageLoadFailed,
              group: MetricsConstants.kaabaTourTag,
              props: {'error': error.description},
            );
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
    // Track page closed
    Metrics.logEventAdvanced(
      MetricsConstants.kaabaTourKeys.pageClosed,
      group: MetricsConstants.kaabaTourTag,
    );
    // Stop any playing media by loading an empty page before disposing
    _controller.loadRequest(Uri.parse('about:blank'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.backgroundSurface4,
    resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) const Center(child: CircularProgressIndicator()),

        // balady back button
        SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 24, top: 24),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Semantics(
                label: context.l10n.a11yBack,
                button: true,
                child: GestureDetector(
                  onTap: () => context.router.maybePop(),
                  child: ExcludeSemantics(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.pilgrimVirtualTourBackButton,
                            // Force LTR rendering so the `+` glyph sits on the
                            // same side of the word in both languages (right of
                            // the brand name, mirroring `Balady+`).
                            textDirection: TextDirection.ltr,
                            style: const TextStyle(
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
          ),
        ),
      ],
    ),
  );
}
