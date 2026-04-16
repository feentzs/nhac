class CartModel {
  final String idProduto;
  final String imagemUrl;
  final String nome;
  final double preco;
  final int quantidade;

  CartModel({
    required this.idProduto,
    required this.imagemUrl,
    required this.nome,
    required this.preco,
    required this.quantidade,
  });

  factory CartModel.fromMap(Map<String, dynamic> map){
    return CartModel(
      idProduto: map['id_produto'] ?? '',
      imagemUrl: map['imagem_url'] ?? '',
      nome: map['nome'] ?? '',
      preco: map['preco']?.toDouble() ?? 0.0,
      quantidade: map['quantidade'] ?? 0,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id_produto': idProduto,
      'imagem_url': imagemUrl,
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
    };
  }
}