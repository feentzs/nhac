import 'package:flutter/material.dart';
import 'package:nhac/models/usuarios/cart_model.dart';

class CartProvider extends ChangeNotifier {
  
  final Map<String, CartModel> _itens = {};

  Map<String, CartModel> get itens => _itens;

  int get quantidadeItens => _itens.length;

  double get valorTotal {
    double total = 0.0;
    _itens.forEach((chave, itemCarrinho) {
      total += itemCarrinho.preco * itemCarrinho.quantidade;
    });
    return total;
  }
  int get totalDeUnidades {
    int total = 0;
    _itens.forEach((chave, item) {
      total += item.quantidade;
    });
    return total;
  }

  void adicionarItem({
    required String idProduto,
    required String nome,
    required double preco,
    required String imagemUrl,
  }) {
    if (_itens.containsKey(idProduto)) {
      _itens.update(
        idProduto,
        (itemExistente) => itemExistente.copyWith(
          quantidade: itemExistente.quantidade + 1,
        ),
      );
    } else {
      _itens.putIfAbsent(
        idProduto,
        () => CartModel(
          idDocumento: '', 
          idProduto: idProduto,
          nome: nome,
          preco: preco,
          quantidade: 1,
          imagemUrl: imagemUrl,
        ),
      );
    }
    
    notifyListeners(); 
  }

  void removerItem(String idProduto) {
    if (!_itens.containsKey(idProduto)) return;

    if (_itens[idProduto]!.quantidade > 1) {
      _itens.update(
        idProduto,
        (itemExistente) => itemExistente.copyWith(
          quantidade: itemExistente.quantidade - 1,
        ),
      );
    } else {
      _itens.remove(idProduto);
    }
    notifyListeners();
  }

  void esvaziarCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}