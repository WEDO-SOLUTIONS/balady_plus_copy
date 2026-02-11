/// data
/// data -> data sources
library;
export 'data/data_sources/remote_data_source.dart';

/// data -> models
export 'data/models/params_model.dart';
export 'data/models/prayer_time_model.dart';
export 'data/models/prayer_time_response_model.dart';
export 'data/models/prayer_time_range_response_model.dart';

/// data -> repositories
export 'data/repositories/repository_implementation.dart';

/// domain
/// domain -> entities
export 'domain/entities/params.dart';
export 'domain/entities/prayer_time_entity.dart';
export 'domain/entities/prayer_time_response.dart';
export 'domain/entities/prayer_time_range_entity.dart';
export 'domain/entities/prayer_time_range_params.dart';

/// domain -> repositories
export 'domain/repositories/repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_prayer_times.dart';
export 'domain/use_cases/get_prayer_time_range.dart';

/// presentation
/// presentation -> cubits
export 'presentation/cubit/prayer_times_cubit.dart';

/// presentation -> pages
export 'presentation/pages/prayer_times_page.dart';

/// presentation -> widgets
export 'presentation/widgets/next_prayer.dart';
