import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MomraWebsitePage extends StatefulWidget {
  const MomraWebsitePage({super.key});

  @override
  State<MomraWebsitePage> createState() => _MomraWebsitePageState();
}

class _MomraWebsitePageState extends State<MomraWebsitePage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://momrah.gov.sa/en'));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                width: 12,
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Consumer(builder: (context, ref, _) {
                        final direction = ref.watch(uiDirectionProvider);
                        return SizedBox(
                          height: 40,
                          width: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF5F7FA),
                            child: InkWell(
                              onTap: () {
                                context.pop();
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  direction == TextDirection.ltr
                                      ? 'assets/icons/svg/ic_chevron_left.svg'
                                      : 'assets/icons/svg/ic_chevron_right.svg',
                                  height: 24,
                                  width: 24,
                                  package: PackageConfig.packageName,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF1E2A36),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const Spacer(),
                      Text(
                        context.l10n.baladyWebsite,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentM
                            .copyWith(color: const Color(0xFF1E2A36)),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: WebViewWidget(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
