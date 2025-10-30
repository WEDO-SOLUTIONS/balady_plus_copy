//! data
/// data -> data sources
export 'data/data_sources/submit_request_local_data_source.dart';
export 'data/data_sources/submit_request_remote_data_source.dart';

/// data -> models
export 'data/models/relation/relation_item_model.dart';
export 'data/models/relation/relation_response_model.dart';

/// data -> repositories
export 'data/repositories/submit_request_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/relation/relation_item.dart';
export 'domain/entities/relation/relation_params.dart';
export 'domain/entities/relation/relation_page_param.dart';
export 'domain/entities/submit/submit_page_params.dart';

/// domain -> repositories
export 'domain/repositories/submit_request_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_relations.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/relation/relation_bloc.dart';
export 'presentation/blocs/service_providers/service_providers_bloc.dart';

/// presentation -> pages
export 'presentation/pages/relation_request_page.dart';
export 'presentation/pages/service_providers_relations.dart';
export 'presentation/pages/submit_request_page.dart';

/// presentation -> widgets
export 'presentation/widgets/submit_request/check_box_widgets.dart';
export 'presentation/widgets/service_types/service_type_card_widget.dart';
export 'presentation/widgets/order_info/order_info_card_widget.dart';
export 'presentation/widgets/order_info/order_title_and_desc_widget.dart';
export 'presentation/widgets/order_info/delete_provider_widget.dart';
export 'presentation/widgets/submit_request/relation_checkbox_widget.dart';
