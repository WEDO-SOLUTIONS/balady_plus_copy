import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class ChatBotRepository {


  Future<Either<Failure, Stream>> sendQuestionMessage( {required String question});

}
