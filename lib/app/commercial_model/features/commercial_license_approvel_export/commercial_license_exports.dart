/// Presentation

// blocs
export 'presentation/intial_approval/commercial_license/blocs/commercial_license_initial_export_bloc.dart';
export 'presentation/export_commercial_license/step9/bloc/work_times/work_times_cubit.dart';
export 'presentation/export_commercial_license/step9/bloc/periods/periods_cubit.dart';
export 'presentation/intial_approval/step1/bloc/step1_applicant_data_export_cubit.dart';
export 'presentation/intial_approval/step2/bloc/step2_activity_data_export_cubit.dart';

// Pages
export 'presentation/intial_approval/commercial_license/screens/commercial_license__initial_approvel_screen.dart';
export 'presentation/intial_approval/step1/page/cr_step1_applicant_data.dart';
export 'presentation/intial_approval/step2/page/step2_intial_approval__activity_data.dart';
export 'presentation/intial_approval/step2/page/step2_intial_approval_conditions_page.dart';

export 'presentation/intial_approval/step2/page/step2_intial_approval_geolocation_data.dart';
export 'presentation/export_commercial_license/step4/page/cr_step4_shop_data.dart';
export 'presentation/export_commercial_license/step5/page/cr_step5_attachment_data.dart';
export 'presentation/export_commercial_license/step6/page/cr_step6_establishment_data.dart';
export 'presentation/export_commercial_license/step7/page/cr_step7_establishment_contact_data.dart';
export 'presentation/export_commercial_license/step8/page/cr_step8_employee_data.dart';
export 'presentation/export_commercial_license/step9/page/cr_step9_work_times.dart';
export 'presentation/export_commercial_license/step10/page/cr_step10_additional_data.dart';

// Widgets
export 'presentation/intial_approval/commercial_license/widgets/commercial_license_body.dart';
export 'presentation/intial_approval/commercial_license/widgets/previous_next_button.dart';
export 'presentation/intial_approval/commercial_license/widgets/cr_header_desc.dart';
export 'presentation/intial_approval/step1/widgets/isic_activities_dialog_not_exist_in_balady.dart';
export 'presentation/intial_approval/step2/widgets/workers_type_component.dart';
export 'presentation/intial_approval/step2/widgets/extra_activity_card.dart';
export 'presentation/intial_approval/step2/widgets/extra_activity_component.dart';
export 'presentation/export_commercial_license/step4/widgets/yes_no_radio_group_widget.dart';
export 'presentation/export_commercial_license/step4/widgets/billboard_card.dart';
export 'presentation/export_commercial_license/step4/widgets/billboard_component.dart';
export 'presentation/export_commercial_license/step4/widgets/investment_contract_card.dart';

export 'presentation/export_commercial_license/step5/widgets/pick_file_component.dart';
export 'presentation/export_commercial_license/step6/widgets/owner_info_card.dart';
export 'presentation/export_commercial_license/step6/widgets/manager_info_card.dart';
export 'presentation/export_commercial_license/step8/widgets/employee_info_card.dart';
export 'presentation/export_commercial_license/step9/widgets/work_time_card.dart';
export 'presentation/export_commercial_license/step9/widgets/periods_dialog_body.dart';
export 'presentation/export_commercial_license/step9/widgets/clock_time_widget.dart';

/// Domain
// Entities
export 'domain/entities/work_times_entity.dart';
export 'domain/entities/record_info_entity.dart';
export 'domain/entities/submit_step1_params.dart';
export 'domain/entities/sub_activit_entity.dart';
export 'domain/entities/sub_activity_details_entity.dart';
export 'data/models/initialApproval/add_isic_activity_data.dart';
export 'data/models/initialApproval/submit_activity_details_request.dart';
export 'domain/entities/save_location_data_request.dart';
export 'domain/entities/save_location_response.dart';
export 'domain/entities/ejar_info_request.dart';
export 'domain/entities/deed_info_request.dart';
export 'domain/entities/investment_contracts_request.dart';
export 'domain/entities/clean_contracts_request.dart';
export 'domain/entities/cr_attachment_request.dart';
export 'domain/entities/cr_calculate_fees_request.dart';
export 'domain/entities/cr_add_notes_request.dart';
export 'domain/entities/validate_salama_attachments_reuqest.dart';

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
export 'domain/use_cases/upload_credence.dart';
export 'domain/use_cases/get_request_credence.dart';
export 'domain/use_cases/get_clean_options.dart';
export 'domain/use_cases/validate_salama_permit.dart';
export 'domain/use_cases/get_deed_options.dart';
export 'domain/use_cases/add_beneficiary_notes.dart';

/// Data
// data sources
export 'data/data_sources/remote_data_source.dart';

// Models
export 'data/models/record_info_model.dart';
export 'data/models/initialApproval/sub_activity_model.dart';
export 'data/models/sub_activity_details_model.dart';
export 'data/models/lookups_model.dart';
export 'data/models/save_location_response_model.dart';
export 'data/models/ejar_info_response_model.dart';
export 'data/models/deed_info_response_model.dart';
export 'data/models/investment_contracts_response_model.dart';
export 'data/models/clean_contracts_response_entity.dart';
export 'data/models/calculate_fees_response_model.dart';
export 'data/models/initialApproval/submit_request_response_model.dart';
export 'data/models/credence_response_model.dart';
export 'data/models/clean_option_response_entity.dart';

export 'data/models/qr/additional_qr_data_request_model.dart';
export 'data/models/qr/save_worktimes_request_model.dart';

// repo
export 'data/repositories/repository_impl.dart';
