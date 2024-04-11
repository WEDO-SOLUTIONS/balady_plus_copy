import 'package:flutter/material.dart';
import 'package:mapness/pages/mini_apps/ui/mini_app_header.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MiniAppBottomSheet extends StatefulWidget {
  const MiniAppBottomSheet({
    required this.title,
    super.key,
  });

  final String title;

  @override
  State<MiniAppBottomSheet> createState() => _MiniAppBottomSheetState();
}

class _MiniAppBottomSheetState extends State<MiniAppBottomSheet> {
  late WebViewController controller;
  late DgisBottomSheetController dgisSheetController;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://urbi.ae/'));
    dgisSheetController = DgisBottomSheetController();
  }

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: DgisBottomSheet(
          controller: dgisSheetController,
          availableExpansions: const {
            Expansion.middle,
            Expansion.expanded,
          },
          showHandle: true,
          initialExpansion: Expansion.middle,
          middleHeight: 300,
          showBarrier: false,
          scrollHeader: MiniAppHeader(
            title: widget.title,
          ),
          scrollableBody: (context, scrollcontroller) => Stack(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: WebViewWidget(controller: controller),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                controller: scrollcontroller,
                child: const ColoredBox(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      );
}
