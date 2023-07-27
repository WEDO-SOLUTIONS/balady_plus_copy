/// data

/// presentation -> pages
export 'presentation/pages/cancel_license_screen.dart';
export 'presentation/pages/renew_license_screen.dart';
export 'presentation/pages/renew_license_screen_new.dart';

export 'presentation/pages/health_license_details_screen.dart';
export 'presentation/pages/health_request_details_screen.dart';
export 'presentation/pages/cancel_license_screen_new.dart';

/// presentation -> pages -> add new license
export 'presentation/pages/add_new_license/certificate_info_step_screen.dart';
export 'presentation/pages/add_new_license/pledges_step_screen.dart';
export 'presentation/pages/add_new_license/issue_certificate_screen.dart';

/// presentation -> widgets
export 'presentation/widgets/license_details_big_header.dart';
export 'presentation/widgets/map_screen.dart';

/// presentation -> widgets -> issue certificate widgets

/// presentation -> widgets -> license details widgets
export 'presentation/widgets/license_details_widgets/bill_body_section_widget.dart';
export 'presentation/widgets/license_details_widgets/bill_footer_section_widget.dart';
export 'presentation/widgets/license_details_widgets/license_footer_section_widget.dart';
export 'presentation/widgets/license_details_widgets/order_body_section_widget.dart';
export 'presentation/widgets/license_details_widgets/order_footer_section_widget.dart';

/// presentation -> widgets -> renew certificate widgets
export 'presentation/widgets/renew_certificate_widgets/renew_certificate_footer_widget.dart';
export 'presentation/widgets/cancel_certificate_widgets/cancel_certificate_footer_widget.dart';

/// presentation -> dialogs
export 'presentation/dialogs/confirm_cancel_license_dialog.dart';
export 'presentation/dialogs/add_new_license_dialog.dart';
export 'presentation/dialogs/submit_new_license_dialog.dart';
export 'presentation/dialogs/delete_order_confirmation_dialog.dart';

/// presentation -> core -> services

/// presentation -> core -> services -> repository
export 'presentation/core/services/repository/health_license_repository.dart';

/// presentation -> core -> services -> view models
export 'presentation/core/services/view_models/new_details_health_license_view_model.dart';
export 'presentation/core/services/view_models/new_health_license_view_model.dart';
export 'presentation/core/services/view_models/new_terms_health_license_view_model.dart';
export 'presentation/core/services/view_models/main_health_license_view_model.dart';
export 'presentation/core/services/view_models/health_request_details_view_model.dart';

/// presentation -> core -> models
export 'presentation/core/models/validate_health_certificate_response.dart';
export 'presentation/core/models/cr_information.dart'
    hide Data, Result, StatusDetail;

export 'presentation/core/models/license_for_health_information_response.dart'
    hide Data, Result, StatusDetail;

export 'presentation/core/models/health_request_details.dart'
    hide Data, Result, StatusDetail;

export 'presentation/core/models/cancel_health_certificate_response.dart'
    hide Data, Result, StatusDetail;

export 'presentation/core/models/health_request_details_screen_args.dart';
export 'presentation/core/models/delete_request_response.dart'
    hide Data, StatusDetail;

export 'presentation/core/models/rating_info_response.dart'
    hide Data, Result, StatusDetail;

export 'presentation/core/models/submit_new_request_response.dart'
    hide Data, Result, StatusDetail;
