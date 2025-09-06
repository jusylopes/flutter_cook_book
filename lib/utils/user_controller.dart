import 'package:flutter_cook_book/data/models/user_profile.dart';
import 'package:flutter_cook_book/data/repositories/auth_repository.dart';
import 'package:flutter_cook_book/di/service_locator.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final _repository = getIt<AuthRepository>();
  final user = Rxn<UserProfile>();

  Future<void> loadUser() async {
    final result = await _repository.currentUser;
    result.fold((left) => null, (right) => user.value = right);
  }
}
