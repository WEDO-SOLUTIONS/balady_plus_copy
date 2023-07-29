import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../../home_page/presentation/pages/home_page.dart';
import '../../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../../map_page/presentation/dialogs/map_layer_dialog.dart';
import '../../../../map_page/presentation/mvvm/layers_gis_view_model.dart';
import '../../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DrawLineWidget,
        GlowingScrollWidget;

class DraggableSheetCard extends StatefulWidget {
  final double minSize;
  final double maxSize;
  final double initialChildSize;
  final double? cornerRadius;
  final List<Widget> children;

  const DraggableSheetCard({
    super.key,
    required this.minSize,
    required this.maxSize,
    required this.initialChildSize,
    this.cornerRadius,
    required this.children,
  });

  @override
  State<DraggableSheetCard> createState() => _DraggableSheetCardState();
}

class _DraggableSheetCardState extends State<DraggableSheetCard> {
  final draggableScrollableController = DraggableScrollableController();
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      MapViewModel mapViewModel =
          Provider.of<MapViewModel>(context, listen: false);

      mapViewModel.bottomSheetSize.value = draggableScrollableController.pixels;
      mapViewModel.bottomSheetSize.notifyListeners();

      draggableScrollableController.addListener(() {
        mapViewModel.bottomSheetSize.value =
            draggableScrollableController.pixels;
        mapViewModel.bottomSheetSize.notifyListeners();
        print(mapViewModel.bottomSheetSize.value);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    LayersGisViewModel layersModel = context.watch<LayersGisViewModel>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.paleGrey,
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
            colors: [
              AppColor.secondary50Light,
              Color(0xffF5F8FA),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.cornerRadius ?? 36),
            topRight: Radius.circular(widget.cornerRadius ?? 36),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackModern900Light.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.cornerRadius ?? 36),
            topRight: Radius.circular(widget.cornerRadius ?? 36),
          ),
          child: DraggableScrollableSheet(
            controller: draggableScrollableController,
            initialChildSize: widget.initialChildSize,
            minChildSize: widget.minSize,
            maxChildSize: widget.maxSize,
            expand: false,
            builder: (_, controller) => Column(
              children: [
                InkWell(
                  onTap: () {
                    if (draggableScrollableController.size <= widget.minSize) {
                      draggableScrollableController.animateTo(
                        widget.maxSize,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutBack,
                      );
                    } else {
                      draggableScrollableController.animateTo(
                        widget.minSize,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutBack,
                      );
                      controller.jumpTo(0);
                    }
                  },
                  child: const DrawLineWidget(
                    lineWidth: 32,
                    lineHeight: 4,
                    lineColor: AppColor.white,
                    radius: 46.0,
                    verticalMargin: 8,
                  ),
                ),
                Expanded(
                  child: GlowingScrollWidget(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      controller: controller,
                      child: Column(
                        children: widget.children,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    draggableScrollableController.dispose();
    super.dispose();
  }

  void showMainLayersDialog(
      BuildContext context, LayersGisViewModel layersModel) async {
    BottomSheetDialog.showDraggableSheet(
      context,
      child: BottomSheetWithActions(
        title: "اختر نوع الخريطة".tr(),
        body: MapLayersDialog(layersModel: layersModel),
      ),
    );
  }
}
