import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodsModel {
  final String idDocumento;
  final String bandeira;
  final Timestamp? criadoEm;
  final String nomeCartao;
  final bool padrao;
  final String tipo;
  final String ultimosDigitos;

  PaymentMethodsModel({
    required this.idDocumento,
    required this.bandeira,
    this.criadoEm,
    required this.nomeCartao,
    this.padrao = false,
    required this.tipo,
    required this.ultimosDigitos,
  });

  factory PaymentMethodsModel.fromMap(Map<String, dynamic> map, String docId) {
    return PaymentMethodsModel(
      idDocumento: docId,
      bandeira: map['bandeira'] ?? '',
      criadoEm: map['criado_em'] as Timestamp?, 
      nomeCartao: map['nome_cartao'] ?? '',
      padrao: map['padrao'] ?? false,
      tipo: map['tipo'] ?? '',
      ultimosDigitos: map['ultimos_digitos'] ?? '',
    );
  }

  PaymentMethodsModel copyWith({
    String? idDocumento,
    String? bandeira,
    Timestamp? criadoEm,
    String? nomeCartao,
    bool? padrao,
    String? tipo,
    String? ultimosDigitos,
  }) =>
      PaymentMethodsModel(
        idDocumento: idDocumento ?? this.idDocumento,
        bandeira: bandeira ?? this.bandeira,
        criadoEm: criadoEm ?? this.criadoEm,
        nomeCartao: nomeCartao ?? this.nomeCartao,
        padrao: padrao ?? this.padrao,
        tipo: tipo ?? this.tipo,
        ultimosDigitos: ultimosDigitos ?? this.ultimosDigitos,
      );

  Map<String, dynamic> toMap() {
    return {
      'bandeira': bandeira,
      'criado_em': criadoEm ?? FieldValue.serverTimestamp(),
      'nome_cartao': nomeCartao,
      'padrao': padrao,
      'tipo': tipo,
      'ultimos_digitos': ultimosDigitos,
    };
  }
}