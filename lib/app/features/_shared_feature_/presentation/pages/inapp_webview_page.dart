import 'dart:async';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/utils_exports.dart' show Log;
import '../../shared_feature_exports.dart' show DefaultAppBarWidget;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({super.key});

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  ///late StreamController<double?> _progessStream;
  InAppWebViewController? _controller;
  bool isLoading = true;
  List<String> _callbackUrls = const [];
  bool _didPop = false;

  @override
  void initState() {
    super.initState();
    //CookieManager.instance().deleteAllCookies();
    CookieManager.instance().setCookie(
      url: WebUri.uri(Uri.parse("balady.gov.sa")),
      name: "balady-lang",
      value: translator.activeLanguageCode,
    );
    //  _progessStream = StreamController<double?>();
  }

  bool _isAnyCallbackUrl(Uri? current, List<String> callbackUrls) {
    if (current == null || callbackUrls.isEmpty) return false;

    final currentStr = current.toString();

    for (final cb in callbackUrls) {
      final cleaned = cb.trim();
      if (cleaned.isEmpty) continue;

      if (currentStr.startsWith(cleaned)) {
        return true;
      }
    }

    return false;
  }

  String? _matchedCallbackUrl(Uri? current, List<String> callbackUrls) {
    if (current == null || callbackUrls.isEmpty) return null;
    final currentStr = current.toString();

    for (final cb in callbackUrls) {
      final cleaned = cb.trim();
      if (cleaned.isEmpty) continue;

      if (currentStr.startsWith(cleaned)) {
        return cleaned;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final ({String requestNum, String url, bool? isObjections, List<String>? callbackUrls}) args =
        ModalRoute.of(context)!.settings.arguments
            as ({String requestNum, String url, bool? isObjections, List<String>? callbackUrls});

    String url = args.url.replaceAll("\n", "");

    _callbackUrls = (args.callbackUrls ?? const [])
        .map((e) => e.replaceAll("\n", "").trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Scaffold(
      appBar: DefaultAppBarWidget(title: "back".tr()),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children: [
            InAppWebView(
              initialSettings: InAppWebViewSettings(
                useHybridComposition: true,
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
              ),
              shouldOverrideUrlLoading: (controller, action) async {
                final Uri? uri = action.request.url?.uriValue;

                if (!_didPop && _isAnyCallbackUrl(uri, _callbackUrls)) {
                  _didPop = true;

                  final matched = _matchedCallbackUrl(uri, _callbackUrls);

                  try {
                    await controller.stopLoading();
                  } catch (_) {}

                  if (context.mounted) {
                    Navigator.of(context).pop({
                      "hitUrl": uri.toString(),
                      "matchedCallback": matched,
                      "query": uri?.queryParameters,
                      "path": uri?.path,
                    });
                  }

                  return NavigationActionPolicy.CANCEL;
                }

                return NavigationActionPolicy.ALLOW;
              },
              onWebViewCreated: (InAppWebViewController controller) {
                _controller = controller;
                _didPop = false;
              },
              initialUrlRequest: URLRequest(
                // url: Uri.parse('https://flutter.dev/'),
                url: WebUri(url),
                headers: {"Authorization": "Bearer ${CommonProperties.token}", "authToken": CommonProperties.token},
              ),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                  // safeBrowsingEnabled: false,
                ),
                crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true),
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
                        "document.getElementsByClassName('site-header-cont')[0].style.display='none';document.getElementsByClassName('footer')[0].style.display='none';document.getElementsByClassName('breadcrumb')[0].style.display='none'",
                  );
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
                    debugPrint("HIDEEE");
                    _controller?.evaluateJavascript(
                      source: "document.getElementsByClassName('btn-text-danger')[0].style.display='none'",
                    );
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
                      debugPrint("HIDEEE");
                      _controller?.evaluateJavascript(
                        source: "document.getElementsByClassName('btn-text-danger')[0].style.display='none'",
                      );
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
                      debugPrint('Timer stopped after 2 minutes.');
                    }
                  });
                }
                setState(() {
                  isLoading = false;
                });
              },
              onLoadError: (controller, url, code, message) => debugPrint(message.toString()),
              onProgressChanged: (controller, int progress) {
                final percent = progress / 100;
              },
              onConsoleMessage: (controller, ConsoleMessage consoleMessage) {
                "$consoleMessage".warningLog();
                "Message coming from Dart side: ${consoleMessage.message}".warningLog();
              },
            ),
            if (isLoading) const Center(child: CustomLoadingWidget()),
          ],
        ),
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
