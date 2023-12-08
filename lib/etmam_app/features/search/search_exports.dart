//! data
/// data -> data sources
export 'data/data_sources/search_remote_data_source.dart';
export 'data/data_sources/search_local_data_source.dart';

/// data -> models
export 'data/models/search_item_model.dart';
export 'data/models/search_response_model.dart';

/// data -> repositories
export 'data/repositories/search_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/search_item.dart';
export 'domain/entities/search_params.dart';
export 'domain/entities/search_response.dart';

/// domain -> repositories
export 'domain/repositories/search_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_search_data.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/search_bloc.dart';

/// presentation -> pages
export 'presentation/pages/search_page.dart';

/// presentation -> widgets
export 'presentation/widgets/search_header.dart';
export 'presentation/widgets/search_result_item.dart';
export 'presentation/widgets/search_result_list.dart';
export 'presentation/widgets/search_title_result.dart';
export 'presentation/widgets/search_image.dart';
export 'presentation/widgets/search_title.dart';
export 'presentation/widgets/search_no_result.dart';
