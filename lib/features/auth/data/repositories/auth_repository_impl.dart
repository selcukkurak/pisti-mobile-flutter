// Placeholder - Auth repository implementation
import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User?> signInAnonymously() async {
    return await remoteDataSource.signInAnonymously();
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  User? getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}