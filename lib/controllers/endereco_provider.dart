import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhac/models/usuario/endereco_model.dart';
import 'package:nhac/repository/endereco_repository.dart';

class EnderecoProvider with ChangeNotifier {
  final EnderecoRepository _enderecoRepository = EnderecoRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<EnderecoModel> _enderecos = [];
  StreamSubscription<List<EnderecoModel>>? _subscription;
  bool _isLoading = false;

  List<EnderecoModel> get enderecos => _enderecos;
  bool get isLoading => _isLoading;

  void iniciarEscutaEnderecos() {
    final user = _auth.currentUser;
    if (user != null) {
      _isLoading = true;
      _subscription?.cancel();
      _subscription = _enderecoRepository.ouvirEnderecos(user.uid).listen((lista) {
        _enderecos = lista;
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  Future<void> definirComoPadrao(String enderecoId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _enderecoRepository.definirComoPadrao(user.uid, enderecoId);
    } catch (e) {
      debugPrint("Erro ao definir endereço padrão: $e");
      rethrow;
    }
  }

  Future<void> removerEndereco(String enderecoId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      await _enderecoRepository.removerEndereco(user.uid, enderecoId);
    } catch (e) {
      debugPrint("Erro ao remover endereço: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
