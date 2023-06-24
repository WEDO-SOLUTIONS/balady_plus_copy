import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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

  Map<String, String> get headers => {'authToken': CommonProperties.token};

  @override
  void initState() {
    super.initState();
    _progessStream = StreamController<double?>();
  }

  @override
  Widget build(BuildContext context) {
    print("apppppp coookie ${sl<EntryPointCubit>().state.token?.appCookie}");
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: widget.args.title,
      ),
      body: StreamBuilder<double?>(
        stream: _progessStream.stream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.args.url),
                  headers: headers,
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                  ),
                ),
                onProgressChanged: (controller, int progress) {
                  final percent = progress / 100;
                  if (!_progessStream.isClosed) {
                    _progessStream.sink.add(
                      percent,
                    );
                  }
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
    super.dispose();
  }
}
