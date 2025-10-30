import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'athkar_state.dart';

class AthkarCubit extends Cubit<AthkarState> {
  AthkarCubit() : super(AthkarInitial());
}
