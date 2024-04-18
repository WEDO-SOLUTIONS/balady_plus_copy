import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class SalamaDetailsInfoWidget extends StatelessWidget {
  final SalamaDetailsInfo salamaDetailsInfo;
  const SalamaDetailsInfoWidget({super.key, required this.salamaDetailsInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_civil'.tr(),
      icon: IconPath.editIcon,
      isExpandedByDefault: true,
      children: [
        CardParameter(
          title: 'fire_approval_type'.tr(),
          value: salamaDetailsInfo.documentName ?? '',
        ),
        CardParameter(
          title: 'status'.tr(),
          value: "تم اعتماد الطلب من قبل منصة الدفاع المدني",
        ),
        ///////////////////
        CardParameter(
          title: 'fire_approval_type'.tr(),
          value: 'فاتورة أدوات سلامة',
        ),
        CardParameter(
          title: 'salamaBillNumber_2'.tr(),
          value: salamaDetailsInfo.salamaBillNumber ?? '',
        ),
        CardParameter(
          title: 'fire_approval_type'.tr(),
          value: 'تقرير فني',
        ),
        CardParameter(
          title: 'map_digging_permit_number'.tr(),
          value: salamaDetailsInfo.salamaPermitNumber ?? '',
        ),
        CardParameter(
          title: 'fire_approval_type'.tr(),
          value: 'تصريح سلامة',
        ),
        CardParameter(
          title: 'slamaReportNumber'.tr(),
          value: salamaDetailsInfo.salamaReportNumber ?? '',
        ),
      ],
    );
  }
}

