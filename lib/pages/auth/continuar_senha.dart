import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:nhac/components/botao_largo_nhac.dart';
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

  final TextEditingController _senhaController = TextEditingController();

  void _verificarSenha() {
    if (!mounted) {
      return;
    }
    setState(() {
      _senhaValida = _senhaController.text.isNotEmpty;
      if (_errorMessage != null) {
        _errorMessage = null;
      }
    });
  }

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> logar() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      final cadastroData = context.read<CadastroController>();

      await authService.signIn(
        email: cadastroData.email, 
        password: _senhaController.text.trim() 
      );
      
      if (!mounted) return;

      context.read<UserProvider>().iniciarEscutaUsuario();
      cadastroData.limparDados();
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logado com sucesso!!"), backgroundColor: Colors.green),
      );
      
      context.go('/home-page'); 

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      String erro = "Erro ao entrar";
      if (e.code == 'user-not-found') erro = "Usuário não encontrado.";
      if (e.code == 'wrong-password') erro = "Senha incorreta.";

      setState(() {
        _errorMessage = erro;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Erro inesperado: $e";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro inesperado: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                       child: Transform.scale(
                          scaleX: -1.0,
                          child: const SizedBox(
                            width: 21.0,
                            height: 21.0,
                            child: Image(
                              image: AssetImage('assets/Arrow right (3).png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                          controller: _senhaController, 
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
              padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 24.0, top: 8.0),
              child: BotaoLargoNhac(
                texto: 'Continuar',
                onPressed: _senhaValida ? () => logar() : null,
                carregando: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
