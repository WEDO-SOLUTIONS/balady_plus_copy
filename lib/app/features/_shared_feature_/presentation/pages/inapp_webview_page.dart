import 'dart:async';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/utils_exports.dart' show Log;
import '../../shared_feature_exports.dart' show DefaultAppBarWidget;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({
    super.key,
  });

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  ///late StreamController<double?> _progessStream;
  InAppWebViewController? _controller;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    //CookieManager.instance().deleteAllCookies();

    //  _progessStream = StreamController<double?>();
  }

  @override
  Widget build(BuildContext context) {
    ({String requestNum, String url, bool? isObjections}) args =
        ModalRoute.of(context)!.settings.arguments as ({String requestNum, String url, bool? isObjections});

   String url = args.url.replaceAll("\n", "");
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "back".tr(),
      ),
      body: Stack(
        children: [
          InAppWebView(

            initialSettings: InAppWebViewSettings(
              useHybridComposition: true,
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
            ),
            shouldOverrideUrlLoading: (controller, action) async {
              return NavigationActionPolicy.ALLOW;
            },
            onWebViewCreated: (InAppWebViewController controller) {
              _controller = controller;
            },
            initialUrlRequest: URLRequest(
              // url: Uri.parse('https://flutter.dev/'),
              url: WebUri(url),
            ),
            initialOptions: InAppWebViewGroupOptions(
              android: AndroidInAppWebViewOptions(
                useHybridComposition: true,
                // safeBrowsingEnabled: false,
              ),
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
              ),
            ),
            onLoadStart: (controller, Uri? url) {},
            onLoadStop: (controller, Uri? url) {
              /* 
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

              try {
                _controller?.evaluateJavascript(
                    source:
                        "document.getElementsByClassName('site-header-cont')[0].style.display='none';document.getElementsByClassName('footer')[0].style.display='none';document.getElementsByClassName('breadcrumb')[0].style.display='none'");
              } catch (error, stackTrace) {
                LogsViewModel().sendEventFromModel(
                  event: ErrorExceptionModel(
                    nameEvent: EventsName.handledException,
                    message: error.toString(),
                    stackTrace: stackTrace.toString(),
                  ),
                );
              }

              if (args.isObjections == true &&
                  ((url?.path.toLowerCase().contains("permits/permitsDetails/index") ?? false) ||
                      (url?.path.contains("dashboardclient/requests/details") ?? false) ||
                      (url?.path.contains("dashboardclient/licenses/details") ?? false))) {
                try {
                  print("HIDEEE");
                  _controller?.evaluateJavascript(
                      source: "document.getElementsByClassName('btn-text-danger')[0].style.display='none'");
                } catch (error, stackTrace) {
                  LogsViewModel().sendEventFromModel(
                    event: ErrorExceptionModel(
                      nameEvent: EventsName.handledException,
                      message: error.toString(),
                      stackTrace: stackTrace.toString(),
                    ),
                  );
                }

                const Duration interval = Duration(seconds: 2);
                const Duration timeout = Duration(minutes: 2);

                Timer.periodic(interval, (Timer timer) {
                  try {
                    print("HIDEEE");
                    _controller?.evaluateJavascript(
                        source: "document.getElementsByClassName('btn-text-danger')[0].style.display='none'");
                  } catch (error, stackTrace) {
                    LogsViewModel().sendEventFromModel(
                      event: ErrorExceptionModel(
                        nameEvent: EventsName.handledException,
                        message: error.toString(),
                        stackTrace: stackTrace.toString(),
                      ),
                    );
                  }
                  if (timer.tick >= timeout.inSeconds) {
                    timer.cancel();
                    print('Timer stopped after 2 minutes.');
                  }
                });
              }
              setState(() {
                isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) => print(message),
            onProgressChanged: (controller, int progress) {
              final percent = progress / 100;
            },
            onConsoleMessage: (controller, ConsoleMessage consoleMessage) {
              "$consoleMessage".warningLog();
              "Message coming from Dart side: ${consoleMessage.message}".warningLog();
            },
          ),
          if (isLoading)
            const Center(
              child: CustomLoadingWidget(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // _progessStream.close();
    _controller?.stopLoading();
    _controller?.removeAllUserScripts();
    _controller = null;
    super.dispose();
  }
}
