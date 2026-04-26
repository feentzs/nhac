import 'package:email_validator/email_validator.dart';

class Validators {
  
  static String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
        if (value.trim().length < 2) {
      return 'O nome deve ter pelo menos 2 letras';
    }

    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) {
      return 'O nome não pode conter números ou caracteres especiais';
    }
    return null;
  }

  static String? validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail obrigatório';
    }
  

    if (!RegExp(r'^[a-zA-Z0-9@._-]+$').hasMatch(value.trim())) {
      return 'Caracteres inválidos (use apenas letras, números, @ e ponto)';
    }
    if (!EmailValidator.validate(value.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? validarSenha(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Senha obrigatória';
    }
    if (value.length < 8) {
      return 'Mínimo de 8 caracteres';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Precisa de pelo menos uma letra maiúscula';
    }
    return null;
  }

  static String? validarTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone obrigatório';
    }
    if (!RegExp(r'^[0-9\s()\-]+$').hasMatch(value)) {
      return 'O telefone não pode conter letras ou caracteres especiais';
    }

    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10 || digitsOnly.length > 11) {
      return 'Tamanho inválido (deve ter 10 ou 11 números)';
    }
    return null;
  }

  static String? validarCPF(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CPF obrigatório';
    }

    // Verificação 1: Remove a formatação e verifica se tem 11 dígitos
    final cpf = value.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11) {
      return 'O CPF deve ter 11 dígitos';
    }

    // Verificação 2: Bloqueia CPFs com todos os dígitos iguais (ex: 111.111.111-11)
    if (cpf.split('').every((char) => char == cpf[0])) {
      return 'CPF inválido';
    }

    // Verificação 3: Algoritmo de validação dos dígitos verificadores
    if (!_validarDigitosCPF(cpf)) {
      return 'CPF inválido';
    }

    return null;
  }

  static bool _validarDigitosCPF(String cpf) {
    List<int> numbers = cpf.split('').map((s) => int.parse(s)).toList();

    // Cálculo do primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += numbers[i] * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;
    if (numbers[9] != firstDigit) return false;

    // Cálculo do segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += numbers[i] * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;
    if (numbers[10] != secondDigit) return false;

    return true;
  }
}
