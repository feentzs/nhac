import 'package:flutter_test/flutter_test.dart';
import 'package:nhac/models/usuario/usuario_model.dart';

void main() {
  test('Deve converter UserModel para Map (Formato Firebase) sem erros', () {
    
    final usuarioDaTela = UsuarioModel(
      uid: 'id-secreto-123',
      nome: 'Matheus',
      email: 'matheus@teste.com',
      fotoUrl: '',
      telefone: '11999999999',
    );

    final pacoteParaFirebase = usuarioDaTela.toMap();

    expect(pacoteParaFirebase['nome'], 'Matheus');
    expect(pacoteParaFirebase['email'], 'matheus@teste.com');
    expect(pacoteParaFirebase['telefone'], '11999999999');
    expect(pacoteParaFirebase['criado_em'], isNotNull); 
  });
}