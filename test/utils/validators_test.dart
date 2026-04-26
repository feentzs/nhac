import 'package:flutter_test/flutter_test.dart';
import 'package:nhac/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validarNome', () {
      expect(Validators.validarNome(''), 'Campo obrigatório');
      expect(Validators.validarNome('A'), 'O nome deve ter pelo menos 2 letras');
      expect(Validators.validarNome('João123'), 'O nome não pode conter números ou caracteres especiais');
      expect(Validators.validarNome('João Silva'), null);
    });

    test('validarEmail', () {
      expect(Validators.validarEmail(''), 'E-mail obrigatório');
      expect(Validators.validarEmail('invalido'), 'E-mail inválido');
      expect(Validators.validarEmail('teste!@gmail.com'), 'Caracteres inválidos (use apenas letras, números, @ e ponto)');
      expect(Validators.validarEmail('teste@gmail.com'), null);
    });

    test('validarSenha', () {
      expect(Validators.validarSenha(''), 'Senha obrigatória');
      expect(Validators.validarSenha('1234567'), 'Mínimo de 8 caracteres');
      expect(Validators.validarSenha('12345678'), 'Precisa de pelo menos uma letra maiúscula');
      expect(Validators.validarSenha('Senha123'), null);
    });

    test('validarTelefone', () {
      expect(Validators.validarTelefone(''), 'Telefone obrigatório');
      expect(Validators.validarTelefone('123456789'), 'Tamanho inválido (deve ter 10 ou 11 números)');
      expect(Validators.validarTelefone('abc12345678'), 'O telefone não pode conter letras ou caracteres especiais');
      expect(Validators.validarTelefone('(11) 99999-9999'), null);
    });

    test('validarCPF', () {
      expect(Validators.validarCPF(''), 'CPF obrigatório');
      expect(Validators.validarCPF('1234567890'), 'O CPF deve ter 11 dígitos');
      expect(Validators.validarCPF('111.111.111-11'), 'CPF inválido');
      expect(Validators.validarCPF('000.000.000-00'), 'CPF inválido');
      expect(Validators.validarCPF('123.456.789-01'), 'CPF inválido'); // Invalid checksum
      
      // Valid CPF example (generated or known)
      expect(Validators.validarCPF('52998224725'), null);
      expect(Validators.validarCPF('529.982.247-25'), null);
      expect(Validators.validarCPF('123.456.789-09'), null); // This one is valid!
    });
  });
}
