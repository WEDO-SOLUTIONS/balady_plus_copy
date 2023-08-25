import 'dart:async';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
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

class InAppWebViewPage extends StatefulWidget {
  const InAppWebViewPage({
    super.key,
  });

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
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
    ({String title, String url}) args = ModalRoute.of(context)!
        .settings
        .arguments as ({String title, String url});

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
                  url: Uri.parse(args.url),
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

                  try {
                    _controller?.evaluateJavascript(
                        source:
                            "document.getElementsByClassName('site-header-cont')[0].style.display='none';document.getElementsByClassName('footer')[0].style.display='none';document.getElementsByClassName('breadcrumb')[0].style.display='none'");
                  } catch (ex) {}
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
