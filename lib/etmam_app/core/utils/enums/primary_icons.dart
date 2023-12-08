import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';

enum PrimaryIcons {
  providerDetailsDocument(
      icon: IconPath.providerDetailsDocument,
      iconHeight: 19.5,
      iconWidth: 15.5),
  providerWorksIcon(
      icon: IconPath.providerWorksIcon, iconHeight: 19, iconWidth: 21),
  providerOfficeIcon(
      icon: IconPath.providerOfficeIcon, iconHeight: 15.75, iconWidth: 20),
  extraServicesIcon(
      icon: IconPath.providerDetailsDocument,
      iconHeight: 13.32,
      iconWidth: 17.93),
  locationSectionIcon(
      icon: IconPath.locationSectionIcon, iconHeight: 20.17, iconWidth: 16.51),
  providerServicesSectionIcon(
      icon: IconPath.providerServicesSectionIcon,
      iconHeight: 17.5,
      iconWidth: 16),
  providerOtherInfoIcon(
      icon: IconPath.providerOtherInfoIcon, iconHeight: 19.97, iconWidth: 15),
  personalInfoIcon(
      icon: IconPath.personalInfoIcon, iconHeight: 16.48, iconWidth: 15.5),
  providerEvaluationIcon(
      icon: IconPath.providerEvaluationIcon,
      iconHeight: 19.04,
      iconWidth: 20.82),
  personalInfoSectionIcon(
      icon: IconPath.personalInfoSectionIcon,
      iconHeight: 19.5,
      iconWidth: 15.5),
  callSectionIcon(
      icon: IconPath.callSectionIcon, iconHeight: 16.46, iconWidth: 16.47),
  faqSectionIcon(
      icon: IconPath.faqHeaderIcon, iconHeight: 16.46, iconWidth: 16.47),
  none(
      icon: IconPath.providerDetailsDocument,
      iconHeight: 19.5,
      iconWidth: 15.5);

  const PrimaryIcons({required this.icon, this.iconHeight, this.iconWidth});

  final String icon;
  final double? iconHeight;
  final double? iconWidth;
}
