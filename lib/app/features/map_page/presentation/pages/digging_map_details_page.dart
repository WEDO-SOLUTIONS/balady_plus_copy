import 'package:balady_plus/app/features/map_page/data/data_sources/point_layers_data.dart';
import 'package:balady_plus/app/features/map_page/data/model/excavations.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_details_header.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../mvvm/point_view_model.dart';
import '../widgets/map_details_field.dart';
import '../widgets/map_details_sub_header.dart';

class DiggingMapDetailsPage extends StatelessWidget {
  final Excavations item;

  const DiggingMapDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MapDetailsHeader(
            name: dataPoint.name,
            address: dataPoint.description,
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
                entityType: dataPoint.type,
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
      ),
    );
  }
}
