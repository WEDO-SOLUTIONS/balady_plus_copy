/// data
/// data -> models
export 'presentation/core/models/msr_types_model.dart';
export 'presentation/core/models/download_file_result.dart';

/// presentation
/// presentation -> pages

/// presentation -> pages -> inquiry
export 'presentation/pages/inquiry/general_inquiry/new_general_inquiry.dart';
export 'presentation/pages/inquiry/transactions_inquiry/new_transaction_inquiry.dart';
export 'presentation/pages/inquiry/transactions_inquiry/inquiry_details_screen.dart';

/// presentation -> pages -> request service section -> new request service
export 'presentation/pages/request_service/new_request_service/new_request_service_location_screen.dart';
export 'presentation/pages/request_service/new_request_service/new_request_service_details_screen.dart';
export 'presentation/pages/request_service/request_service_details_screen.dart';

/// presentation -> dialogs
export 'presentation/dialogs/new_request_types_dialog.dart';
export 'presentation/dialogs/municipality_dialog_msr.dart';

/// presentation -> widgets -> inquiry
export 'presentation/widgets/inquiry/inquiry_result_body.dart';

/// presentation -> widgets -> request_service
export 'presentation/widgets/request_service/attachment_list.dart';
export 'presentation/widgets/request_service/attachment_widget.dart';
export 'presentation/widgets/request_service/attachment_section.dart';
export 'presentation/widgets/request_service/pdf_view.dart';

/// presentation -> core
/// presentation -> core -> services
export 'presentation/core/services/customer_voice_repository.dart';

/// presentation -> core -> view models

export 'presentation/core/view_models/msr/new_msr_details_view_model.dart';
export 'presentation/core/view_models/msr/new_msr_map_view_model.dart';
export 'presentation/core/view_models/msr/new_msr_view_model.dart';

/// presentation -> core -> models
export 'presentation/core/models/gis_location_result.dart';
export 'presentation/core/models/classification.dart';
export 'presentation/core/models/gis_location_result.dart';

export 'presentation/core/models/create_incident_result.dart';
export 'presentation/core/models/upload_file_result.dart';

export 'presentation/core/models/attachment_model.dart';
export 'presentation/core/models/attachment_model.dart';
export 'presentation/core/models/error_result.dart';

/// presentation -> core -> view models
export 'presentation/core/view_models/inquiry/inquiry_view_model.dart';
export 'presentation/core/view_models/inquiry/transaction_inquiry_view_model.dart';

/// presentation -> core -> models
export 'presentation/core/models/selected_location.dart';

export 'presentation/core/models/classification_response_model.dart';

export 'presentation/core/models/request_details_response.dart'
    hide QuestionList;
export 'presentation/core/models/request_details_screen_args.dart';
