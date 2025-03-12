import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/constants.dart';

part 'authenticator_watcher_bloc.freezed.dart';
part 'authenticator_watcher_event.dart';
part 'authenticator_watcher_state.dart';

class AuthenticatorWatcherBloc
    extends Bloc<AuthenticatorWatcherEvent, AuthenticatorWatcherState> {
  AuthenticatorWatcherBloc()
      : super(const AuthenticatorWatcherState.initial()) {
    on<AuthenticatorWatcherEvent>((event, emit) async {
      await event.map(
        authCheckRequest: (_) async {
          emit(const AuthenticatorWatcherState.authenticating());
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(ACCESS_TOKEN);
          final showOnboarding = prefs.getString(ONBOARDING);
          if (showOnboarding == null) {
            await prefs.setBool(ONBOARDING, true);
            emit(const AuthenticatorWatcherState.isFirstTime());
          } else if (token != null) {
            emit(const AuthenticatorWatcherState.authenticated());
          } else {
            emit(const AuthenticatorWatcherState.unauthenticated());
          }
        },
        signOut: (_) async {
          emit(const AuthenticatorWatcherState.authenticating());
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove(ACCESS_TOKEN);
          emit(const AuthenticatorWatcherState.unauthenticated());
        },
      );
    });
  }
}
