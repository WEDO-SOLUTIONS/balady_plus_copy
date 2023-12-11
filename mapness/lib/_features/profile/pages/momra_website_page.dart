import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:rate_my_app/rate_my_app.dart';
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
        textDirection: TextDirection.ltr,
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
                      const SizedBox(
                        width: 40,
                      ),
                      const Spacer(),
                      Text(
                        "Balady website",
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentM
                            .copyWith(color: const Color(0xFF1E2A36)),
                      ),
                      const Spacer(),
                      SizedBox(
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
                                'assets/icons/svg/ic_chevron_right.svg',
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
                      )
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
