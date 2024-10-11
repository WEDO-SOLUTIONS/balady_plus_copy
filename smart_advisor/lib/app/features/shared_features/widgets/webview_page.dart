import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({required this.url, required this.title});
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController controller = WebViewController();
  bool isLoading = true; // Boolean to track the loading state

  @override
  void initState() {
    super.initState();
    // Load the web page
    controller.loadRequest(Uri.parse(widget.url));

    // Add listener for when the page starts and finishes loading
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          setState(() {
            isLoading = true; // Show the loader when page starts loading
          });
        },
        onPageFinished: (String url) {
          setState(() {
            isLoading = false; // Hide the loader when page finishes loading
          });
        },
        onNavigationRequest: (NavigationRequest request) {
          // Handle any custom navigation logic if needed
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller, // Use WebViewWidget with the controller
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColor.statusAccentColor,
                )) // Show loader when loading
              : const SizedBox.shrink(), // Hide loader when done
        ],
      ),
    );
  }
}
