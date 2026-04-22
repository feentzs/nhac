import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nhac/models/user_model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserModel? _usuario;

  UserModel? get usuario => _usuario;

  Future<void> carregarDadosUsuario() async {
  final user = _auth.currentUser;
  if (user != null) {
    DocumentSnapshot doc = await _firestore.collection('usuarios').doc(user.uid).get();
    
      if (doc.exists) {
        _usuario = UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        notifyListeners();
      }
    }
  }

  Future<void> atualizarFotoPerfil(File imagem) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = FirebaseStorage.instance
        .ref()
        .child('perfil_fotos')
        .child('${user.uid}.jpg');

    await ref.putFile(imagem);
    final url = await ref.getDownloadURL();

    await _firestore.collection('usuarios').doc(user.uid).update({
      'foto_url': url,
    });

    await carregarDadosUsuario();
  }

  void limparUsuario() {
    _usuario = null;
    notifyListeners();
  }
}