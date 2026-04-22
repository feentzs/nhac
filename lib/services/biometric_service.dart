import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  static final _auth = LocalAuthentication();

  /// Verifica se o dispositivo possui hardware de biometria ou suporte a bloqueio de tela.
  static Future<bool> canAuthenticate() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  /// Tenta autenticar o usuário usando biometria ou bloqueio de tela (PIN/Padrão).
  static Future<bool> authenticate() async {
    try {
      // Verifica se o dispositivo suporta algum tipo de autenticação
      final isSupported = await canAuthenticate();
      
      if (!isSupported) {
        // Se o dispositivo não suportar nada, permitimos o acesso para não travar o usuário.
        // Em um app real, você pode querer decidir se bloqueia ou se apenas loga um aviso.
        return true; 
      }

      return await _auth.authenticate(
        localizedReason: 'Autenticação necessária para acessar seus dados pessoais.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Permite PIN/Padrão/Senha como backup se a biometria falhar ou não estiver disponível
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Erro na autenticação biométrica: $e');
      return false;
    }
  }
}
