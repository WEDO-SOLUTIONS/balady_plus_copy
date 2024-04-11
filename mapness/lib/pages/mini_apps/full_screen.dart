import 'package:flutter/material.dart';
import 'package:mapness/pages/mini_apps/ui/mini_app_header.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MiniAppFullScreen extends StatefulWidget {
  const MiniAppFullScreen({
    required this.title,
    super.key,
  });

  final String title;

  @override
  State<MiniAppFullScreen> createState() => _MiniAppFullScreenState();
}

class _MiniAppFullScreenState extends State<MiniAppFullScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://urbi.ae/'));
  }

  @override
  Widget build(BuildContext context) => Material(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              MiniAppHeader(
                title: widget.title,
              ),
              Expanded(
                child: WebViewWidget(
                  controller: controller,
                ),
              ),
            ],
          ),
        ),
      );
}
