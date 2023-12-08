//! data
/// data -> data sources
export 'data/data_sources/services_remote_data_source.dart';
export 'data/data_sources/services_local_data_source.dart';
export 'data/data_sources/services_cache_data_source.dart';

/// data -> models
export 'data/models/services/service_item_model.dart';
export 'data/models/services/service_response_model.dart';

export 'data/models/relation/relation_item_model.dart';
export 'data/models/relation/relation_response_model.dart';

/// data -> repositories
export 'data/repositories/services_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/services/service_item.dart';
export 'domain/entities/services/service_params.dart';
export 'domain/entities/services/services_response.dart';

export 'domain/entities/service_details/service_details_response.dart';
export 'domain/entities/service_details/service_details_params.dart';

export 'domain/entities/relation/relation_item.dart';
export 'domain/entities/relation/relation_params.dart';
export 'domain/entities/relation/relation_response.dart';

/// domain -> repositories
export 'domain/repositories/services_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_services.dart';
export 'domain/use_cases/get_service_details.dart';

export 'domain/use_cases/get_relations.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/service_bloc/services_bloc.dart';
export 'presentation/blocs/branch_map_bloc/branch_map_bloc.dart';
export 'presentation/blocs/service_details_bloc/service_details_bloc.dart';

/// presentation -> pages
export 'presentation/pages/services_page.dart';
export 'presentation/pages/service_details_page.dart';
export 'presentation/pages/branches_map_page.dart';
export 'presentation/pages/faq_page.dart';
export 'presentation/pages/office_info_page.dart';

/// presentation -> widgets

export 'presentation/widgets/service_provider_item.dart';
export 'presentation/widgets/info_card.dart';
export 'presentation/widgets/service_provider_details_widgets/service_details_header_widget.dart';
export 'presentation/widgets/service_provider_details_widgets/service_main_info_widget.dart';
export 'presentation/widgets/service_provider_details_widgets/service_info_widget.dart';
export 'presentation/widgets/service_provider_details_widgets/previous_works_widget.dart';
export 'presentation/widgets/service_provider_details_widgets/service_faq_section.dart';
export 'presentation/widgets/branches_map_widgets/branch_card.dart';
export 'presentation/widgets/office_info_widgets/provider_name_and_logo_widget.dart';

/// presentation -> dialogs
