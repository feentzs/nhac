import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nhac/globals/exceptions.dart';
import 'package:nhac/models/usuario/usuario_model.dart'; 
import 'package:nhac/repository/user_repository.dart'; 

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserRepository _userRepository = UserRepository();

  bool isLoading = false;

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogle() async {
    _setLoading(true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _setLoading(false);
        return; 
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredencial = await _auth.signInWithCredential(credential);

      final usuarioExistente = await _userRepository.buscarUsuario(userCredencial.user!.uid);

      if (usuarioExistente == null) {
        UsuarioModel novoUsuarioGoogle = UsuarioModel(
          uid: userCredencial.user!.uid,
          nome: userCredencial.user!.displayName ?? 'Usuário Google', 
          email: userCredencial.user!.email ?? '', 
          fotoUrl: userCredencial.user!.photoURL ?? '', 
          telefone: userCredencial.user!.phoneNumber ?? '',
        );
        await _userRepository.salvarUsuario(novoUsuarioGoogle);
      } else {
        if (userCredencial.user!.photoURL != null && userCredencial.user!.photoURL!.isNotEmpty) {
          await _userRepository.atualizarDadosUsuario(
            userCredencial.user!.uid, 
            {'foto_url': userCredencial.user!.photoURL}
          );
        }
      }

    } catch(e) {
      throw mapException(e);
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credencial = await _auth.signInWithEmailAndPassword(email: email, password: password);

      final usuario = await _userRepository.buscarUsuario(credencial.user!.uid);
      
      if (usuario != null && !usuario.ativo) {
        await _auth.signOut(); 
        throw AuthException('Esta conta foi desativada pelo usuário.');
      }

      return credencial;
    } catch (e) {
      throw mapException(e);
    }
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String nome,
    required String telefone,
  }) async {
    try {
      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      UsuarioModel novoUsuario = UsuarioModel(
        uid: credencial.user!.uid,
        nome: nome,
        email: email,
        fotoUrl: '',
        telefone: telefone,
      );

      await _userRepository.salvarUsuario(novoUsuario);

      return credencial;

    } catch (e) {
      throw mapException(e);
    }
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners(); 
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw mapException(e);
    }
  }

  Future<void> updateUserName({required String userName}) async {
    try {
      await currentUser!.updateDisplayName(userName);
      await _userRepository.atualizarDadosUsuario(currentUser!.uid, {'nome': userName});
      notifyListeners();
    } catch (e) {
      throw mapException(e);
    }
  }

  Future<void> desativarConta({
    required String email,
    required String password,
  }) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await currentUser!.reauthenticateWithCredential(credential);

      await _userRepository.atualizarDadosUsuario(currentUser!.uid, {'ativo': false});

      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      throw mapException(e);
    }
  }


  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  Future<bool> checarEmail(String email) async {
    try {
     await _auth.signInWithEmailAndPassword(
        email: email, 
        password: 'SenhaFalsaParaChecagem123!'
      );
      return true;
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return true;
      }
      
      if (e.code == 'user-not-found') {
        return false;
      }

      
      if (e.code == 'invalid-credential') {
         return true; 
      }
      
      return false;
    } catch (e) {
      return false;
    }
    
  }

  Future<void> uptadeEmail({required String newEmail}) async {
    try {
      await currentUser?.verifyBeforeUpdateEmail(newEmail);

      if (currentUser != null) {
        await _userRepository.atualizarDadosUsuario(currentUser!.uid, {'email': newEmail});
      }

      notifyListeners();
    } catch (e) {
      print("Erro ao atualizar e-mail: $e");
      rethrow;
    }
  }

  Future<void> enviarSmsDeVerificacao({
    required String telefone,
    required Function(String verificationId) onCodeSent,
    required Function(String erro) onFailed,
  }) async {
    String numeroCompleto = '+55$telefone';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: numeroCompleto,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onFailed(e.message ?? 'Erro desconhecido');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> loginComSms({
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);  
  }

  Future<void> finalizarCadastroTelefone({
    required String nome,
    required String telefone,
  }) async {
    User? usuarioAtual = FirebaseAuth.instance.currentUser;

    if (usuarioAtual != null) {
      UsuarioModel novoUsuario = UsuarioModel(
        uid: usuarioAtual.uid,
        nome: nome,
        email: '', 
        fotoUrl: '',
        telefone: telefone,
      );
      
      await _userRepository.salvarUsuario(novoUsuario);
    }
  }
}