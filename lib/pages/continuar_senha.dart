import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:nhac/controllers/cadastro_controller.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class ContinuarSenha extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const ContinuarSenha({super.key});

  @override
  State<ContinuarSenha> createState() {
    return _ContinuarSenhaState();
  }
}

@NowaGenerated()
class _ContinuarSenhaState extends State<ContinuarSenha> {
  bool _senhaValida = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _senhaVisivel = false;

  TextEditingController text = TextEditingController();

  TextEditingController text1 = TextEditingController();

  void _verificarSenha() {
    if (!mounted) {
      return;
    }
    setState(() {
      _senhaValida = text1.text.isNotEmpty;
      if (_errorMessage != null) {
        _errorMessage = null;
      }
    });
  }

  @override
  void dispose() {
    text.dispose();
    text1.dispose();
    super.dispose();
  }

  Future<void> logar() async {
    try {
      final authService = context.read<AuthService>();
      final cadastroData = context.read<CadastroController>();

      await authService.signIn(
          email: cadastroData.email, password: text1.text.trim());

      if (!mounted) return;

      setState(() {
        _errorMessage = null;
      });

      await context.read<UserProvider>().carregarDadosUsuario();

      cadastroData.limparDados();

      context.go('/home-page');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String erro = "Erro ao entrar";
      if (e.code == 'user-not-found') erro = "Usuário não encontrado.";
      if (e.code == 'wrong-password') erro = "Senha incorreta.";

      setState(() {
        _errorMessage = erro;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Erro inesperado: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          } else {
                            GoRouter.of(context).go('/home-page');
                          }
                        },
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.black87, size: 20),
                      ),
                      const SizedBox(height: 18.0),
                      const Text(
                        'Bem-vindo Novamente!\nInsira sua senha',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          enabled: true,
                          autofocus: true,
                          showCursor: true,
                          obscureText: !_senhaVisivel,
                          obscuringCharacter: '⬤',
                          cursorColor: const Color(0xFFFF6961),
                          style: TextStyle(
                            color: const Color(0xFF5D201C),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            letterSpacing: _senhaVisivel ? 0.0 : 4.0,
                          ),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _errorMessage != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _errorMessage != null
                                    ? Colors.red
                                    : const Color(0xFFC9BCBC),
                                width: 2.0,
                              ),
                            ),
                            hintText: 'Senha',
                            hintStyle: const TextStyle(
                              color: Color(0xFFC9BCBC),
                              letterSpacing: 0.0,
                            ),
                            suffixIcon: IconButton(
                              icon: _senhaVisivel
                                  ? const Icon(
                                      Icons.visibility,
                                      color: Color(0xFFFF6961),
                                    )
                                  : SvgPicture.asset(
                                      'assets/olho-fechado.svg',
                                      width: 24.0,
                                      height: 24.0,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFC9BCBC),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                              onPressed: () {
                                setState(() {
                                  _senhaVisivel = !_senhaVisivel;
                                });
                              },
                            ),
                          ),
                          controller: text1,
                          onChanged: (value) => _verificarSenha(),
                        ),
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push('/verificacao');
                            },
                            child: const Text(
                              'Esqueceu sua senha?',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFFFF6961),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 21.0,
                right: 21.0,
                bottom: 24.0,
                top: 8.0,
              ),
              child: SizedBox(
                height: 49.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_senhaValida && !_isLoading)
                      ? () async {
                          setState(() => _isLoading = true);
                          try {
                            await logar();
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      _senhaValida
                          ? const Color(0xFFFF6961)
                          : Colors.grey.shade400,
                    ),
                    foregroundColor: const WidgetStatePropertyAll<Color?>(null),
                    shadowColor: const WidgetStatePropertyAll<Color?>(null),
                    elevation: const WidgetStatePropertyAll<double?>(null),
                    side: const WidgetStatePropertyAll<BorderSide?>(null),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? Transform.scale(
                          scale: 2.5,
                          child: Lottie.asset(
                            'assets/animations/botao_loading_nhac.json',
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        )
                      : const Text(
                          'Continuar',
                          style: TextStyle(
                            color: Color(0xFFFEE3E1),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
