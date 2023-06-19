import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show IconPath, RouteName;
import '../../profile_exports.dart';

class ProfileSections {
  static List<ProfileSection> get profileSections =>
      [personalProfile, support, general];

  static ProfileSection get personalProfile => ProfileSection(
        title: 'personal_profile'.tr(),
        items: [
          ProfileItem(
            title: "personal_information".tr(),
            icon: IconPath.personalInformation,
            route: "",
          ),
          ProfileItem(
            title: "dashboard".tr(),
            icon: IconPath.dashboard,
            beta: true,
            route: RouteName.dashboard,
          ),
          ProfileItem(
            title: "requests".tr(),
            icon: IconPath.requests,
            route: RouteName.requests,
          ),
          ProfileItem(
            title: "licenses".tr(),
            icon: IconPath.licenses,
            route: "",
          ),
          ProfileItem(
            title: "invoices".tr(),
            icon: IconPath.invoices,
            route: RouteName.invoices,
          ),
          ProfileItem(
            title: "reports".tr(),
            icon: IconPath.reports,
            route: "",
          ),
          ProfileItem(
            title: "violations".tr(),
            icon: IconPath.violations,
            route: "",
          ),
          ProfileItem(
            title: "objections".tr(),
            icon: IconPath.objections,
            route: "",
          ),
          ProfileItem(
            title: "appointments".tr(),
            icon: IconPath.appiontments,
            route: "",
          ),
        ],
      );
  static ProfileSection get support => ProfileSection(
        title: 'support'.tr(),
        items: [
          ProfileItem(
            title: "settings".tr(),
            icon: IconPath.settings,
            route: "",
          ),
          ProfileItem(
            title: "help".tr(),
            icon: IconPath.help,
            route: "",
          ),
        ],
      );
  static ProfileSection get general => ProfileSection(
        title: 'general'.tr(),
        items: [
          ProfileItem(
            title: "rate_app".tr(),
            icon: IconPath.rateApp,
            route: "",
          ),
          ProfileItem(
            title: "about_balady".tr(),
            icon: IconPath.aboutBalady,
            route: "",
          )
        ],
      );
}
