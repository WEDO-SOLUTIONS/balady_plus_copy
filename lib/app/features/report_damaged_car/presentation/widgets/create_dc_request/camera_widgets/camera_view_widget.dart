import 'dart:convert';

import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/camera_widgets/camera_widget.dart';
import 'package:balady_plus/app/features/report_damaged_car/presentation/widgets/create_dc_request/camera_widgets/photo_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/create_dc_request/camera_bloc/dc_camera_bloc.dart';

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
    return BlocBuilder<DCCameraBloc, DCCameraState>(
      builder: (context, state) {
        return !(state.showCamera ?? false)
            ? photoPreviewWidgetNew()
            : CameraWidget();
      },
    );
  }
}
