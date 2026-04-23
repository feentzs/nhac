class FavoritosModel {
  final String idDocumento;
  final String idProduto;
  final String imagemUrl;
  final String nome;
  final double preco;

  FavoritosModel({
    required this.idDocumento,
    required this.idProduto,
    required this.imagemUrl,
    required this.nome,
    required this.preco,
  });

  factory FavoritosModel.fromMap(Map<String, dynamic> map, String docId){
    return FavoritosModel(
      idDocumento: docId,
      idProduto: map['id_produto'] ?? '',
      imagemUrl: map['imagem_url'] ?? '',
      nome: map['nome'] ?? '',
      preco: map['preco']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id_produto': idProduto,
      'imagem_url': imagemUrl,
      'nome': nome,
      'preco': preco,
    };
  }
  FavoritosModel copyWith({
    String? idDocumento,
    String? idProduto,
    String? imagemUrl,
    String? nome,
    double? preco,
  }) => FavoritosModel(
    idDocumento: idDocumento ?? this.idDocumento,
    idProduto: idProduto ?? this.idProduto,
    imagemUrl: imagemUrl ?? this.imagemUrl,
    nome: nome ?? this.nome,
    preco: preco ?? this.preco,
  );

}