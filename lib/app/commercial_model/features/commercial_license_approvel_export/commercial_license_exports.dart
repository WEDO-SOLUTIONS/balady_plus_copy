/// Presentation

// blocs
export 'presentation/intial_approval/commercial_license/blocs/commercial_license_initial_Approval_bloc.dart';
export 'presentation/intial_approval/step1/bloc/step1_applicant_data_export_cubit.dart';
export 'presentation/intial_approval/step2/bloc/step2_activity_data_export_cubit.dart';

// Pages
export 'presentation/intial_approval/commercial_license/screens/commercial_license__initial_approvel_screen.dart';
export 'presentation/intial_approval/step1/page/cr_step1_applicant_data.dart';
export 'presentation/intial_approval/step2/page/step2_intial_approval__activity_data.dart';
export 'presentation/intial_approval/step2/page/step2_intial_approval_conditions_page.dart';

export 'presentation/intial_approval/step2/page/step2_intial_approval_geolocation_data.dart';


// Widgets
export 'presentation/intial_approval/commercial_license/widgets/commercial_license_body.dart';
export 'presentation/intial_approval/commercial_license/widgets/intial_approval_previous_next_button.dart';
export 'presentation/intial_approval/commercial_license/widgets/cr_header_desc.dart';
export 'presentation/intial_approval/step1/widgets/isic_activities_dialog_not_exist_in_balady.dart';
export 'presentation/intial_approval/step2/widgets/workers_type_component.dart';
export 'presentation/intial_approval/step2/widgets/extra_activity_card.dart';
export 'presentation/intial_approval/step2/widgets/extra_activity_component.dart';

/// Domain
// Entities

export 'domain/entities/sub_activit_entity.dart';
export 'domain/entities/sub_activity_details_entity.dart';
export 'data/models/initialApproval/add_isic_activity_data.dart';
export 'data/models/initialApproval/submit_activity_details_request.dart';
export 'domain/entities/save_location_data_request.dart';
export 'domain/entities/save_location_response.dart';

export 'domain/entities/cr_calculate_fees_request.dart';


// repo
export 'domain/repositories/repository.dart';

// use cases
export 'domain/use_cases/get_initial_approval_request_details.dart';
export 'domain/use_cases/step1_initial_approval_apply.dart';
export 'domain/use_cases/get_sub_activities.dart';
export 'domain/use_cases/get_sub_activity_details.dart';
export 'domain/use_cases/step1_add_isic_activities.dart';
export 'domain/use_cases/get_accommodation_types.dart';
export 'domain/use_cases/step2_save_activity_details.dart';
export 'domain/use_cases/step2_save_location_details.dart';

/// Data
// data sources
export 'data/data_sources/remote_data_source.dart';

// Models

export 'data/models/initialApproval/sub_activity_model.dart';

export 'data/models/lookups_model.dart';
export 'data/models/save_location_response_model.dart';

export 'data/models/calculate_fees_response_model.dart';
export 'data/models/initialApproval/submit_request_response_model.dart';


// repo
export 'data/repositories/repository_impl.dart';
