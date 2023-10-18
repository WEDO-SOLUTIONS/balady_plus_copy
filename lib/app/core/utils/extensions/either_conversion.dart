import 'package:dartz/dartz.dart' show Either;

extension EitherConversion<L, R> on Either<L, R> {
  R? get getRight => fold<R?>((_) => null, (r) => r);
  L? get getLeft => fold<L?>((l) => l, (_) => null);
}

extension ExtractEitherFailure<L, R> on Future<Either<L, R>> {
  Future<Either<L, R>> get extractFailureIfExist => then((value) {
        if (value.isLeft()) throw value.getLeft!;
        // Another solution
        /* throw Exception(
              value.getLeft!.properties.isEmpty
                  ? value.getLeft
                  : value.getLeft?.properties.first,
            ); */

        // If the value is right, then return value
        return value;
      });
}
