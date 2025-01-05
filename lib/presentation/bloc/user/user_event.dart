part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.getUsers({required int page}) = _GetUsersEvent;
  const factory UserEvent.loadMoreUsers() = _LoadMoreUsersEvent;
}
