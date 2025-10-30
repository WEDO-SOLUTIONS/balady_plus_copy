//! data
/// data -> data sources
export 'data/data_sources/otp_local_data_source.dart';
export 'data/data_sources/otp_remote_data_source.dart';

/// data -> models

/// data -> repositories
export 'data/repositories/otp_repository_impl.dart';

//! domain
/// domain -> entities
export 'domain/entities/otp_verify_params.dart';
export 'domain/entities/send_otp_params.dart';
export 'domain/entities/send_otp_response.dart';
export 'domain/entities/otp_page_params.dart';

/// domain -> repositories
export 'domain/repositories/otp_repository.dart';

/// domain -> use cases
export 'domain/use_cases/send_otp.dart';
export 'domain/use_cases/verify_otp.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/otp_bloc.dart';

/// presentation -> pages
export 'presentation/pages/otp_screen.dart';

/// presentation -> widgets
export 'presentation/widgets/timer_and_resend_code_widget.dart';
export 'presentation/widgets/otp_pin_code_widget.dart';
export 'presentation/widgets/otp_header_widget.dart';
export 'presentation/widgets/otp_check_putton.dart';
