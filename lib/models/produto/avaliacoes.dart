import 'package:cloud_firestore/cloud_firestore.dart';

class AvaliacoesModel{
  final String comentario;
  final Timestamp? criadoEm;
  final String idDocumento;
  final String nomeUsuario;
  final double nota;
  final String userId;

  AvaliacoesModel({
    this.comentario = '',
    this.criadoEm,
    required this.idDocumento,
    required this.nomeUsuario,
    required this.nota,
    required this.userId,
  });

  AvaliacoesModel copyWith({
    String? comentario,
    Timestamp? criadoEm,
    String? idDocumento,
    String? nomeUsuario,
    double? nota,
    String? userId,
  }) => AvaliacoesModel(
    comentario: comentario ?? this.comentario,
    criadoEm: criadoEm ?? this.criadoEm,
    idDocumento: idDocumento ?? this.idDocumento,
    nomeUsuario: nomeUsuario ?? this.nomeUsuario,
    nota: nota ?? this.nota,
    userId: userId ?? this.userId,
  );

  factory AvaliacoesModel.fromMap(Map<String, dynamic> map, String docId){
    return AvaliacoesModel(
      comentario: map['comentario'] ?? '',
      criadoEm: map['criado_em'] as Timestamp?,
      idDocumento: docId,
      nomeUsuario: map['nome_usuario'] ?? '',
      nota: (map['nota'] ?? 0).toDouble(),
      userId: map['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'comentario': comentario,
      'criado_em': criadoEm ?? FieldValue.serverTimestamp(),
      'nome_usuario': nomeUsuario,
      'nota': nota,
      'user_id': userId,
    };
  }
}