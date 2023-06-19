/// data
/// data -> data sources
export 'data/data_sources/remote_data_source.dart';

/// data -> models
export 'data/models/licenses_model.dart';
export 'data/models/license_status_model.dart';
export 'data/models/license_subtype_model.dart';
export 'data/models/license_subtype_params_model.dart';
export 'data/models/license_type_model.dart';
export 'data/models/licenses_params_model.dart';

/// data -> repositories
export 'data/repositories/repository_implementation.dart';

/// domain
/// domain -> entities
export 'domain/entities/license_entity.dart';
export 'domain/entities/license_status_entity.dart';
export 'domain/entities/license_sub_type_entity.dart';
export 'domain/entities/license_sub_type_params.dart';
export 'domain/entities/license_type_entity.dart';
export 'domain/entities/licenses_params.dart';

/// domain -> repositories
export 'domain/repositories/repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_license_statuses.dart';
export 'domain/use_cases/get_license_types.dart';
export 'domain/use_cases/get_licenses.dart';
export 'domain/use_cases/get_license_sub_types.dart';

/// presentation
/// presentation -> bloc
export 'presentation/licenses_bloc/licenses_bloc.dart';

/// presentation -> pages
export 'presentation/pages/licenses_page.dart';

/// presentation -> widgets
export 'presentation/widgets/licenses_list_item.dart';
export 'presentation/widgets/licenses_list_shimmer.dart';
export 'presentation/widgets/license_parameter.dart';
