//! data
/// data -> data sources
export 'data/data_sources/remote_data_source.dart';

/// data -> models
export 'data/models/news_response_model.dart';

/// data -> repositories
export 'data/repositories/repository_implementation.dart';

//! domain
/// domain -> entities
export 'domain/entities/news_params.dart';
export 'domain/entities/news_response.dart';

/// domain -> repositories
export 'domain/repositories/repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_news.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/home_bloc/home_bloc.dart';

/// presentation -> pages
export 'presentation/pages/home_page.dart';

/// presentation -> widgets

export 'presentation/widgets/news_card.dart';
export 'presentation/widgets/news_section.dart';
