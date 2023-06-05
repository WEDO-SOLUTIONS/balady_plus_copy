//! data
/// data -> data sources
export 'data/data_sources/remote_data_source.dart';

/// data -> models
export 'data/models/params_model.dart';

/// data -> repositories
export 'data/repositories/repository_implementation.dart';

//! domain
/// domain -> entities
export 'domain/entities/params.dart';

/// domain -> repositories
export 'domain/repositories/repository.dart';

/// domain -> use cases
export 'domain/use_cases/by_phone_number.dart';
export 'domain/use_cases/by_username_and_password.dart';

//! presentation
/// presentation -> blocs
export 'presentation/blocs/sign_in_bloc/sign_in_bloc.dart';

/// presentation -> pages
export 'presentation/pages/sign_in_page.dart';

/// presentation -> widgets
export 'presentation/widgets/body_widget.dart';
export 'presentation/widgets/password_field.dart';
export 'presentation/widgets/phone_number_field.dart';
export 'presentation/widgets/sign_in_button.dart';
export 'presentation/widgets/username_field.dart';
