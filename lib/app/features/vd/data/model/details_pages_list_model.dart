import 'package:balady_plus/app/features/vd/vd_exports.dart';

import '../../../../core/utils/common_functions.dart';
import '../../presentation/widgets/summery_widgets/summury_section.dart';

List guestPages = [
  LocationPhotoSection(),
  SpecialityCategorySection(),
  GuestInfoSection(),
  //GuestOtpSection(),
  IncidentDescSection(),
  SummurySection()
];

List registeredPages = [
  LocationPhotoSection(),
  SpecialityCategorySection(),
  IncidentDescSection(),
  SummurySection()
];

List getPageList() {
  if (CommonProperties.isLoggedInMunicipality)
    return registeredPages;
  else
    return guestPages;
}
