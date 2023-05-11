import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provaider/app/exception/auth_exceptions.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredencial.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);

      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthExceptions(
              message: 'E-mail já utilizado, por favor escolha outro e-mail');
        } else {
          throw AuthExceptions(
              message:
                  'Você se cadastrou no TodoList pelo Google, por favor utilize ele para entrar!!');
        }
      } else {
        throw AuthExceptions(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthExceptions(message: e.message ?? 'Erro ao realizar o login');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'wrong-password') {
        throw AuthExceptions(message: 'Login ou Senha inválidos');
      }
      throw AuthExceptions(message: e.message ?? 'Erro ao realizar o login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthExceptions(
            message:
                'Cadastro realizado com o google, não pode ser resetado a senha');
      } else {
        throw AuthExceptions(message: 'E-mail não cadastrado');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthExceptions(message: 'Erro ao resetar a senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        print(loginMethods);
        if (loginMethods.contains('password')) {
          throw AuthExceptions(
              message:
                  '''Você se cadastrou com este e-mail no TodoList. Caso tenha esquecido a senha, clique no link "Esqueci a senha"''');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          var userCredential =
              await _firebaseAuth.signInWithCredential(firebaseCredential);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(s);
      print(e);
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthExceptions(
            message:
                '''Login inválido. Você se registrou no TodoList com os seguintes provedores:
                   ${loginMethods?.join(',')}
                ''');
      } else {
        throw AuthExceptions(message: 'Erro ao realizar login');
      }
    }
    return null;
  }
}
