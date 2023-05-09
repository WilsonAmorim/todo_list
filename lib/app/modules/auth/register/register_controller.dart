import 'package:flutter/material.dart';
import 'package:todo_list_provaider/app/exception/auth_exceptions.dart';
import 'package:todo_list_provaider/app/services/user/user_service.dart';

class RegisterController extends ChangeNotifier {
  final UserService _userService;
  String? error;
  bool sucesso = false;

  RegisterController({required UserService userService})
      : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      error = null;
      sucesso = false;

      final user = await _userService.register(email, password);
      if (user != null) {
        //sucesso
        sucesso = true;
      } else {
        // erro
        error = 'Erro ao registrar usuário';
      }
    } on AuthExceptions catch (e) {
      error = e.message;
    } finally {
      notifyListeners();
    }
  }
}
