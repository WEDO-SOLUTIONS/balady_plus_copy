import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/commercial_debts_list_screen.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/request_details/presentation/pages/RequestDetailsPage.dart';
import 'package:flutter/widgets.dart';
import '../features/commercial_license_approvel_export/presentation/export_commercial_license/license_export_intiation/screens/export_license_start_service_screen.dart';
import '../features/commercial_license_approvel_export/presentation/intial_approval/commercial_license/screens/commercial_license__initial_approvel_screen.dart';
import '../features/commercial_license_approvel_export/presentation/intial_approval/intial_approval_successfully.dart';
import '../features/commercial_license_approvel_export/presentation/intial_approval/step2/page/export_map_page.dart';
import '../features/commercial_license_approvel_export/presentation/intial_approval/start_service_initial_approval_screen.dart';

import 'commercial_route_names.dart';
import '../features/comercial_license_renew/presentation/commercial_license/screens/renew_commercial_license_screen.dart';
import '../features/comercial_license_renew/presentation/commercial_license/screens/renew_start_service_screen.dart';
import '../features/comercial_license_renew/presentation/commercial_license/screens/submit_application_successfully_renew.dart';
import '../features/commercial_license/presentation/commercial_license/screens/commercial_license_screen.dart';
import '../features/commercial_license/presentation/step3/page/cr_map_page.dart';
import '../features/commercial_license/presentation/step6/page/commercial_otp_screen.dart';
import '../features/commercial_license/presentation/submit_application_successfully_new.dart';
import '../features/commercial_license_cancel/presentation/apply_cancel/screens/apply_cancel_screen.dart';
import '../features/commercial_license_cancel/presentation/commercial_license_cancel/screens/commercial_license_cancel_screen.dart';
import '../features/commercial_license_cancel/presentation/submit_application_successfully_cancel/screens/submit_application_successfully_cancel.dart';
import '../features/commercial_license_cancel/presentation/submit_application_successfully_cancel/screens/submit_rating_cancel_screen.dart';
import '../features/commercial_license_details/presentation/pages/commercial_license_details_page.dart';
import '../features/commercial_license_inquery/persentation/commercial_license_query/commercial_license_query_screen.dart';
import '../features/commercial_license_inquery/persentation/commercial_license_query_Details/commercial_license_query_details.dart';
import '../features/commercial_license_ownership_transfer/old_owner_transfer/persentation/commercail_license_tranfer_overview/commercial_license_transfer_overview_screen.dart';
import '../features/commercial_license_ownership_transfer/old_owner_transfer/persentation/license_premits/request_sequence_home.dart';
import '../features/commercial_license_ownership_transfer/old_owner_transfer/persentation/license_premits/sucessfull_page.dart';
import '../features/commercial_license_ownership_transfer/request_details/presentation/pages/request_ownership_transfer_details_page.dart';
import '../features/commercial_license_ownership_transfer/approval_sequence/presentation/screens/approval_sequence_main_screen.dart';
import '../features/pemrit_24_hour/presentation/pages/permits_details_page.dart';
import '../features/pemrit_24_hour/presentation/pages/posters_start_service_license_screen.dart';
import '../features/pemrit_24_hour/presentation/pages/request_details_page.dart';
import '../features/pemrit_24_hour/presentation/pages/submit_application_successfully_posters.dart';
import '../features/pemrit_tobacco/presentation/pages/permits_details_page.dart';
import '../features/pemrit_tobacco/presentation/pages/posters_start_service_license_screen.dart';
import '../features/pemrit_tobacco/presentation/pages/request_details_page.dart';
import '../features/pemrit_tobacco/presentation/pages/submit_application_successfully_tobacco.dart';
import '../features/posters/presentation/pages/posters_details_page.dart';
import '../features/posters/presentation/pages/posters_start_service_license_screen.dart';
import '../features/posters/presentation/pages/posters_start_service_screen.dart';
import '../features/posters/presentation/pages/request_details_page.dart';
import '../features/posters/presentation/pages/submit_application_successfully_posters.dart';
import '../features/request_commercial_license_details/presentation/pages/request_commercial_license_details_page.dart';
import '../features/tobacco_services/presentation/submit_disclosed_successfully/screens/submit_disclosed_successfully_screen.dart';
import '../features/tobacco_services/presentation/tobacco_details/pages/tobacco_details_page.dart';
import '../features/tobacco_services/presentation/tobacco_disclosed/screens/tobacco_disclosed_screen.dart';
import '../features/tobacco_services/presentation/tobacco_list/pages/tobacco_list_page.dart';

class CommercialRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    CommercialRouteName.approvalSequenceMainScreen: (context) =>
        const ApprovalSequenceMainScreen(),

    CommercialRouteName.requestOwnershipTransferDetailsPage: (context) =>
        const RequestOwnershipTransferDetailsPage(),

    CommercialRouteName.commercialLicenseTransferOverView: (context) =>
        const CommercialLicenseTransferOverviewScreen(),
    CommercialRouteName.SucessfullScreen: (context) => SucessfullScreen(),
    CommercialRouteName.homeSequence: (context) =>
        const RequestSequenceHomeScreen(),

    CommercialRouteName.commercialLicenseQuery: (context) =>
        const CommercialLicenseQueryScreen(),
    CommercialRouteName.commercialLicenseQueryDetails: (context) =>
        const CommercialLicenseQueryDetails(),

    CommercialRouteName.commercialLicensePage: (context) =>
        const CommercialLicenseScreen(),
// -------  Commercial License Cancel ---------
    CommercialRouteName.commercialLicenseApplyCancel: (context) =>
        const ApplyCancelScreen(),
    CommercialRouteName.commercialLicenseCancel: (context) =>
        const CommercialLicenseCancelScreen(),
    CommercialRouteName.submitApplicationSuccessfullyCancel: (context) =>
        const SubmitApplicationSuccessfullyCancel(),
    CommercialRouteName.submitRatingCancelScreen: (context) =>
        const SubmitRatingCancelScreen(),

    CommercialRouteName.commercialLicenseDetails: (context) =>
        const CommercialLicenseDetailsPage(),

// ISSUE Commercial
    CommercialRouteName.crMapScreen: (context) => CRMapScreen(),
    CommercialRouteName.CommercialOtpScreen: (context) => CommercialOtpScreen(),

    CommercialRouteName.requestCommercialLicenseDetails: (context) =>
        const RequestCommercialLicenseDetailsPage(),

// Renew Commercial
    CommercialRouteName.renewCommercialLicenseStartService: (context) =>
        const RenewStartService(),

    CommercialRouteName.renewCommercialLicenseSubmitForm: (context) =>
        const RenewCommercialLicenseScreen(),

    CommercialRouteName.submitApplicationSuccessfullyRenew: (context) =>
        const SubmitApplicationSuccessfullyRenew(),
    CommercialRouteName.submitApplicationSuccessfullyNew: (context) =>
        const SubmitApplicationSuccessfullyNew(),
  CommercialRouteName.IntialApprovalSuccessfullyPage: (context) =>
  const IntialApprovalSuccessfullyPage(),


// Posters
    CommercialRouteName.postersStartService: (context) =>
        const PostersStartService(),

    CommercialRouteName.postersLicenseStartService: (context) =>
        const PostersLicenseStartService(),
    CommercialRouteName.postersDetailsPage: (context) =>
        const PostersDetailsPage(),
    CommercialRouteName.submitApplicationSuccessfullyPosters: (context) =>
        const SubmitApplicationSuccessfullyPosters(),

    CommercialRouteName.posterReqeuestDetailsPage: (context) =>
        const PostersReqeuestDetailsPage(),
    CommercialRouteName.tobaccoServicesList: (context) =>
        const TobaccoListPage(),
    CommercialRouteName.tobaccoDetails: (context) => const TobaccoDetailsPage(),
    CommercialRouteName.tobaccoDisclosed: (context) =>
        const TobaccoDisclosedScreen(),
    CommercialRouteName.submitDisclosedSuccessfully: (context) =>
        const SubmitDisclosedSuccessfullyScreen(),

// Permits 24
    CommercialRouteName.permitsLicenseStartService: (context) =>
        const PermitsLicenseStartService(),
    CommercialRouteName.permitsDetailsPage: (context) =>
        const Permits24DetailsPage(),

    CommercialRouteName.permitsRequestDetailsPage: (context) =>
        const PermitsReqeuestDetailsPage(),

    CommercialRouteName.submitApplicationSuccessfullyPermits: (context) =>
        const SubmitApplicationSuccessfullyPermits(),

// Tobacco Permits

    CommercialRouteName.permitsTobaccoLicenseStartService: (context) =>
        const PermitsTobaccoLicenseStartService(),
    CommercialRouteName.permitsTobaccoDetailsPage: (context) =>
        const PermitsTobaccoDetailsPage(),

    CommercialRouteName.permitsTobaccoRequestDetailsPage: (context) =>
        const PermitsTobaccoReqeuestDetailsPage(),

    CommercialRouteName.submitApplicationSuccessfullyTobaccoPermits:
        (context) => const SubmitApplicationSuccessfullyTobacco(),

  // Debts
    CommercialRouteName.commercialDebtsListScreen: (context) =>
        const CommercialDebtsListScreen(),



    //Commercial approvel export
    CommercialRouteName.LicenseIntialApprovalStartService: (context) => const InitialApprovalStartServicePage(),

    CommercialRouteName.CommercialLicenseInitialApprovelScreen: (context) => const CommercialLicenseInitialApprovelScreen(),
    CommercialRouteName.ExportMapScreen: (context) => ExportMapScreen(),

      CommercialRouteName.IntialApprovalRequestDetailsPage: (context) =>  RequestDetailsPage(),
    CommercialRouteName.LicenseExportStartServicePage: (context) => const LicenseExportStartServicePage(),







};
}
