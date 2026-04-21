import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhac/models/usuario/usuario_model.dart';
import 'package:nhac/repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();
  
  UsuarioModel? _usuario;
  
  StreamSubscription<UsuarioModel?>? _usuarioSubscription; 

  UsuarioModel? get usuario => _usuario;

  void iniciarEscutaUsuario() {
    final user = _auth.currentUser;
    
    if (user != null) {
      _usuarioSubscription?.cancel(); 
      
      _usuarioSubscription = _userRepository.ouvirUsuario(user.uid).listen((usuarioAtualizado) {
        
        _usuario = usuarioAtualizado;
        
        if (_usuario != null && !_usuario!.ativo) {
           _auth.signOut();
           limparUsuario();
           return;
        }

        notifyListeners(); 
      });
    }
  }

  void limparUsuario() {
    _usuario = null;
    _usuarioSubscription?.cancel(); 
    notifyListeners();
  }

  @override
  void dispose() {
    _usuarioSubscription?.cancel(); 
    super.dispose();
  }
}