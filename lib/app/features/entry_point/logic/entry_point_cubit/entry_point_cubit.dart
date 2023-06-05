import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

import '../../../../core/utils/utils_exports.dart' show AuthStatus, UIHelper;
import '../../../_shared_feature_/shared_feature_exports.dart' show AuthData;
import '../../entry_point_exports.dart'
    show ClearAuth, FetchAuth, PersistAuth, UpdateAuth;

part 'entry_point_state.dart';

class EntryPointCubit extends Cubit<EntryPointState> {
  final ClearAuth _clearAuth;
  final FetchAuth _fetchAuth;
  final PersistAuth _persistAuth;
  final UpdateAuth _updateAuth;
  EntryPointCubit({
    required ClearAuth clearAuth,
    required FetchAuth fetchAuth,
    required PersistAuth persistAuth,
    required UpdateAuth updateAuth,
  })  : _clearAuth = clearAuth,
        _fetchAuth = fetchAuth,
        _persistAuth = persistAuth,
        _updateAuth = updateAuth,
        super(const EntryPointState());

  //! Simulate the reality of operation
  Future<void> onLoadingApp() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(UIHelper.duration);
    emit(state.copyWith(status: AuthStatus.authenticated));
  }

  Future<void> onUserLoggedIn() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(UIHelper.duration);
    emit(state.copyWith(status: AuthStatus.authenticated));
  }

  Future<void> onUserLoggedOut() async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(UIHelper.duration);
    emit(state.copyWith(status: AuthStatus.notAuthenticated));
  }

  Future<void> onUpdateAuth(AuthData newAuthData) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await Future.delayed(UIHelper.duration);
    emit(state.copyWith(status: AuthStatus.failure));
  }
}
