import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/params/pagination_params.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_users.dart';

part 'user_bloc.freezed.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  static const int _usersPerPage = 10;

  UserBloc({required this.getUsers}) : super(const UserState.initial()) {
    on<UserEvent>((event, emit) async {
      await event.map(
        getUsers: (e) => _onGetUsers(e, emit),
        loadMoreUsers: (e) => _onLoadMoreUsers(e, emit),
      );
    });
  }

  Future<void> _onGetUsers(
      _GetUsersEvent event, Emitter<UserState> emit) async {
    emit(const UserState.loading());
    final failureOrUsers = await getUsers(
        PaginationParams(page: event.page, limit: _usersPerPage));

    if (emit.isDone) return;

    failureOrUsers.fold(
      (failure) => emit(UserState.error(message: failure.message)),
      (users) => emit(UserState.loaded(
        users: users,
        hasReachedMax: users.length < _usersPerPage,
      )),
    );
  }

  Future<void> _onLoadMoreUsers(
      _LoadMoreUsersEvent event, Emitter<UserState> emit) async {
    final currentState = state;
    if (currentState is _Loaded && !currentState.hasReachedMax) {
      final nextPage = (currentState.users.length ~/ _usersPerPage) + 1;
      final failureOrUsers = await getUsers(
          PaginationParams(page: nextPage, limit: _usersPerPage));

      if (emit.isDone) return;

      failureOrUsers.fold(
        (failure) =>
            emit(const UserState.error(message: 'Failed to load more users')),
        (newUsers) => emit(UserState.loaded(
          users: [...currentState.users, ...newUsers],
          hasReachedMax: newUsers.length < _usersPerPage,
        )),
      );
    }
  }
}
