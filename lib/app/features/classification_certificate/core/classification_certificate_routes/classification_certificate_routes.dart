import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_list/pages/classification_certificate_list_screen.dart';
import 'package:flutter/widgets.dart';

import '../../persentation/classification_certificate_details/pages/classification_certificate_details_screen.dart';
import '../../persentation/classification_certificate_verify/pages/classification_certificate_verify_screen.dart';
import '../../persentation/classification_certificate_verify_overview/pages/classification_certificate_verify_overview_screen.dart';
import 'classification_certificate_route_names.dart';

class ClassificationCertificateRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    ClassificationCertificateRouteName.classificationCertificateVerifyOverviewScreen: (context) =>
    const ClassificationCertificateVerifyOverviewScreen(),

    ClassificationCertificateRouteName.classificationCertificateVerifyScreen: (context) =>
    const ClassificationCertificateVerifyScreen(),

    ClassificationCertificateRouteName.classificationCertificateDetailsScreen: (context) =>
    const ClassificationCertificateDetailsScreen(),

    ClassificationCertificateRouteName.classificationCertificateListScreen: (context) =>
    const ClassificationCertificateListScreen(),


  };
}
