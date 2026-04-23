import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nhac/models/usuario/usuario_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UsuarioModel?> buscarUsuario(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('usuarios').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UsuarioModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      debugPrint("Erro ao buscar usuário no Firestore: $e");
      rethrow;
    }
  }

  Future<void> salvarUsuario(UsuarioModel usuario) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(usuario.uid)
          .set(usuario.toMap());
    } catch (e) {
      debugPrint("Erro ao salvar usuário no Firestore: $e");
      rethrow;
    }
  }

  Stream<UsuarioModel?> ouvirUsuario(String uid) {
    return _firestore
        .collection('usuarios')
        .doc(uid)
        .snapshots() 
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UsuarioModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    });
  }

  Future<void> atualizarDadosUsuario(String uid, Map<String, dynamic> dados) async {
    try {
      await _firestore.collection('usuarios').doc(uid).update(dados);
    } catch (e) {
      debugPrint("Erro ao atualizar usuário: $e");
      rethrow;
    }
  }
}