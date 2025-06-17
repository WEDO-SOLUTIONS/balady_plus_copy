import 'package:balady_plus/super_app_js_bridge/camera/camera_widgets/photo_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../camera_bloc/camera_bloc.dart';
import 'camera_widget.dart';

class cameraViewWidgetNew extends StatefulWidget {
  @override
  _cameraViewWidgetState createState() => _cameraViewWidgetState();
}

class _cameraViewWidgetState extends State<cameraViewWidgetNew> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        return !(state.showCamera ?? false)
            ? photoPreviewWidgetNew()
            : CameraWidget();
      },
    );
  }
}
