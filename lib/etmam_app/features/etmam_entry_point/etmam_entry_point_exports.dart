//! data
/// data -> data sources
export 'data/data_sources/etmam_entry_point_local_data_source.dart';
export 'data/data_sources/etmam_entry_point_remote_data_source.dart';

/// data -> models
export 'data/models/add_device_response_model.dart';
export 'data/models/update_device_response_model.dart';
export 'data/models/force_update_response_model.dart';

/// data -> repositories
export 'data/repositories/etmam_entry_point_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/profile.dart';
export 'domain/entities/add_device_params.dart';
export 'domain/entities/update_profile_params.dart';
export 'domain/entities/add_device_response.dart';
export 'domain/entities/update_device_params.dart';
export 'domain/entities/update_device_response.dart';
export 'domain/entities/force_update_response.dart';
export 'domain/entities/force_update_params.dart';

/// domain -> repositories
export 'domain/repositories/auth_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_profile.dart';
export 'domain/use_cases/save_profile.dart';
export 'domain/use_cases/check_profile.dart';
export 'domain/use_cases/update_profile.dart';
export 'domain/use_cases/add_device_token.dart';
export 'domain/use_cases/update_device_token.dart';
export 'domain/use_cases/get_force_version.dart';

//! presentation
/// presentation -> blocs

/// presentation -> pages

/// presentation -> widgets
