import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future<void> carregarDadosUsuario() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        _usuario = await _userRepository.buscarUsuario(user.uid);
        notifyListeners();
      } catch (e) {
        debugPrint("Erro ao carregar dados do usuário: $e");
      }
    }
  }

  Future<void> atualizarFotoPerfil(File imagem) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('perfil_fotos')
          .child('${user.uid}.jpg');

      await ref.putFile(imagem);
      final url = await ref.getDownloadURL();

      await _userRepository.atualizarDadosUsuario(user.uid, {
        'foto_url': url,
      });

      await carregarDadosUsuario();
    } catch (e) {
      debugPrint("Erro ao atualizar foto de perfil: $e");
      rethrow;
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
