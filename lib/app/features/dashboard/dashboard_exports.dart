/// data
/// data -> data sources
library;
export 'data/data_sources/remote_data_source.dart';

/// data -> models
export 'data/models/dashboard_card_model.dart';
export 'data/models/dashboard_product_model.dart';
export 'data/models/dashboard_products_param_model.dart';
export 'data/models/dashboard_statistics_model.dart';
export 'data/models/dashboard_statistics_param_model.dart';

/// data -> repositories
export 'data/repositories/repository_implementation.dart';

/// domain
/// domain -> entities
export 'domain/entities/dashboard_card_entity.dart';
export 'domain/entities/dashboard_product_entity.dart';
export 'domain/entities/dashboard_products_param.dart';
export 'domain/entities/dashboard_statistics_entity.dart';
export 'domain/entities/dashboard_statistics_param.dart';

/// domain -> repositories
export 'domain/repositories/repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_dashboard_card_products.dart';
export 'domain/use_cases/get_dashboard_card_statistics.dart';
export 'domain/use_cases/get_dashboard_cards.dart';

/// presentation
/// presentation -> cubits
export 'presentation/bloc/dashboard_bloc.dart';

/// presentation -> pages
export 'presentation/pages/dashboard_page.dart';
export 'presentation/pages/notification_page.dart';

/// presentation -> widgets
export 'presentation/widgets/dashboard_card.dart';
export 'presentation/widgets/dashboard_card_statistics.dart';
export 'presentation/widgets/dashboard_list_shimmer.dart';
export 'presentation/widgets/dashboard_product_drop_down.dart';
