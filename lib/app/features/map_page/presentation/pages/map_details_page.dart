import 'package:balady_plus/app/features/map_page/presentation/widgets/map_details_header.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../mvvm/point_view_model.dart';
import '../widgets/map_details_field.dart';
import '../widgets/map_details_sub_header.dart';

class MapDetailsPage extends StatelessWidget {
  final PointViewModel pointViewModel;
  const MapDetailsPage({super.key, required this.pointViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder<ObjectInfoMessage?>(
      valueListenable: pointViewModel.dataPoint,
      builder: (_, dataPoint, __) {
        return dataPoint == null
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MapDetailsHeader(
                    name: dataPoint.title,
                    address: dataPoint.subtitle,
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      color: AppColor.primary50Light,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      // image: DecorationImage(image: AssetImage())
                    ),
                    child: Column(children: [
                      MapDetailsSubHeader(
                        entityType: dataPoint.type.name,
                      ),
                      MapDetailsField(
                        title: "111",
                        subTitle: "111",
                      ),
                      MapDetailsField(
                        title: "111",
                        subTitle: "111",
                      ),
                    ]),
                  )
                ],
              );
      },
    ));
  }
}
