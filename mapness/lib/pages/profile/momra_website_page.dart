import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:provider/provider.dart';
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
        Uri.parse(switch (language) {
          Language.arabic => 'https://balady.sa/ar',
          Language.english => 'https://balady.sa/en',
        }),
      );
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: context.read<ThemeController>().systemOverlayStyle,
    child: Material(
      color: context.colors.backgroundSurface1,
      child: Scaffold(
        appBar: BaladyTopBar.iconAndText(
          systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
          title: context.l10n.baladyWebsite,
          colorEnabled: context.colors.accentDefault,
          leading: ActionModel(
            onPressed: () => context.router.pop(),
            icon: SystemIcons.arrowCornerLeftLarge,
          ),
        ),
        body: SafeArea(
          top: false,
          bottom: true,
          child: _isLoading
              ? const Center(child: Loading())
              : Column(
                  children: [
                    const SizedBox(width: 28),
                    Expanded(child: WebViewWidget(controller: _controller)),
                  ],
                ),
        ),
      ),
    ),
  );
}
