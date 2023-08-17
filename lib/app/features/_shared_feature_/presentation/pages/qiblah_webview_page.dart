import 'dart:async';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/src/webview_cookie_manager.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../../core/utils/utils_exports.dart' show CommonProperties, Log;
import '../../../entry_point/domain/use_cases/get_cookie.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../shared_feature_exports.dart' show DefaultAppBarWidget;

class QiblahWebViewPage extends StatefulWidget {
  final ({String title, String url}) args;

  const QiblahWebViewPage({
    super.key,
    required this.args,
  });

  @override
  State<QiblahWebViewPage> createState() => _QiblahWebViewPageState();
}

class _QiblahWebViewPageState extends State<QiblahWebViewPage> {
  late StreamController<double?> _progessStream;
  InAppWebViewController? _controller;
  @override
  void initState() {
    super.initState();
    //CookieManager.instance().deleteAllCookies();

    _progessStream = StreamController<double?>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "qiblahCompass".tr(),
        x: true,
      ),
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
                  url: Uri.parse(widget.args.url),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                  ),
                ),
                onLoadStart: (controller, Uri? url) async {},
                onLoadStop: (controller, Uri? url) async {
                  if (mounted)
                    Timer.periodic(const Duration(seconds: 1), (timer) async {
                      await _controller?.evaluateJavascript(
                          source:
                              "document.getElementsByClassName('mat-raised-button')[0].click()");

                      Timer.periodic(const Duration(seconds: 2), (timer) async {
                        await _controller?.evaluateJavascript(
                            source:
                                "document.getElementsByClassName('mat-raised-button')[0].click()");

                        await _controller?.evaluateJavascript(
                            source:
                                "document.getElementsByClassName('mat-focus-indicator mat-icon-button mat-button-base')[0].style.display='none'; document.getElementsByClassName('mat-focus-indicator mat-icon-button mat-button-base')[0].style.display='none'; document.getElementsByClassName('mat-fab mat-button-base')[0].style.display='none'; document.getElementsByClassName('expanded')[0].style.display='none'");
                      });
                    });
                },
                onLoadError: (controller, url, code, message) => print(message),
                onProgressChanged: (controller, int progress) {
                  final percent = progress / 100;
                },
                onConsoleMessage: (controller, ConsoleMessage consoleMessage) {
                  "$consoleMessage".warningLog();
                  "Message coming from Dart side: ${consoleMessage.message}"
                      .warningLog();
                },
              ),
              if (snapshot.data != null && snapshot.data! < 1)
                Center(
                  child: CircularProgressIndicator(
                    value: snapshot.data,
                  ),
                ),
              /*  Align(
                alignment: Alignment.center,
                child: ElevatedButtonWidget.add(
                  onPressed: () async {
                    print("FFFF");
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
