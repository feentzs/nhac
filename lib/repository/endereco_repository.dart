import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nhac/models/usuario/endereco_model.dart';
import 'package:nhac/globals/app_constants.dart';

class EnderecoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<EnderecoModel>> ouvirEnderecos(String uid) {
    return _firestore
        .collection(AppConstants.firestoreUsuarios)
        .doc(uid)
        .collection(AppConstants.firestoreEnderecos)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EnderecoModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> adicionarEndereco(String uid, EnderecoModel endereco) async {
    final batch = _firestore.batch();
    
    if (endereco.padrao) {
      final enderecosAtuais = await _firestore
          .collection(AppConstants.firestoreUsuarios)
          .doc(uid)
          .collection(AppConstants.firestoreEnderecos)
          .where('padrao', isEqualTo: true)
          .get();
          
      for (var doc in enderecosAtuais.docs) {
        batch.update(doc.reference, {'padrao': false});
      }
    }

    final docRef = _firestore.collection(AppConstants.firestoreUsuarios).doc(uid).collection(AppConstants.firestoreEnderecos).doc();
    batch.set(docRef, endereco.toMap());
    
    await batch.commit();
  }

  Future<void> definirComoPadrao(String uid, String enderecoId) async {
    final batch = _firestore.batch();
    

    final enderecosAtuais = await _firestore
        .collection(AppConstants.firestoreUsuarios)
        .doc(uid)
        .collection(AppConstants.firestoreEnderecos)
        .where('padrao', isEqualTo: true)
        .get();
        
    for (var doc in enderecosAtuais.docs) {
      batch.update(doc.reference, {'padrao': false});
    }
    
    final docRef = _firestore
        .collection(AppConstants.firestoreUsuarios)
        .doc(uid)
        .collection(AppConstants.firestoreEnderecos)
        .doc(enderecoId);
    batch.update(docRef, {'padrao': true});
    
    await batch.commit();
  }

  Future<void> removerEndereco(String uid, String enderecoId) async {
    await _firestore
        .collection(AppConstants.firestoreUsuarios)
        .doc(uid)
        .collection(AppConstants.firestoreEnderecos)
        .doc(enderecoId)
        .delete();
  }
}
