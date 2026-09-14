import 'dart:async';

import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/utils_exports.dart' show Log;
import '../../shared_feature_exports.dart' show DefaultAppBarWidget;

class QiblahWebViewPage extends StatefulWidget {
  const QiblahWebViewPage({super.key});

  @override
  State<QiblahWebViewPage> createState() => _QiblahWebViewPageState();
}

class _QiblahWebViewPageState extends State<QiblahWebViewPage> {
  late StreamController<double?> _progessStream;
  InAppWebViewController? _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //CookieManager.instance().deleteAllCookies();

    _progessStream = StreamController<double?>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(title: "qiblahCompass".tr(), x: true),
      body: StreamBuilder<double?>(
        stream: _progessStream.stream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              InAppWebView(
                onWebViewCreated: (InAppWebViewController controller) {
                  _controller = controller;
                },
                initialUrlRequest: URLRequest(
                  // url: Uri.parse('https://flutter.dev/'),
                  url: WebUri("https://qiblafinder.withgoogle.com/intl/ar/finder/ar"),
                ),
                androidOnGeolocationPermissionsShowPrompt: (controller, origin) async {
                  return GeolocationPermissionShowPromptResponse(origin: origin, allow: true, retain: true);
                },
                initialOptions: InAppWebViewGroupOptions(
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                    geolocationEnabled: true,
                    // safeBrowsingEnabled: false,
                  ),
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                    javaScriptCanOpenWindowsAutomatically: true,

                    //  allowUniversalAccessFromFileURLs: true,
                    //  preferredContentMode: UserPreferredContentMode.MOBILE
                  ),
                ),
                onLoadStart: (controller, Uri? url) async {},
                onLoadStop: (controller, Uri? url) async {
                  debugPrint(url.toString());
                  if (mounted) {
                    Timer(const Duration(seconds: 1), () async {
                      await _controller?.evaluateJavascript(
                        source: "document.getElementsByClassName('mat-raised-button')[0].click()",
                      );
                      await _controller?.evaluateJavascript(
                        source: "document.getElementsByClassName('mat-raised-button')[0].click()",
                      );

                      await _controller?.evaluateJavascript(
                        source:
                            "document.getElementsByClassName('mat-focus-indicator mat-icon-button mat-button-base')[0].style.display='none'; document.getElementsByClassName('mat-focus-indicator mat-icon-button mat-button-base')[0].style.display='none'; document.getElementsByClassName('mat-fab mat-button-base')[0].style.display='none'; document.getElementsByClassName('expanded')[0].style.display='none'",
                      );

                      Timer(const Duration(seconds: 3), () async {
                        setState(() {
                          isLoading = false;
                        });
                        await _controller?.evaluateJavascript(
                          source: "document.getElementsByClassName('mat-raised-button')[0].click()",
                        );

                        await _controller?.evaluateJavascript(
                          source:
                              "document.getElementsByClassName('mat-focus-indicator mat-icon-button mat-button-base')[0].style.display='none'; document.getElementsByClassName('mat-focus-indicator mat-icon-button mat-button-base')[0].style.display='none'; document.getElementsByClassName('mat-fab mat-button-base')[0].style.display='none'; document.getElementsByClassName('expanded')[0].style.display='none'",
                        );
                      });
                    });
                  }
                },
                onLoadError: (controller, url, code, message) => debugPrint(message.toString()),
                onProgressChanged: (controller, int progress) {
                  final percent = progress / 100;
                  debugPrint(percent.toString());
                },
                onConsoleMessage: (controller, ConsoleMessage consoleMessage) {
                  "$consoleMessage".warningLog();
                  "Message coming from Dart side: ${consoleMessage.message}".warningLog();
                },
              ),
              if (isLoading) const Center(child: CustomCircularLoadingWidget()),
              /*  Align(
                alignment: Alignment.center,
                child: ElevatedButtonWidget.add(
                  onPressed: () async {
                  
                    await _controller.evaluateJavascript(
                        source:
                            "document.getElementsByClassName('mat-focus-indicator mat-icon-button mat-button-base')[0].style.display='none'; document.getElementsByClassName('mat-focus-indicator mat-icon-button mat-button-base')[0].style.display='none'; document.getElementsByClassName('mat-fab mat-button-base')[0].style.display='none'; document.getElementsByClassName('expanded')[0].style.display='none'");

                    //_controller.evaluateJavascript(
                    //    source:
                    //        "document.getElementsByClassName('expanded')[0].style.display='none'");

                    // controller.runJavaScript(
                    //     "document.getElementsByTagName('button')[1].style.display='none'");
                  },
                ),
              )*/
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _progessStream.close();
    _controller?.stopLoading();
    _controller?.removeAllUserScripts();
    _controller = null;
    super.dispose();
  }
}
