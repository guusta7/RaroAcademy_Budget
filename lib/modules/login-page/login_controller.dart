import 'package:raro_academy_budget/modules/login-page/login_repository.dart';
import 'package:raro_academy_budget/shared/models/user_model.dart';

class LoginController {
  LoginRepository repository = LoginRepository();

  Future<UserModel> login(
      {required String email, required String password}) async {
    return await repository.login(email: email, password: password);
  }

  Future<bool> containsEmail({required String email}) async {
    return await repository.containsEmail(email);
  }
}
