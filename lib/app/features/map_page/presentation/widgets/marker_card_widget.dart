import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
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
    final dataPoint = pointViewModel.point;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(RouteName.MapDetailsPage, arguments: pointViewModel);
      },
      child: Card(
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
              child:

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataPoint.name,
                      style: AppStyle.mainTextStyle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dataPoint.description ,
                      style: AppStyle.serviceDescriptionStyle,
                    ),
                    const CustomVerticalSpace(height: 8),
                    Row(
                      children: [
                        CustomTextWidget(
                          dataPoint.type ?? "",
                          textStyle: AppStyle.serviceDescriptionStyle,
                        ),
                      ],
                    )
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
