import 'package:dartz/dartz.dart' show Either;
import 'package:equatable/equatable.dart' show Equatable;

import '../../errors/errors_exports.dart' show Failure;

/// Type is a return type of data,
///
/// Accept any type of data and any type of parameters
///
/// And play with paramters e.g. print(params)
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// We create NoParams class to skip Params of UseCase
///
/// And added here, because we can use it in multiple use-cases
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

/// We create NoType class to skip Type of UseCase
///
/// And added here, because we can use it in multiple use-cases
class NoType extends Equatable {
  @override
  List<Object?> get props => [];
}
