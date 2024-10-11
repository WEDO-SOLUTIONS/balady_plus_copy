import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_details/widgets/services_widget.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_details/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../domain/entity/classification_certificate_details_entity.dart';
import '../bloc/classification_certificate_details_cubit.dart';
import '../bloc/classification_certificate_details_state.dart';

class DetailsDataWidget extends StatelessWidget {
  final ClassificationCertificateDetailsEentity
      classificationCertificateDetails;

  const DetailsDataWidget({
    super.key,
    required this.classificationCertificateDetails,
  });

  @override
  Widget build(BuildContext context) {
    SuccessDetailsClassificationCertificateState state = context
        .read<ClassificationCertificateDetailsCubit>()
        .state as SuccessDetailsClassificationCertificateState;
    return Column(
      children: [
        const SizedBox(height: 18),
        TitleValueWidget(
          title: "commercial_registration_license_number",
          value: classificationCertificateDetails.cRorLicNumber,
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "establishment_engineering_office_name",
          value: classificationCertificateDetails.facilityName,
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "expiration_date_certificate",
          value: state.formatCertificateExpiryDate,
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "start_date_certificate",
          value: state.formatCertificateStartDate,
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "city",
          value: classificationCertificateDetails.city,
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "classification_degree",
          value:
              "ClassificationGrade-${classificationCertificateDetails.classificationGrade}"
                  .tr(),
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "serial_number",
          value: classificationCertificateDetails.serialNumber,
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "classification_type",
          value: classificationCertificateDetails.classificationType,
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "mobile_number",
          value: classificationCertificateDetails.ccPhoneNumber,
        ),
        const SizedBox(height: 8),
        TitleValueWidget(
          title: "certificate_status",
          value: classificationCertificateDetails.status.toUpperCase().tr(),
        ),
        ///////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////
        const SizedBox(height: 8),
        state.classificationCertificateDetails.classificationType ==
                "Classification of Engineer"
            ? const SizedBox()
            : ServicesWidget(
                // 1
                title: 'buildingHousingUnitsTitle'.tr(),
                description: 'buildingHousingUnitsDescription'.tr(),
                minimum:
                    classificationCertificateDetails.buildingHousingUnitsMin,
                maximum:
                    classificationCertificateDetails.buildingHousingUnitsMax,
              ),
        const SizedBox(height: 8),
        state.classificationCertificateDetails.classificationType ==
                "Classification of Engineer"
            ? ServicesWidget(
                // 2
                title: 'limitSupervisionTitle'.tr(),
                description: 'limitSupervisionDescription'.tr(),
                minimum: classificationCertificateDetails.limitSupervisionMin,
                maximum: classificationCertificateDetails.limitSupervisionMax,
              )
            : const SizedBox(),
        /////////////////////////////////////////////////////////////////
        const SizedBox(height: 8),
        state.classificationCertificateDetails.classificationType ==
                "Classification of Engineer"
            ? ServicesWidget(
                // 3
                title: 'turnkeyTitle'.tr(),
                description: 'turnkeyDescription'.tr(),
                minimum: classificationCertificateDetails.turnkeyMin,
                maximum: classificationCertificateDetails.turnkeyMax,
              )//
            : const SizedBox(),
        /////////////////////////////////////////////////////////////////
        const SizedBox(height: 8),
        state.classificationCertificateDetails.classificationType ==
                "Classification of Engineer"
            ? ServicesWidget(
                // 4
                title: 'designContractInfoTitle'.tr(),
                description: 'designContractInfoDescription'.tr(),
                minimum: classificationCertificateDetails.designContractInfoMin,
                maximum: classificationCertificateDetails.designContractInfoMax,
              )
            : const SizedBox(),
        /////////////////////////////////////////////////////////////////
        const SizedBox(height: 8),
        state.classificationCertificateDetails.classificationType ==
                "Classification of Engineer"
            ? ServicesWidget(
                // 5
                title: 'surveyingServicesTitle'.tr(),
                description: 'surveyingServicesDescription'.tr(),
                minimum: classificationCertificateDetails.surveyingServicesMin,
                maximum: classificationCertificateDetails.surveyingServicesMax,
              )
            : const SizedBox(),
        const SizedBox(height: 18),
      ],
    );
  }
}
