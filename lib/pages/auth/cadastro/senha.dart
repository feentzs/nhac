import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nhac/components/botao_largo_nhac.dart';
import 'package:nhac/controllers/cadastro_controller.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class Senha extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const Senha({super.key});

  @override
  State<Senha> createState() {
    return _SenhaState();
  }
}

@NowaGenerated()
class _SenhaState extends State<Senha> {
  bool _senhaValida = false;
  bool _isLoading = false;
  String? _erroSenha;
  String? _erroConfirmacao;
  bool _senhaVisivel = false;
  bool _confirmacaoVisivel = false;

  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final FocusNode _senhaFocus = FocusNode();
  final FocusNode _confirmarSenhaFocus = FocusNode();

  void _verificarSenha() {
    if (!mounted) {
      return;
    }
    final senha = _senhaController.text;
    final confirmacao = _confirmarSenhaController.text;
    
    String? erroSenhaTemp;
    String? erroConfirmacaoTemp;
    
    if (senha.isNotEmpty) {
      if (senha.length < 8) {
        erroSenhaTemp = 'Mínimo de 8 caracteres';
      } else if (!senha.contains(RegExp('[A-Z]'))) {
        erroSenhaTemp = 'Precisa de pelo menos uma letra maiúscula';
      }
    }
    if (confirmacao.isNotEmpty && senha != confirmacao) {
      erroConfirmacaoTemp = 'As senhas não coincidem';
    }
    setState(() {
      _erroSenha = erroSenhaTemp;
      _erroConfirmacao = erroConfirmacaoTemp;
      _senhaValida =
          senha.isNotEmpty &&
          confirmacao.isNotEmpty &&
          _erroSenha == null &&
          _erroConfirmacao == null;
    });
  }

  @override
  void dispose() {
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
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
                          _senhaFocus.unfocus();
                          _confirmarSenhaFocus.unfocus();
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
                        'Vamos criar a sua senha',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'A sua nova senha tem que ter pelo menos 8 caracteres e 1 letra maiúscula.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: _senhaController,  
                        focusNode: _senhaFocus, 
                        onChanged: (value) => _verificarSenha(),
                        obscureText: !_senhaVisivel,
                        obscuringCharacter: '⬤',
                        autofocus: true,
                        cursorColor: const Color(0xFFFF6961),
                        style: TextStyle(
                          color: const Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          letterSpacing: _senhaVisivel ? 0.0 : 4.0,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFC9BCBC),
                              width: 2.0,
                            ),
                          ),
                          hintText: 'Senha',
                          hintStyle: const TextStyle(
                            color: Color(0xFFC9BCBC),
                            letterSpacing: 0.0,
                            fontSize: 16.0,
                          ),
                          errorText: _erroSenha,
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
                      ),
                      const SizedBox(height: 24.0),
                      TextFormField(
                        controller: _confirmarSenhaController, 
                        focusNode: _confirmarSenhaFocus, 
                        onChanged: (value) => _verificarSenha(),
                        obscureText: !_confirmacaoVisivel,
                        obscuringCharacter: '⬤',
                        cursorColor: const Color(0xFFFF6961),
                        style: TextStyle(
                          color: const Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          letterSpacing: _confirmacaoVisivel ? 0.0 : 4.0,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFC9BCBC),
                              width: 2.0,
                            ),
                          ),
                          hintText: 'Confirmar senha',
                          hintStyle: const TextStyle(
                            color: Color(0xFFC9BCBC),
                            letterSpacing: 0.0,
                            fontSize: 16.0,
                          ),
                          errorText: _erroConfirmacao,
                          suffixIcon: IconButton(
                            icon: _confirmacaoVisivel
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
                                _confirmacaoVisivel = !_confirmacaoVisivel;
                              });
                            },
                          ),
                        ),
                      ),
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
              child: BotaoLargoNhac(
                texto: 'Cadastrar', 
                onPressed: _senhaValida ? () => cadastrar() : null, 
                carregando: _isLoading,
              ),
            ),
            ],
        ),
      ),
    );
  }
  
  Future<void> cadastrar() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      final cadastroData = context.read<CadastroController>();

      await authService.createAccount(
        email: cadastroData.email, 
        password: _senhaController.text, 
        nome: cadastroData.nome,
        telefone: cadastroData.telefone
      );

      if (!mounted) return;

      cadastroData.limparDados();
      context.go('/home-page');

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String mensagem = "Erro ao criar conta";
      if (e.code == 'email-already-in-use') {
        mensagem = "Este e-mail já está em uso.";
      } else if (e.code == 'weak-password') {
        mensagem = "A senha é muito fraca.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro inesperado: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
