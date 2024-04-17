import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class OwnerShipInfoWidget extends StatelessWidget {
  final  ownershipInfo;
  const OwnerShipInfoWidget({super.key, required this.ownershipInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'license_owner_info'.tr(),
      icon: IconPath.editIcon,
      isExpandedByDefault: true,
      children: [



      ],
    );
  }
}

