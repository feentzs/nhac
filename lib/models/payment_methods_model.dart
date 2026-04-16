import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodsModel {
  final String bandeira;
  final Timestamp? criadoEm;
  final String nomeCartao;
  final bool padrao;
  final String tipo;
  final String ultimosDigitos;

  PaymentMethodsModel({
    required this.bandeira,
    this.criadoEm,
    required this.nomeCartao,
    this.padrao = false,
    required this.tipo,
    required this.ultimosDigitos,
  });

  factory PaymentMethodsModel.fromMap(Map<String, dynamic> map){
    return PaymentMethodsModel(
      bandeira: map['bandeira'] ?? '',
      criadoEm: map['criado_em'],
      nomeCartao: map['nome_cartao'] ?? '',
      padrao: map['padrao'] ?? false,
      tipo: map['tipo'] ?? '',
      ultimosDigitos: map['ultimos_digitos'] ?? '',
    );
  }

  Map<String, dynamic> toMap(){
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