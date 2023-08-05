import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor;
import '../../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../shared_feature_exports.dart'
    show DrawLineWidget, GlowingScrollWidget;

class DraggableSheetCard extends StatefulWidget {
  final double minSize;
  final double maxSize;
  final double? cornerRadius;
  final List<Widget> children;
  final double initialChildSize;

  const DraggableSheetCard({
    super.key,
    required this.minSize,
    required this.maxSize,
    this.cornerRadius,
    required this.initialChildSize,
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

      draggableScrollableController
          .jumpTo(mapViewModel.bottomSheetSizeFraction.value);
      mapViewModel.bottomSheetSize.notifyListeners();

      draggableScrollableController.addListener(() {
        mapViewModel.bottomSheetSize.value =
            draggableScrollableController.pixels;
        mapViewModel.bottomSheetSize.notifyListeners();

        mapViewModel.bottomSheetSizeFraction.value =
            draggableScrollableController.size;
        mapViewModel.bottomSheetSizeFraction.notifyListeners();

        print(mapViewModel.bottomSheetSizeFraction.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.paleGrey,
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
            initialChildSize: widget.minSize,
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
                    lineWidth: 70.0,
                    lineHeight: 6.0,
                    lineColor: AppColor.gray,
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
}
