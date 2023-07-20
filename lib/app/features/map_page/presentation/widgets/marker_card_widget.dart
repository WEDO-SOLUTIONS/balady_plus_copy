import 'package:balady_plus/app/features/map_page/presentation/mvvm/search_map_view_model.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/near_by_types.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../mvvm/point_view_model.dart';

class MarkerMapWidget extends StatelessWidget {
  final PointViewModel pointViewModel;

  const MarkerMapWidget({super.key, required this.pointViewModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.network(
                'https://1000logos.net/wp-content/uploads/2020/10/Costa-Coffee-Logo.png',
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 6,
            child: ValueListenableBuilder<ObjectInfoMessage?>(
              valueListenable: pointViewModel.dataPoint,
              builder: (_, dataPoint, __) {
                return dataPoint == null
                    ? const SizedBox()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataPoint.title,
                            style: AppStyle.mainTextStyle,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            dataPoint.address?.drilldownString ?? 'Address',
                            style: AppStyle.serviceDescriptionStyle,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 15),
                              const SizedBox(width: 6),
                              Text(
                                '+9550029202',
                                style: AppStyle
                                    .personalInfoParameterTitleTextStyle
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
