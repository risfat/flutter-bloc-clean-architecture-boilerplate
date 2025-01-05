part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.loaded({
    required List<User> users,
    required bool hasReachedMax,
  }) = _Loaded;
  const factory UserState.error({required String message}) = _Error;
}
