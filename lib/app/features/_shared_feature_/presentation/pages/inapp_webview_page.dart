import 'dart:async';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/utils_exports.dart' show CommonProperties, Log;
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../../shared_feature_exports.dart' show DefaultAppBarWidget;

class InAppWebViewPage extends StatefulWidget {
  final ({String title, String url}) args;

  const InAppWebViewPage({
    super.key,
    required this.args,
  });

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late StreamController<double?> _progessStream;
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    _progessStream = StreamController<double?>();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
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
            controller.runJavaScript(
                "document.getElementsByClassName('site-header-cont')[0].style.display='none';document.getElementsByClassName('footer')[0].style.display='none';document.getElementsByClassName('breadcrumb')[0].style.display='none'");
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.args.url));
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
              WebViewWidget(
                controller: controller,
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
    super.dispose();
  }
}
