/// Presentation

// blocs
export 'presentation/commercial_license/blocs/commercial_license_bloc.dart';
export 'presentation/step9/bloc/work_times/work_times_cubit.dart';
export 'presentation/step9/bloc/periods/periods_cubit.dart';
export 'presentation/step1/bloc/cr_step1_applicant_data_cubit.dart';
export 'presentation/step2/bloc/cr_step2_activity_data_cubit.dart';

// Pages
export 'presentation/commercial_license/screens/commercial_license_screen.dart';
export 'presentation/step1/page/cr_step1_applicant_data.dart';
export 'presentation/step2/page/cr_step2_activity_data.dart';
export 'presentation/step2/page/cr_step2_conditions_page.dart';

export 'presentation/step3/page/cr_step3_geolocation_data.dart';
export 'presentation/step4/page/cr_step4_shop_data.dart';
export 'presentation/step5/page/cr_step5_attachment_data.dart';
export 'presentation/step6/page/cr_step6_establishment_data.dart';
export 'presentation/step7/page/cr_step7_establishment_contact_data.dart';
export 'presentation/step8/page/cr_step8_employee_data.dart';
export 'presentation/step9/page/cr_step9_work_times.dart';
export 'presentation/step10/page/cr_step10_additional_data.dart';

// Widgets
export 'presentation/commercial_license/widgets/commercial_license_body.dart';
export 'presentation/commercial_license/widgets/previous_next_button.dart';
export 'presentation/commercial_license/widgets/cr_header_desc.dart';
export 'presentation/step1/widgets/isic_activities_dialog_not_exist_in_balady.dart';
export 'presentation/step2/widgets/workers_type_component.dart';
export 'presentation/step2/widgets/extra_activity_card.dart';
export 'presentation/step2/widgets/extra_activity_component.dart';
export 'presentation/step4/widgets/yes_no_radio_group_widget.dart';
export 'presentation/step4/widgets/billboard_card.dart';
export 'presentation/step4/widgets/billboard_component.dart';
export 'presentation/step4/widgets/investment_contract_card.dart';

export 'presentation/step5/widgets/pick_file_component.dart';
export 'presentation/step6/widgets/owner_info_card.dart';
export 'presentation/step6/widgets/manager_info_card.dart';
export 'presentation/step8/widgets/employee_info_card.dart';
export 'presentation/step9/widgets/work_time_card.dart';
export 'presentation/step9/widgets/periods_dialog_body.dart';
export 'presentation/step9/widgets/clock_time_widget.dart';

/// Domain
// Entities
export 'domain/entities/work_times_entity.dart';
export 'domain/entities/record_info_entity.dart';
export 'domain/entities/submit_step1_params.dart';
export 'domain/entities/sub_activit_entity.dart';
export 'domain/entities/sub_activity_details_entity.dart';
export 'domain/entities/add_isic_activities_params.dart';
export 'domain/entities/cr_lookups_entity.dart';
export 'domain/entities/submit_activity_details_request.dart';
export 'domain/entities/save_location_data_request.dart';
export 'domain/entities/save_location_response.dart';
export 'domain/entities/ejar_info_request.dart';
export 'domain/entities/ejar_info_response.dart';
export 'domain/entities/deed_info_request.dart';
export 'domain/entities/deed_info_response.dart';

export 'domain/entities/investment_contracts_request.dart';
export 'domain/entities/investment_contracts_response.dart';

export 'domain/entities/clean_contracts_request.dart';
export 'domain/entities/clean_contracts_response.dart';
export 'domain/entities/cr_attachment_request.dart';
export 'domain/entities/cr_calculate_fees_request.dart';
export 'domain/entities/cr_calculate_fees_response.dart';
export 'domain/entities/cr_add_notes_request.dart';
export 'domain/entities/cr_submit_response.dart';
export 'domain/entities/credence_response.dart';
export 'domain/entities/clean_option_response.dart';
export 'domain/entities/validate_salama_attachments_reuqest.dart';

// repo
export 'domain/repositories/cr_repository.dart';

// use cases
export 'domain/use_cases/get_record_info.dart';
export 'domain/use_cases/submit_step1.dart';
export 'domain/use_cases/get_sub_activities.dart';
export 'domain/use_cases/get_sub_activity_details.dart';
export 'domain/use_cases/add_isic_activities.dart';
export 'domain/use_cases/get_accommodation_types.dart';
export 'domain/use_cases/submit_step2.dart';
export 'domain/use_cases/submit_step3.dart';
export 'domain/use_cases/upload_credence.dart';
export 'domain/use_cases/get_request_credence.dart';
export 'domain/use_cases/get_clean_options.dart';
export 'domain/use_cases/validate_salama_permit.dart';
export 'domain/use_cases/get_deed_options.dart';
export 'domain/use_cases/add_beneficiary_notes.dart';

/// Data
// data sources
export 'data/data_sources/cr_remote_data_source.dart';

// Models
export 'data/models/record_info_model.dart';
export 'data/models/sub_activity_model.dart';
export 'data/models/sub_activity_details_model.dart';
export 'data/models/cr_lookups_model.dart';
export 'data/models/save_location_response_model.dart';
export 'data/models/ejar_info_response_model.dart';
export 'data/models/deed_info_response_model.dart';
export 'data/models/investment_contracts_response_model.dart';
export 'data/models/clean_contracts_response_model.dart';
export 'data/models/cr_calculate_fees_response_model.dart';
export 'data/models/cr_submit_response_model.dart';
export 'data/models/credence_response_model.dart';
export 'data/models/clean_option_response_model.dart';

export 'data/models/qr/addetional_qr_data_request.dart';
export 'data/models/qr/save_worktimes_request.dart';

// repo
export 'data/repositories/cr_repository_impl.dart';
