import 'package:either_dart/either.dart';
import 'package:flutter_cook_book/data/models/user_profile.dart';
import 'package:flutter_cook_book/data/services/auth_service.dart';
import 'package:flutter_cook_book/di/service_locator.dart';
import 'package:flutter_cook_book/utils/app_error.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxController {
  final _service = getIt<AuthService>();

  Future<Either<AppError, UserProfile>> get currentUser async {
    final user = _service.currentUser;
    final profile = await _service.fetchUserProfile(user!.id);
    return profile.fold(
      (left) => Left(left),
      (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
    );
  }

  Future<Either<AppError, UserProfile>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final result = await _service.signInWithPassword(
      email: email,
      password: password,
    );
    return result.fold((left) => Left(left), (right) async {
      final user = right.user!;
      final profileResult = await _service.fetchUserProfile(user.id);
      return profileResult.fold(
        (left) => Left(left),
        (right) => Right(UserProfile.fromSupabase(user.toJson(), right!)),
      );
    });
  }
}
