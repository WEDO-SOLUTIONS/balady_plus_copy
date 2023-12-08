import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/athkar/athkar_exports.dart'
    show AthkarEntity, AthkarEntityContentParams;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget;
import '../../../data/models/athkar_entites_params.dart';

class AthkarEntityCard extends StatefulWidget {
  const AthkarEntityCard({
    super.key,
    required this.athkarEntity,
    required this.pageNumber,
    required this.athkarEntitiesList,
  });

  final AthkarEntity athkarEntity;
  final int pageNumber;
  final List<AthkarEntity> athkarEntitiesList;

  @override
  State<AthkarEntityCard> createState() => _AthkarEntityCardState();
}

class _AthkarEntityCardState extends State<AthkarEntityCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //Navigator
      onTap: () => NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.athkarEntityContentPage,
              arguments: AthkarEntityContentParams(
                widget.athkarEntity.name,
                widget.athkarEntity,
                widget.pageNumber,
                widget.athkarEntitiesList,
              )),

      child: Container(
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
              Flexible(
                child: CustomTextWidget(
                  widget.athkarEntity.name.replaceAll("\n", " "),
                  fontColor: Colors.black,
                  textOverflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              CustomTextWidget(
                '${widget.athkarEntity.quantity}',
                fontColor: AppColor.primary800Light,
                fontWeight: AppFontWeight.semiBold,
                fontSize: 14,
              ),
              /* Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    IconPath.muslimNumberFrame,
                    width: 36,
                    height: 36,
                  ),
                  CustomTextWidget(
                    '${widget.athkarEntity.quantity}',
                    fontColor: AppColor.primary800Light,
                    fontWeight: AppFontWeight.semiBold,
                    fontSize: 14,
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
