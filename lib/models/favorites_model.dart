class FavoritesModel {
  final String idProduto;
  final String imagemUrl;
  final String nome;
  final double preco;

  FavoritesModel({
    required this.idProduto,
    required this.imagemUrl,
    required this.nome,
    required this.preco,
  });

  factory FavoritesModel.fromMap(Map<String, dynamic> map){
    return FavoritesModel(
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
}