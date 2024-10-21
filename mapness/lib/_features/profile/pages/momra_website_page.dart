import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class MomraWebsitePage extends ConsumerStatefulWidget {
  const MomraWebsitePage({super.key});

  @override
  ConsumerState<MomraWebsitePage> createState() => _MomraWebsitePageState();
}

class _MomraWebsitePageState extends ConsumerState<MomraWebsitePage> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final language = ref.read(appLanguageProvider);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(NonThemeColor.color70)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onPageFinished: (url) {},
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          switch (language) {
            Language.arabic => 'https://balady.gov.sa/ar',
            Language.english => 'https://balady.gov.sa/en',
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Material(
            color: Colors.white,
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: context.l10n.baladyWebsite,
                colorEnabled: context.color.textAndIconsStatusAccent,
                leading: ActionModel(
                  text: context.l10n.back,
                  onPressed: () => context.router.maybePop(),
                  icon: SystemIcons.arrowCornerLeftLarge,
                ),
              ),
              body: _isLoading
                  ? const Center(child: Loading())
                  : Column(
                      children: [
                        const SizedBox(
                          width: 28,
                        ),
                        Expanded(
                          child: WebViewWidget(controller: _controller),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
}
