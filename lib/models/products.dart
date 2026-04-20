import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel{
  final String uid;
  final String categoria;
  final Timestamp? criadoEm;
  final String descricao;
  final bool disponivel;
  final String imagemUrl;
  final String lojaId;
  final double mediaAvaliacao;
  final String nome;
  final double preco;
  final int totalAvaliacoes;

  ProductsModel({
    required this.uid,
    required this.categoria,
    this.criadoEm,
    this.descricao = '',
    required this.disponivel,
    this.imagemUrl = '',
    required this.lojaId,
    this.mediaAvaliacao = 0.0,
    required this.nome,
    required this.preco,
    this.totalAvaliacoes = 0,
  });

  ProductsModel copyWith({
    String? uid,
    String? categoria,
    Timestamp? criadoEm,
    String? descricao,
    bool? disponivel,
    String? imagemUrl,
    String? lojaId,
    double? mediaAvaliacao,
    String? nome,
    double? preco,
    int? totalAvaliacoes,
  }) => ProductsModel(
    uid: uid ?? this.uid,
    categoria: categoria ?? this.categoria,
    criadoEm: criadoEm ?? this.criadoEm,
    descricao: descricao ?? this.descricao,
    disponivel: disponivel ?? this.disponivel,
    imagemUrl: imagemUrl ?? this.imagemUrl,
    lojaId: lojaId ?? this.lojaId,
    mediaAvaliacao: mediaAvaliacao ?? this.mediaAvaliacao,
    nome: nome ?? this.nome,
    preco: preco ?? this.preco,
    totalAvaliacoes: totalAvaliacoes ?? this.totalAvaliacoes,
  );

  factory ProductsModel.fromMap(Map<String, dynamic> map, String id){
    return ProductsModel(
      uid: id,
      categoria: map['categoria'] ?? '',
      criadoEm: map['criado_em'] as Timestamp?,
      descricao: map['descricao'] ?? '',
      disponivel: map['disponivel'] ?? false,
      imagemUrl: map['imagem_url'] ?? '',
      lojaId: map['loja_id'] ?? '',
      mediaAvaliacao: (map['media_avaliacao'] ?? 0).toDouble(),
      nome: map['nome'] ?? '',
      preco: (map['preco'] ?? 0.0).toDouble(),
      totalAvaliacoes: (map['total_avaliacoes'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'categoria': categoria,
      'criado_em': criadoEm ?? FieldValue.serverTimestamp(),
      'descricao': descricao,
      'disponivel': disponivel,
      'imagem_url': imagemUrl,
      'loja_id': lojaId,
      'media_avaliacao': mediaAvaliacao,
      'nome': nome,
      'preco': preco,
      'total_avaliacoes': totalAvaliacoes,
    };
  }
}