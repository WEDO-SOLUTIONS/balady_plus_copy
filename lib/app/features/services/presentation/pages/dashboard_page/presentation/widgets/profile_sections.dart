import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../core/utils/utils_exports.dart'
    show CommonProperties, IconPath, RouteName;
import '../../dashboard_page_exports.dart';

class ProfileSections {
  static List<ProfileSection> get profileSections => [personalProfile];
  static List<ProfileSection> get profileSectionsForGuest => [support, general];

  static ProfileSection get personalProfile => ProfileSection(
        title: 'personal_profile'.tr(),
        items: [
          /* ProfileItem(
            title: "personal_information".tr(),
            icon: IconPath.personalInformation,
            route: RouteName.personalInformation,
            args: CommonProperties.userInfo,
          ),*/
          ProfileItem(
            title: "dashboard".tr(),
            icon: IconPath.dashboard,
            beta: false,
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
            route: RouteName.licenses,
          ),
          ProfileItem(
            title: "invoices".tr(),
            icon: IconPath.invoices,
            route: RouteName.invoices,
          ),
          ProfileItem(
            title: "reports".tr(),
            icon: IconPath.reports,
            route: RouteName.incRequestsPage,
          ),
          ProfileItem(
            title: "violations".tr(),
            icon: IconPath.violations,
            route: RouteName.violationsPage,
          ),
          ProfileItem(
            title: "objections".tr(),
            icon: IconPath.objections,
            route: RouteName.objections,
          ),
          ProfileItem(
            title: "bottomNavigationBarDigitalWalletWord".tr(),
            icon: IconPath.wallet,
            route: RouteName.walletPage,
          ),
          ProfileItem(
            title: "appointments".tr(),
            icon: IconPath.appiontments,
            route: RouteName.AppointmentsListScreen,
          ),
        ],
      );
  static ProfileSection get support => ProfileSection(
        title: 'support'.tr(),
        items: [
          ProfileItem(
            title: "help".tr(),
            icon: IconPath.helpNew,
            route: RouteName.help,
          ),
        ],
      );
  static ProfileSection get general => ProfileSection(
        title: 'general'.tr(),
        items: [
          ProfileItem(
            title: "rate_app".tr(),
            icon: IconPath.rateApp,
            route: RouteName.rateUs,
          ),
          ProfileItem(
            title: "about_balady".tr(),
            icon: IconPath.aboutBalady,
            route: RouteName.aboutBalady,
          )
        ],
      );
}
