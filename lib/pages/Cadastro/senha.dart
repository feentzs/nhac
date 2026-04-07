import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  String? _erroSenha;
  String? _erroConfirmacao;

  bool _senhaVisivel = false;
  bool _confirmacaoVisivel = false;

  // Controladores de Texto
  TextEditingController text = TextEditingController();
  TextEditingController text1 = TextEditingController();

  // Controladores de Foco
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();

  void _verificarSenha() {
    if (!mounted) return; 

    final senha = text.text;
    final confirmacao = text1.text;

    String? erroSenhaTemp;
    String? erroConfirmacaoTemp;

    if (senha.isNotEmpty) {
      if (senha.length < 8) {
        erroSenhaTemp = 'Mínimo de 8 caracteres';
      } else if (!senha.contains(RegExp(r'[A-Z]'))) {
        erroSenhaTemp = 'Precisa de pelo menos uma letra maiúscula';
      }
    }

    if (confirmacao.isNotEmpty && senha != confirmacao) {
      erroConfirmacaoTemp = 'As senhas não coincidem';
    }

    setState(() {
      _erroSenha = erroSenhaTemp;
      _erroConfirmacao = erroConfirmacaoTemp;
      _senhaValida = senha.isNotEmpty &&
          confirmacao.isNotEmpty &&
          _erroSenha == null &&
          _erroConfirmacao == null;
    });
  }

  @override
  void dispose() {
    // ✨ A CORREÇÃO ESTÁ AQUI: Removemos os focus.unfocus()! 
    // Deixamos apenas os comandos de destruir a memória (dispose), que é o correto.
    focus1.dispose();
    focus2.dispose();
    text.dispose();
    text1.dispose();
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
                      // Botão Voltar
                      GestureDetector(
                        onTap: () {
                          // Aqui podemos manter o unfocus, pois a tela ainda está "viva" enquanto o clique ocorre
                          focus1.unfocus();
                          focus2.unfocus();
                          if (GoRouter.of(context).canPop()) {
                            GoRouter.of(context).pop();
                          } else {
                            GoRouter.of(context).go('/home-page');
                          }
                        },
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
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
                        'A sua nova senha tem que ter pelo menos 8 caracteres.',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      
                      const SizedBox(height: 24.0),
                      
                      // Campo: Senha Principal
                      TextFormField(
                        controller: text,
                        focusNode: focus1, 
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
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFC9BCBC), width: 2.0),
                          ),
                          hintText: 'Senha',
                          hintStyle: const TextStyle(
                            color: Color(0xFFC9BCBC), 
                            letterSpacing: 0,
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

                      // Campo: Confirmar Senha
                      TextFormField(
                        controller: text1,
                        focusNode: focus2, 
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
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFC9BCBC), width: 2.0),
                          ),
                          hintText: 'Confirmar senha',
                          hintStyle: const TextStyle(
                            color: Color(0xFFC9BCBC),
                            letterSpacing: 0,
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
            
            // Botão Continuar
            Padding(
              padding: const EdgeInsets.only(left: 21.0, right: 21.0, bottom: 24.0, top: 8.0),
              child: SizedBox(
                height: 49.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _senhaValida 
                      ? () {
                          // Tiramos o foco das caixas (esconde o teclado) suavemente
                          focus1.unfocus();
                          focus2.unfocus();
                          
                          // Navega após um pequeno atraso, permitindo que a transição ocorra com segurança
                          Future.delayed(const Duration(milliseconds: 250), () {
                            if (mounted) {
                              context.go('/home-page');
                            }
                          });
                        } 
                      : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      _senhaValida ? const Color(0xFFFE645C) : Colors.grey.shade400,
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
                  child: const Text(
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