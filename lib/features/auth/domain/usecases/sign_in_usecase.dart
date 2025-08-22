// Placeholder - Auth use cases
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class SignInUsecase {
  final AuthRepository repository;
  SignInUsecase(this.repository);

  Future<User?> call() async {
    return await repository.signInAnonymously();
  }
}

class SignOutUsecase {
  final AuthRepository repository;
  SignOutUsecase(this.repository);

  Future<void> call() async {
    await repository.signOut();
  }
}

class GetCurrentUserUsecase {
  final AuthRepository repository;
  GetCurrentUserUsecase(this.repository);

  User? call() {
    return repository.getCurrentUser();
  }
}