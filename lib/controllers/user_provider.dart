import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhac/models/usuario/usuario_model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UsuarioModel? _usuario;

  UsuarioModel? get usuario => _usuario;

  Future<void> carregarDadosUsuario() async {
  final user = _auth.currentUser;
  if (user != null) {
    DocumentSnapshot doc = await _firestore.collection('usuarios').doc(user.uid).get();
    
    if (doc.exists) {
      _usuario = UsuarioModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      notifyListeners();
    }
  }
}

  void limparUsuario() {
    _usuario = null;
    notifyListeners();
  }
}