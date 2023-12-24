// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:balady_plus/app/features/wallet/core/models/wallet_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/paths/icon_paths.dart';

class WalletType {
  LicenseTypes types;
  String title;
  String icon;
  WalletType({
    required this.types,
    required this.title,
    required this.icon,
  });
}

List<WalletType> wallerTypesData = [
  WalletType(
      icon: IconPath.card,
      title: "municipal_shop",
      types: LicenseTypes.peddler),
  WalletType(
      icon: IconPath.personalCard,
      title: "healthCertificates",
      types: LicenseTypes.health)
];
