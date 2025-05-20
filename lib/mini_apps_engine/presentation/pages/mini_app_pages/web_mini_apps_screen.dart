import 'dart:io';

import 'package:balady_plus/super_app_js_bridge/js_bridge_listener.dart';
import 'package:dsbridge_flutter/dsbridge_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/features/_shared_feature_/presentation/dialogs/camera_permission_dialog.dart';
import '../../../../app/features/_shared_feature_/presentation/dialogs/location_permission_dialog.dart';
import '../../../../app/features/_shared_feature_/presentation/dialogs/location_service_dialog.dart';

class WebMiniAppsScreen extends StatefulWidget {
  String servicePath;

  WebMiniAppsScreen({super.key,required this.servicePath});

  @override
  State<WebMiniAppsScreen> createState() => _WebMiniAppsScreenState();
}

class _WebMiniAppsScreenState extends State<WebMiniAppsScreen> {
  late final DWebViewController _controller;
  static bool locationDialogShowed = false;

  @override
  void initState()  {

    super.initState();

    if (widget.servicePath.contains("index.html")) {
      // #docregion platform_features
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final DWebViewController controller =
      DWebViewController.fromPlatformCreationParams(params,onPermissionRequest: (request) {
        request.grant();
      });


      controller
        ..setBackgroundColor(Colors.white)
        ..loadRequest(Uri.parse(widget.servicePath))
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..addJavaScriptObject(JsBridgeListener())
        ..setNavigationDelegate(NavigationDelegate(
          onProgress: (progress) {
            print('process=$progress');
          },
          onPageStarted: (url) {
            print('url onPageStarted');
          },
          onPageFinished: (url) {
            _injectPermissionHandlingScript();
          },
        ));

      _controller = controller;
      _injectPermissionHandlingScript();

      if (Platform.isAndroid) {
        (_controller.platform as AndroidWebViewController).setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            // Handle permission request

            return GeolocationPermissionsResponse(

              allow: true,  // Or implement your own permission logic
              retain: true,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    // _handleCameraPermission();
   return  DWebViewWidget(controller: _controller);
  }

void _injectPermissionHandlingScript() {
  _controller.runJavaScript('''
      // This helps some websites recognize permissions are granted
      navigator.mediaDevices.getUserMedia = 
        navigator.mediaDevices.getUserMedia || 
        navigator.webkitGetUserMedia || 
        navigator.mozGetUserMedia;
    ''');
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

    Future<List<String>> _onShowFileSelector(final FileSelectorParams params) async {
      // Here you would implement your file picking logic
      // This is just a placeholder - you'd typically use file_picker or similar

    //  Example using file_picker package:
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        return result.paths.where((path) => path != null).map((path) => path!).toList();
      }

      return []; // Return empty list if no files selected
    }


  Future<bool> _handleCameraPermission() async {
    var status = await Permission.camera.request();
    if (status == PermissionStatus.permanentlyDenied) {
      showDialog(
          context: context, builder: (ctx) => const CameraPermissionDialog());
      return false;
    } else if (status != PermissionStatus.granted) {
      Permission.camera.request();
      return false;
    } else {
      return true;
    }
  }
  static Future<bool> _handleGeolocationPermission22(BuildContext context) async {
    ServiceStatus serviceStatus = await Permission.location.serviceStatus;

    if (serviceStatus != ServiceStatus.disabled) {
      var status = await Permission.location.request();

      if (status == PermissionStatus.permanentlyDenied) {
        if (!locationDialogShowed) {
          locationDialogShowed = true;
          showDialog(
            context: context,
            builder: (ctx) => const LocationPermissionDialog(),
          ).then((value) => locationDialogShowed = false);
        }
        return false;
      } else if (status != PermissionStatus.granted) {
        Permission.location.request();
        return false;
      } else {
        return true;
      }
    } else {
      if (!locationDialogShowed) {
        showDialog(
          context: context,
          builder: (ctx) => const LocationServiceDialog(),
        ).then((value) => locationDialogShowed = false);
      }

      return false;
    }
  }




}