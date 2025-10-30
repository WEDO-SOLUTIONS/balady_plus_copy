import 'dart:convert';

import 'package:balady_plus/app/features/vd/presentation/widgets/camera_widgets/camera_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show photoPreviewWidgetNew, CameraBloc, CameraState, CameraParamsPage;

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
