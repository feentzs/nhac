import 'package:flutter/material.dart';

class CadastroController extends ChangeNotifier {
  String nome = '';
  String email = '';
  String senha = '';
  String telefone = '';


  void setNome(String novoNome) {
    nome = novoNome;
    
    notifyListeners(); 
  }

  void setEmail(String novoEmail) {
    email = novoEmail;
    notifyListeners();
  }

  void setSenha(String novaSenha) {
    senha = novaSenha;
    notifyListeners();
  }

  void limparDados() {
    nome = '';
    telefone = '';
    email = '';
    senha = '';
    notifyListeners();
  }
}