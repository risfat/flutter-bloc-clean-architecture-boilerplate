import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import '../core/config/boxs.dart';
import '../core/network/dio_client.dart';
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

final getIt = GetIt.instance;

// Function to initialize the dependency injection
Future<void> initializeDependencies() async {
  setupSynchronousRegistrations();
  await setupAsynchronousRegistrations();
}

// Function to set up synchronous registrations
void setupSynchronousRegistrations() {
  // Dio
  getIt.registerLazySingleton(() => DioClient.instance);

  // // Network
  // getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Data sources
  getIt.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => AuthenticationRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(userBox: getIt()),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => SignIn(getIt()));
  getIt.registerLazySingleton(() => GetUsers(getIt()));

  // BLoCs
  getIt.registerLazySingleton(() => AuthenticatorWatcherBloc());
  getIt.registerLazySingleton(() => SignInFormBloc(getIt()));
  getIt.registerLazySingleton(() => ThemeCubit());
  getIt.registerLazySingleton(() => UserBloc(getUsers: getIt()));
}

Future<void> setupAsynchronousRegistrations() async {
  // Open Hive box
  final userBox = await Hive.openBox<String>(HiveBox.userBox);
  final configBox = await Hive.openBox(HiveBox.configBox);
  // Register box in GetIt
  getIt.registerLazySingleton<Box<String>>(() => userBox);
  getIt.registerLazySingleton<Box>(() => configBox);
}
