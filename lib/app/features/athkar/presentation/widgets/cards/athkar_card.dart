import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/athkar/data/models/athkar_entites_params.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_category.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;
import '../../../domain/entities/athkar_entity.dart';

class AthkarCard extends StatelessWidget {
  const AthkarCard({
    super.key,
    required this.athkarCategory,
  });

  final AthkarCategory athkarCategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        List<AthkarEntity> athkarEntities = await athkarCategory.athkarEntities;
        print(athkarEntities);
        Navigator.pushNamed(context, RouteName.athkarEntitesPage,
            arguments:
                AthkarEntitiesParams(athkarCategory.name, athkarEntities));
      },
      child: FutureBuilder(
          future: athkarCategory.athkarEntities,
          builder: (context, snapshot) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              height: 64,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          athkarCategory.icon,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          athkarCategory.name,
                          style: AppStyle.athkarNameStyle,
                        ),
                      ],
                    ),
                    CustomTextWidget(
                      '${snapshot.data?.length}',
                      fontColor: AppColor.primary800Light,
                      fontWeight: AppFontWeight.semiBold,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
