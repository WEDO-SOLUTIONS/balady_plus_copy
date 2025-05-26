import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../domain/entities/ekram_types.dart';
import '../blocs/driver_request_bloc/transport_requests_bloc.dart';

class EkramTypeCardWidget extends StatelessWidget {
  final EkramTypes ekramTypes;
  final TransportRequestsBloc ekramBloc;
  const EkramTypeCardWidget(
      {Key? key, required this.ekramTypes, required this.ekramBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ekramTypes.type == "transport") {
          NavigationService.navigatorKey.currentState!.pushReplacementNamed(
              RouteName.ekramRequestTransportationScreen,
              arguments: ekramBloc);
        }
      },
      child: Container(
        height: 202,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 16, bottom: 24, left: 16),
        decoration: new BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 1),
                blurRadius: 15,
                spreadRadius: 0)
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSvgIconWidget(
                ekramTypes.icon ?? "",
                iconHeight: 52,
                iconWidth: 52,
              ),
              CustomVerticalSpace(height: 10),
              CustomTextWidget(
                (ekramTypes.title ?? "").tr(),
                fontSize: 14,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.black,
                maxLines: 2,
              ),
              CustomVerticalSpace(height: 12),
              CustomTextWidget(
                (ekramTypes.desc ?? "").tr(),
                fontSize: 13,
                fontWeight: AppFontWeight.medium,
                fontColor: AppColor.black400,
                height: 1.4,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
