import 'package:flutter_test/flutter_test.dart';
import 'package:nhac/models/products.dart';

void main() {
  group('ProductsModel Tests', () {
    test('Deve converter um Map do Firebase para ProductsModel corretamente', () {
      final mockMap = {
        'categoria': 'Hambúrguer',
        'descricao': 'Pão artesanal, carne dupla e queijo cheddar',
        'disponivel': true,
        'imagem_url': 'http://site.com/hamburguer.jpg',
        'loja_id': 'loja-123',
        'media_avaliacao': 4.9,
        'nome': 'Super Nhac Bacon',
        'preco': 35.90,
        'total_avaliacoes': 150,
      };

      final produto = ProductsModel.fromMap(mockMap, 'produto-456');

      expect(produto.uid, 'produto-456');
      expect(produto.nome, 'Super Nhac Bacon');
      expect(produto.preco, 35.90);
      expect(produto.disponivel, true);
      expect(produto.lojaId, 'loja-123');
    });

    test('Deve usar valores por defeito quando o Map estiver incompleto', () {
      final produtoVazio = ProductsModel.fromMap(const {}, 'id-vazio');

      expect(produtoVazio.nome, '');
      expect(produtoVazio.preco, 0.0);
      expect(produtoVazio.disponivel, false);
      expect(produtoVazio.totalAvaliacoes, 0);
    });

    test('Deve converter ProductsModel para Map corretamente', () {
      final produto = ProductsModel(
        uid: 'produto-456',
        categoria: 'Hambúrguer',
        disponivel: true,
        lojaId: 'loja-123',
        nome: 'Super Nhac Bacon',
        preco: 35.90,
      );

      final map = produto.toMap();

      expect(map['nome'], 'Super Nhac Bacon');
      expect(map['preco'], 35.90);
      expect(map['disponivel'], true);
      expect(map.containsKey('uid'), false); 
    });
  });
}