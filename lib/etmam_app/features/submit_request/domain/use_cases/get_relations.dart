/*
class GetReleation
    extends UseCase<ApigeeResponse<RelationResponse>, RelationParams> {
  final SubmitRequestRepository repository;

  GetReleation({required this.repository});
  @override
  Future<Either<Failure, ApigeeResponse<RelationResponse>>> call(
      RelationParams params) async {
    return await repository.getRelations(params: params);
  }
}*/
