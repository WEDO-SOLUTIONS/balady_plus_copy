import 'package:balady_plus/app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/core/utils/common_functions.dart';
import '../../app/core/utils/constants/apis/env_types.dart';
import '../../app/core/utils/constants/ux_cam_events.dart';
import '../../app/core/utils/enums/enums.dart';
import 'camera_bloc/camera_bloc.dart';
import 'camera_widgets/camera_view_widget.dart';

class VDCameraPage extends StatefulWidget {
  VDCameraPage({
    super.key,
  });

  @override
  State<VDCameraPage> createState() => _VDCameraPageState();
}

class _VDCameraPageState extends State<VDCameraPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Helpers.sendEventToAnalytics(AppEvents.VD_Open_Camera); //MM
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceSnapAndSend);
    CommonFunctions.sendUXCamEvent(UXCamEvents.cameraServiceSnapAndSend);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.SnapAndSend_Open_Camera_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    CameraParamsPage params =
        ModalRoute.of(context)!.settings.arguments as CameraParamsPage;

    return MultiBlocProvider(
      providers: [
        BlocProvider<CameraBloc>(
          create: (BuildContext context) => CameraBloc(
            params: params,
            getGisData: sl(),
          ),
        ),
      ],
      child: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: cameraViewWidgetNew(),
          );
        },
      ),
    );
  }
}

class CameraParamsPage {
  CategoryItem? selectedCategory;

  // bool isFromHome;
  String? address;
  double? lat;
  double? lon;
  bool qrCodeFlow;
  PAGE_TYPE? pageType;

  CameraParamsPage({
    this.selectedCategory,
    this.address,
    this.lat,
    this.lon,
    // this.isFromHome = false,
    this.qrCodeFlow = false,
    this.pageType,
  });
}

class CategoryItem {
  String? icon;
  String? description;
  String? type;
  String? categoryName;
  String? categoryId;
  String? mainImage;
  bool? isPromoted;

  CategoryItem(
      {this.categoryId,
        this.categoryName,
        this.description,
        this.icon,
        this.isPromoted,
        this.mainImage,
        this.type});

  String? getMainImageUrl() {
    return "${sl<EnvType>().domain}v1/dms-mobile/files/$mainImage";
  }

  String? getIconeUrl() {
    return "${sl<EnvType>().domain}v1/dms-mobile/files/$icon";
  }
}

