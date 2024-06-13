//! data
/// data -> data sources
export 'data/data_sources/providers_remote_data_source.dart';
export 'data/data_sources/providers_local_data_source.dart';
export 'data/data_sources/providers_cache_data_source.dart';

/// data -> models
export 'data/models/provider_details_response_model.dart';

/// data -> repositories
export 'data/repositories/providers_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/provider_params.dart';
export 'domain/entities/provider_details_params.dart';
export 'domain/entities/provider_details_response.dart';

/// domain -> repositories
export 'domain/repositories/providers_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_providers.dart';
export 'domain/use_cases/get_provider_details.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/provider_bloc/provider_bloc.dart';

/// presentation -> pages
export 'presentation/pages/providers_page.dart';
export 'presentation/pages/provider_details_page.dart';

/// presentation -> widgets
export 'presentation/widgets/provider_details/about_provider_office_widget.dart';
export 'presentation/widgets/provider_details/provider_main_info_widget.dart';
export 'presentation/widgets/provider_details/provider_branches_widget.dart';
export 'presentation/widgets/provider_details/provider_previous_works_widget.dart';
export 'presentation/widgets/provider_details/provider_services_section.dart';
export 'presentation/widgets/provider_details/provider_evaluation_section_widget.dart';
export 'presentation/widgets/provider_details/evaluator_card.dart';
export 'presentation/widgets/provider_details/evaluators_horizontal_list.dart';
export 'presentation/widgets/provider_item.dart';
