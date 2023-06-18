import 'package:balady_plus/app/features/vd/vd_exports.dart';

import '../../../../core/utils/common_functions.dart';

List guestPages = [
  LocationPhotoSection(),
  SpecialityCategorySection(),
  GuestInfoSection(),
  //GuestOtpSection(),
  IncidentDescSection()
];

List registeredPages = [
  LocationPhotoSection(),
  SpecialityCategorySection(),
  IncidentDescSection()
];

List getPageList() {
  if (CommonProperties.isLoggedIn)
    return registeredPages;
  else
    return guestPages;
}
