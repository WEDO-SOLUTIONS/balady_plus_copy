import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../commercial_license_details/data/models/commercial_licence_details.dart';

class OwnerShipInfoWidget extends StatelessWidget {
  final OwnershipInfo? ownershipInfo;

  const OwnerShipInfoWidget({super.key, required this.ownershipInfo});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'issue_commercial_location'.tr(),
      icon: IconPath.editIcon,
      children: [
        CardParameter(
          title: 'issue_commercial_location_type'.tr(),
          value: ownershipInfo?.contractType?.name ?? '',
        ),
        ownershipInfo?.contractType?.id != "INVEST_ATTACH"
            ? CardParameter(
                title: getTitleByContractTypeId(ownershipInfo?.contractType?.id)
                    .tr(),
                value: getContractNumberByTypeId() ?? '',
              )
            : const SizedBox(),
        ///////////////////// For EJAR_SERVICE //////////////////////
        ownershipInfo?.contractType?.id == "EJAR_SERVICE"
            ? CardParameter(
                title: 'issue_commercial_location_type_tenancy_ve'.tr(),
                value: ownershipInfo?.tenancyContractInfo?.versionNumber ?? '',
              )
            : const SizedBox(),
        ownershipInfo?.contractType?.id == "EJAR_SERVICE"
            ? CardParameter(
                title: 'issue_commercial_location_type_tenancy_rep'.tr(),
                value: ownershipInfo?.tenancyContractInfo?.nationalId ?? '',
              )
            : const SizedBox(),
        ///////////////////// For EJAR_ATTACH //////////////////////
        ownershipInfo?.contractType?.id == "EJAR_ATTACH"
            ? CardParameter(
                title: 'issue_commercial_location_type_tenancy_date'.tr(),
                value:
                    ownershipInfo?.tenancyContractInfo?.contractEndDate ?? '',
              )
            : const SizedBox(),
        ///////////////////// For INVEST_SERVICE //////////////////////
        ownershipInfo?.contractType?.id == "INVEST_SERVICE"
            ? CardParameter(
                title: 'name_contract'.tr(),
                value: ownershipInfo?.investmentContractInfo?.type?.name ?? '',
              )
            : const SizedBox(),
        ownershipInfo?.contractType?.id == "INVEST_SERVICE"
            ? CardParameter(
                title: 'issue_commercial_location_type_investment_type'.tr(),
                value: ownershipInfo?.investmentContractInfo?.type?.name ?? '',
              )
            : const SizedBox(),
        ///////////////////// For DEED_ATTACH //////////////////////
        ownershipInfo?.contractType?.id == "DEED_ATTACH"
            ? CardParameter(
                title: 'contractDate'.tr(),
                value: ownershipInfo?.deedInfo?.deedDate ?? '',
              )
            : const SizedBox(),
      ],
    );
  }

  String getTitleByContractTypeId(String? id) {
    switch (id) {
      case "EJAR_SERVICE":
      case "EJAR_ATTACH":
        return 'issue_commercial_location_type_tenancy_no';
      case "INVEST_SERVICE":
      case "INVEST_ATTACH":
        return 'issue_commercial_location_type_investment_number';
      case "DEED_SERVICE":
      case "DEED_ATTACH":
        return 'issue_commercial_location_type_clean_no';
    }
    return 'issue_commercial_location_type_tenancy_no';
  }

  String? getContractNumberByTypeId() {
    switch (ownershipInfo?.contractType?.id) {
      case "EJAR_SERVICE":
      case "EJAR_ATTACH":
        return ownershipInfo?.tenancyContractInfo?.tenancyContractNumber;
      case "INVEST_SERVICE":
      case "INVEST_ATTACH":
        return ownershipInfo?.investmentContractInfo?.investmentContractNumber;
      case "DEED_SERVICE":
      case "DEED_ATTACH":
        return ownershipInfo?.deedInfo?.deedNumber;
    }
    return '';
  }
}
