import 'package:flutter/material.dart';
import 'package:todo_list_provaider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provaider/app/exception/auth_exceptions.dart';
import 'package:todo_list_provaider/app/services/user/user_service.dart';

class RegisterController extends DefaultChangeNotifier {
  final UserService _userService;

  RegisterController({required UserService userService})
      : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      showLoadingAndResetState();
      notifyListeners();

      final user = await _userService.register(email, password);
      if (user != null) {
        //sucesso
        success();
      } else {
        // erro
        setError('Erro ao registrar usuário');
      }
    } on AuthExceptions catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
