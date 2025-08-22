import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/game/data/datasources/game_local_data_source.dart';
import '../../features/game/data/datasources/game_remote_data_source.dart';
import '../../features/game/data/repositories/game_repository_impl.dart';
import '../../features/game/domain/repositories/game_repository.dart';
import '../../features/game/domain/usecases/create_game_usecase.dart';
import '../../features/game/domain/usecases/join_game_usecase.dart';
import '../../features/game/domain/usecases/play_card_usecase.dart';
import '../../features/game/presentation/bloc/game_bloc.dart';

import 'audio_service.dart';
import 'settings_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Core services
  sl.registerLazySingleton<AudioService>(() => AudioServiceImpl());
  sl.registerLazySingleton<SettingsService>(() => SettingsServiceImpl(sl()));

  // Auth feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SignInUsecase(sl()));
  sl.registerLazySingleton(() => SignOutUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));
  sl.registerFactory(() => AuthBloc(
        signInUsecase: sl(),
        signOutUsecase: sl(),
        getCurrentUserUsecase: sl(),
      ));

  // Game feature
  sl.registerLazySingleton<GameLocalDataSource>(
    () => GameLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<GameRemoteDataSource>(
    () => GameRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CreateGameUsecase(sl()));
  sl.registerLazySingleton(() => JoinGameUsecase(sl()));
  sl.registerLazySingleton(() => PlayCardUsecase(sl()));
  sl.registerFactory(() => GameBloc(
        createGameUsecase: sl(),
        joinGameUsecase: sl(),
        playCardUsecase: sl(),
        audioService: sl(),
      ));
}