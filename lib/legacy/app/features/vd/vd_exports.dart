//! data
/// data -> data sources
export 'data/data_sources/vd_local_data_source.dart';
export 'data/data_sources/vd_remote_data_source.dart';

/// data -> models
export 'data/model/categories/category_item_model.dart';
export 'data/model/categories/category_response_model.dart';

export 'data/model/gis_response_model.dart';

/// data -> repositories
export 'data/repositories/vd_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/categories/category_item.dart';
export 'domain/entities/categories/category_params.dart';
export 'domain/entities/categories/category_response.dart';
export 'domain/entities/camera/camera_page_params.dart';

export 'domain/entities/camera/attachment_item.dart';
export 'domain/entities/gis/gis_response.dart';
export 'domain/entities/gis/gis_params.dart';
export 'domain/entities/map/map_screen_params.dart';

/// domain -> repositories
export 'domain/repositories/vd_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_gis_data.dart';


//! presentation
/// presentation -> blocs

/// presentation -> dialogs

/// presentation -> pages

/// presentation -> widgets
// details widgets

// details widgets -> spl widgets
