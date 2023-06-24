//! data
/// data -> data sources
export 'data/data_sources/vd_local_data_source.dart';
export 'data/data_sources/vd_remote_data_source.dart';

/// data -> models
export 'data/model/details_pages_list_model.dart';
export 'data/model/categories/category_item_model.dart';
export 'data/model/categories/category_response_model.dart';
export 'data/model/special_classifications/special_classifications_item_model.dart';
export 'data/model/special_classifications/special_classifications_response_model.dart';
export 'data/model/gis_response_model.dart';

export 'data/model/spl_details/value_item_model.dart';
export 'data/model/spl_details/spl_details_response_model.dart';
export 'data/model/upload_file_response_model.dart';
export 'data/model/otp_response_model.dart';
export 'data/model/create_incident/create_incident_response_model.dart';
export 'data/model/spl_details/supporting_materials_item.dart';

/// data -> repositories
export 'data/repositories/vd_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/categories/category_item.dart';
export 'domain/entities/categories/category_params.dart';
export 'domain/entities/categories/category_response.dart';
export 'domain/entities/special_classifications/special_classifications_item.dart';
export 'domain/entities/special_classifications/special_classifications_response.dart';
export 'domain/entities/special_classifications/spl_params.dart';
export 'domain/entities/create_vd_page_params.dart';
export 'domain/entities/camera/camera_page_params.dart';

export 'domain/entities/camera/attachment_item.dart';
export 'domain/entities/gis/gis_response.dart';
export 'domain/entities/gis/gis_params.dart';
export 'domain/entities/map/map_screen_params.dart';

export 'domain/entities/spl_details/additional_details_item.dart';
export 'domain/entities/spl_details/spl_details_response.dart';
export 'domain/entities/spl_details/value_item.dart';
export 'domain/entities/spl_details/spl_details_params.dart';
export 'domain/entities/spl_details/supporting_materials_item.dart';

export 'domain/entities/upload/upload_file_params.dart';
export 'domain/entities/upload/upload_file_response.dart';

export 'domain/entities/otp/otp_params.dart';
export 'domain/entities/otp/otp_response.dart';

export 'domain/entities/create_incident/create_incident_params.dart';
export 'domain/entities/create_incident/create_incident_response.dart';

/// domain -> repositories
export 'domain/repositories/vd_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_categories.dart';
export 'domain/use_cases/get_special_classifications.dart';
export 'domain/use_cases/get_spl_details.dart';
export 'domain/use_cases/get_gis_data.dart';
export 'domain/use_cases/get_otp.dart';
export 'domain/use_cases/upload_file.dart';
export 'domain/use_cases/create_incident_registered.dart';
export 'domain/use_cases/create_incident_unregistered.dart';
export 'domain/use_cases/check_cr.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/camera_bloc/camera_bloc.dart';
export 'presentation/blocs/vd_category_bloc/vd_category_bloc.dart';
export 'presentation/blocs/promoted_category_bloc/promoted_category_bloc.dart';

export 'presentation/blocs/create_vd_details_bloc/create_vd_bloc.dart';
export 'presentation/blocs/map_bloc/map_bloc.dart';

/// presentation -> dialogs
export 'presentation/dialogs/vd_types_dialog.dart';

/// presentation -> pages
export 'presentation/pages/camera_page/camera_page.dart';
export 'presentation/pages/details_page/create_vd_page.dart';
export 'presentation/pages/map_page/vd_map_page.dart';
export 'presentation/pages/guest_otp_page/vd_guest_otp_screen.dart';

/// presentation -> widgets
export 'presentation/widgets/vd_header_desc_widget.dart';
export 'presentation/widgets/vd_header_desc_search.dart';

// camera widgets
export 'presentation/widgets/camera_widgets/camera_app_bar.dart';
export 'presentation/widgets/camera_widgets/camera_view_widget.dart';
export 'presentation/widgets/camera_widgets/photo_preview_widget.dart';

// details widgets
export 'presentation/widgets/details_widgets/details_app_bar.dart';
export 'presentation/widgets/details_widgets/guest_info_section.dart';
export 'presentation/widgets/details_widgets/incident_desc_section.dart';
export 'presentation/widgets/details_widgets/location_photo_section.dart';
export 'presentation/widgets/details_widgets/specialty_category_section.dart';
export 'presentation/widgets/details_widgets/previous_next_buttons.dart';
export 'presentation/widgets/details_widgets/location_warning_widget.dart';

// details widgets -> spl widgets
export 'presentation/widgets/details_widgets/spl_widgets/spl_types_card.dart';
export 'presentation/widgets/details_widgets/spl_widgets/spl_empty_widget.dart';
export 'presentation/widgets/details_widgets/spl_widgets/spl_images_list_widget.dart';
export 'presentation/widgets/details_widgets/spl_widgets/incident_photo_widget.dart';

// details widgets -> incident desc widgets
export 'presentation/widgets/details_widgets/incident_desc_widgets/vd_additional_fields.dart';
export 'presentation/widgets/details_widgets/incident_desc_widgets/vd_fields_section.dart';
export 'presentation/widgets/details_widgets/incident_desc_widgets/vd_agreement_section.dart';
export 'presentation/widgets/details_widgets/cr_text_field.dart';
