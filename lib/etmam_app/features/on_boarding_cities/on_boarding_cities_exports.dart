//! data
/// data -> data sources
export 'data/data_sources/city_local_data_source.dart';
export 'data/data_sources/city_remote_data_source.dart';

/// data -> models

/// data -> repositories
export 'data/repositories/city_repository_impl.dart';

//! domain
/// domain -> entities

/// domain -> repositories
export 'domain/repositories/city_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_cities.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/city_bloc.dart';

/// presentation -> pages
export 'presentation/pages/on_boarding_cities_page.dart';

/// presentation -> widgets
export 'presentation/widgets/cities_container_widget.dart';
