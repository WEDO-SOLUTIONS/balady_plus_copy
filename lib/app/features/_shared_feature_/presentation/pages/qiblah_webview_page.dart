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
  late WebViewController controller;
  late InAppWebViewController _controller;
  @override
  void initState() {
    super.initState();
    //CookieManager.instance().deleteAllCookies();

    _progessStream = StreamController<double?>();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..clearCache()
      ..clearLocalStorage()
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            final percent = progress / 100;
            if (!_progessStream.isClosed) {
              _progessStream.sink.add(
                percent,
              );
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            //   controller.runJavaScript(
            //     "document.getElementsByClassName('site-header-cont')[0].style.display='none';document.getElementsByClassName('footer')[0].style.display='none';document.getElementsByClassName('breadcrumb')[0].style.display='none'");

            print(url);
            // controller.runJavaScript(
            //     "document.getElementsByClassName('mat-raised-button').click");
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.args.url), headers: {
        "Authorization": "Bearer " + (CommonProperties.token ?? "")
      });

    controller.clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "back".tr(),
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
                onLoadStart: (controller, Uri? url) {
                  //  print("URL WebView: $url");
                  // setState(() {
                  //   this.url = url!.path;
                  // });
                },
                onLoadStop: (controller, Uri? url) {
                  /* print("URL WebView: $url");
                  if (url?.path.endsWith("/dashboardclient/dashboard") ??
                      false) {
                    Timer(const Duration(milliseconds: 1300), () async {
                      _controller.loadUrl(
                          urlRequest: URLRequest(
                        url: Uri.parse(widget.args.url),
                      ));
                    });
                  }*/
                  // setState(() {
                  //   this.url = url!.path;
                  // });
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
              Align(
                alignment: Alignment.center,
                child: ElevatedButtonWidget.add(
                  onPressed: () async {
                    print("FFFF");
                    print((await controller.runJavaScriptReturningResult(
                        "document.getElementsByTagName('button')[0].style.display='none'")));

                    // controller.runJavaScript(
                    //     "document.getElementsByTagName('button')[1].style.display='none'");
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _progessStream.close();
    super.dispose();
  }
}
