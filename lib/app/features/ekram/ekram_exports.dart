//! data
/// data -> data sources
export 'data/data_sources/ekram_remote_data_source.dart';

/// data -> models
export 'data/model/apply_deceased/deceased_info_dto.dart';
export 'data/model/apply_deceased/apply_deceased_params.dart';
export 'data/model/apply_deceased/apply_deceased_response_model.dart';
export 'data/model/deceased_transport_requests/transport_request_item_model.dart';
export 'data/model/deceased_transport_requests/transport_request_response_model.dart';

/// data -> repositories
export 'data/repositories/ekram_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/ekram_booking_item.dart';
export 'domain/entities/ekram_types.dart';
export 'domain/entities/apply_deceased_response.dart';
export 'domain/entities/add_deceased_dialog_params.dart';
export 'domain/entities/deceased_transport_requests/transport_request_item.dart';
export 'domain/entities/deceased_transport_requests/transport_request_response.dart';
export 'domain/entities/deceased_request_details/deceased_request_details.dart';

/// domain -> repositories
export 'domain/repositories/ekram_repository.dart';

/// domain -> use cases
export 'domain/use_cases/get_cities.dart';
export 'domain/use_cases/get_hospitals.dart';
export 'domain/use_cases/get_nationalities.dart';
export 'domain/use_cases/apply_deceased_transport.dart';
export 'domain/use_cases/get_lookup.dart';
export 'domain/use_cases/get_deceased_transport_requests.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/ekram_request_transportation_bloc/ekram_request_transportation_bloc.dart';
export 'presentation/blocs/trips_details_bloc/trip_details_bloc_bloc.dart';
export 'presentation/blocs/ekram_requests_bloc/ekram_requests_bloc.dart';

/// presentation -> dialogs
export 'presentation/dialogs/add_deceased_dialog.dart';
export 'presentation/dialogs/trip_details_dialog.dart';

/// presentation -> pages
export 'presentation/pages/user/ekram_orders_page.dart';
export 'presentation/pages/ekram_home_page.dart';
export 'presentation/pages/ekram_select_type_page.dart';
export 'presentation/pages/user/ekram_transportation_list_page.dart';
export 'presentation/pages/ekram_booking_list_page.dart';
export 'presentation/pages/user/ekram_request_transportation_page.dart';
export 'presentation/pages/ekram_success_screen.dart';
export 'presentation/pages/driver/ekram_transpotation_details_page.dart';

/// presentation -> widgets
export 'presentation/widgets/ekram_booking_card_widget.dart';
export 'presentation/widgets/ekram_transportation_card_widget.dart';
export 'presentation/widgets/ekram_status_widget.dart';
export 'presentation/widgets/ekram_type_card_widget.dart';

/// presentation -> widgets -> transportation request page view
export 'presentation/widgets/transportation_request_page_view/agreement_section.dart';
export 'presentation/widgets/transportation_request_page_view/applicant_info_section.dart';
export 'presentation/widgets/transportation_request_page_view/death_and_burial_info_section.dart';
export 'presentation/widgets/transportation_request_page_view/deceased_info_section.dart';

/// presentation -> widgets -> transportation request widgets
export 'presentation/widgets/transportation_request_widgets/ekram_previous_next_buttons.dart';
export 'presentation/widgets/transportation_request_widgets/ekram_request_app_bar.dart';
export 'presentation/widgets/transportation_request_widgets/deceased_card_widget.dart';

/// presentation -> widgets -> transportation details widgets
export 'presentation/widgets/transportation_details_widget/ekram_details_app_bar.dart';
export 'presentation/widgets/transportation_details_widget/driver_card_widget.dart';
export 'presentation/widgets/transportation_details_widget/deceased_grey_card_widget.dart';

/// presentation -> widgets -> transportation details widgets -> body sections
export 'presentation/widgets/transportation_details_widget/body_sections/transfer_info_widget.dart';
export 'presentation/widgets/transportation_details_widget/body_sections/deceased_info_widget.dart';
export 'presentation/widgets/transportation_details_widget/body_sections/driver_info_widget.dart';
export 'presentation/widgets/transportation_details_widget/body_sections/burial_info_widget.dart';
export 'presentation/widgets/transportation_details_widget/body_sections/applicant_info_widget.dart';

/// presentation -> widgets -> trip details dialog widgets
export 'presentation/widgets/trip_details_dialog_widgets/trip_details_card_widget.dart';
export 'presentation/widgets/trip_details_dialog_widgets/trip_details_header_and_desc.dart';
