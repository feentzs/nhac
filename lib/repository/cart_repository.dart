import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nhac/models/usuario/carrinho_model.dart';
import 'package:nhac/globals/app_constants.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarItemAoCarrinho(String uidUsuario, CarrinhoModel item) async {
    try {
      await _firestore
          .collection(AppConstants.firestoreUsuarios)
          .doc(uidUsuario)
          .collection(AppConstants.firestoreCarrinho)
          .doc(item.idProduto) 
          .set(item.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint("Erro ao adicionar ao carrinho: $e");
      rethrow;
    }
  }

  Future<void> removerItemDoCarrinho(String uidUsuario, String idProduto) async {
    try {
      await _firestore
          .collection(AppConstants.firestoreUsuarios)
          .doc(uidUsuario)
          .collection(AppConstants.firestoreCarrinho)
          .doc(idProduto)
          .delete();
    } catch (e) {
      debugPrint("Erro ao remover do carrinho: $e");
      rethrow;
    }
  }

  Future<void> esvaziarCarrinho(String uidUsuario) async {
    try {
      var snapshots = await _firestore
          .collection(AppConstants.firestoreUsuarios)
          .doc(uidUsuario)
          .collection(AppConstants.firestoreCarrinho)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint("Erro ao esvaziar carrinho: $e");
      rethrow;
    }
  }

  Stream<List<CarrinhoModel>> ouvirCarrinho(String uidUsuario) {
    return _firestore
        .collection(AppConstants.firestoreUsuarios)
        .doc(uidUsuario)
        .collection(AppConstants.firestoreCarrinho)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CarrinhoModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}