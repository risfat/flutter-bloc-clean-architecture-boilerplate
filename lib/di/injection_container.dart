import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../core/config/boxs.dart';
import '../core/network/network_info.dart';
import '../data/datasources/local/user_local_data_source.dart';
import '../data/datasources/remote/authentication_remote_data_source.dart';
import '../data/datasources/remote/user_remote_data_source.dart';
import '../data/datasources/repositories/authentication_repository_impl.dart';
import '../data/datasources/repositories/user_repository_impl.dart';
import '../domain/repositories/autentication_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/get_users.dart';
import '../domain/usecases/login.dart';
import '../presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import '../presentation/bloc/sign_in_form/sign_in_form_bloc.dart';
import '../presentation/bloc/user/user_bloc.dart';
import '../presentation/cubit/theme/theme_cubit.dart';

final locator = GetIt.instance;

// Function to initialize the dependency injection
Future<void> initializeDependencies() async {
  setupSynchronousRegistrations();
  await setupAsynchronousRegistrations();
}

// Function to set up synchronous registrations
void setupSynchronousRegistrations() {
  // External
  locator.registerLazySingleton(() => InternetConnectionChecker.instance);

  // Network
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // Data sources
  locator.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(),
  );

  locator.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(userBox: locator()),
  );

  locator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );

  // Repositories
  locator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(locator()),
  );

  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // Use cases
  locator.registerLazySingleton(() => SignIn(locator()));
  locator.registerLazySingleton(() => GetUsers(locator()));

  // BLoCs
  locator.registerLazySingleton(() => AuthenticatorWatcherBloc());
  locator.registerLazySingleton(() => SignInFormBloc(locator()));
  locator.registerLazySingleton(() => ThemeCubit());
  locator.registerLazySingleton(() => UserBloc(getUsers: locator()));
}

Future<void> setupAsynchronousRegistrations() async {
  // Open Hive box
  final userBox = await Hive.openBox<String>(HiveBox.userBox);
  // Register box in GetIt
  locator.registerLazySingleton<Box<String>>(() => userBox);
}
