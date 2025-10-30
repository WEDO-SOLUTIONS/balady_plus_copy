//! data
/// data -> data sources
export 'data/data_sources/dc_remote_data_source.dart';

/// data -> models
//export 'data/model/details_pages_list_model.dart';

//export 'data/model/spl_details/value_item_model.dart';
export 'data/model/car_model_model.dart';
export 'data/model/car_type_model.dart';

/// data -> repositories
export 'data/repositories/dc_repository_impl.dart';

//! domain
/// domain -> entities

export 'domain/entities/car_model.dart';
export 'domain/entities/car_type.dart';
export 'domain/entities/active_location_params.dart';

/// domain -> repositories
export 'domain/repositories/dc_repository.dart';

/// domain -> use cases
export 'domain/use_cases/create_incident_registered.dart';
export 'domain/use_cases/upload_file.dart';
export 'domain/use_cases/get_car_models.dart';
export 'domain/use_cases/get_car_types.dart';
export 'domain/use_cases/check_active_location.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/create_dc_request/camera_bloc/dc_camera_bloc.dart';
export 'presentation/blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';
export 'presentation/blocs/create_dc_request/map_bloc/dc_map_bloc.dart';

/// presentation -> dialogs
//export 'presentation/dialogs/vd_types_dialog.dart';

/// presentation -> pages
export 'presentation/pages/create_dc_request/camera_page/dc_camera_page.dart';
export 'presentation/pages/create_dc_request/details_page/create_dc_page.dart';
export 'presentation/pages/create_dc_request/map_page/dc_map_page.dart';

/// presentation -> widgets

export 'presentation/widgets/create_dc_request/camera_widgets/camera_view_widget.dart';
export 'presentation/widgets/create_dc_request/camera_widgets/camera_widget.dart';
export 'presentation/widgets/create_dc_request/camera_widgets/photo_preview_widget.dart';

export 'presentation/widgets/create_dc_request/details_widgets/details_app_bar.dart';
export 'presentation/widgets/create_dc_request/details_widgets/incident_desc_section.dart';
export 'presentation/widgets/create_dc_request/details_widgets/incident_desc_widgets/vd_fields_section.dart';
export 'presentation/widgets/create_dc_request/details_widgets/incident_photo_widget.dart';
export 'presentation/widgets/create_dc_request/details_widgets/location_photo_section.dart';
export 'presentation/widgets/create_dc_request/details_widgets/previous_next_buttons.dart';
export 'presentation/widgets/create_dc_request/details_widgets/incident_car_info_section.dart';
export 'presentation/widgets/create_dc_request/details_widgets/incident_plate_info_section.dart';
