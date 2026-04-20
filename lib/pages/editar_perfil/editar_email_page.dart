import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:nhac/components/botao_largo_nhac.dart'; // Nosso Lego!

class EditarEmailPage extends StatefulWidget {
  const EditarEmailPage({super.key});

  @override
  State<EditarEmailPage> createState() => _EditarEmailPageState();
}

class _EditarEmailPageState extends State<EditarEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _emailValido = false;
  String? _erroEmail;

  @override
  void initState() {
    super.initState();
    // Ouve o teclado em tempo real para validar o email
    _emailController.addListener(_validarNovoEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // 1. A MÁGICA DA VALIDAÇÃO (Impede usar o mesmo e-mail)
  void _validarNovoEmail() {
    final novoEmail = _emailController.text.trim();
    final usuarioLogado = FirebaseAuth.instance.currentUser;
    final emailAtual = usuarioLogado?.email ?? '';

    setState(() {
      if (novoEmail.isEmpty) {
        _erroEmail = null;
        _emailValido = false;
      } else if (novoEmail.toLowerCase() == emailAtual.toLowerCase()) {
        _erroEmail = 'Este já é o seu e-mail atual'; // O ERRO APARECE AQUI!
        _emailValido = false;
      } else if (!novoEmail.contains('@') || !novoEmail.contains('.')) {
        _erroEmail = 'Insira um e-mail válido';
        _emailValido = false;
      } else {
        _erroEmail = null;
        _emailValido = true; // Só ativa o botão se tudo estiver perfeito!
      }
    });
  }

  // 2. O POP-UP SEGURO
  Future<void> _mostrarDialogoConfirmacaoSenha() async {
    final TextEditingController senhaController = TextEditingController();
    bool carregando = false;
    String? erroSenha;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Confirme sua identidade',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF5D201C)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Para sua segurança, digite sua senha atual antes de alterar o e-mail.',
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    cursorColor: const Color(0xFFFF6961),
                    onChanged: (_) => setStateDialog(() => erroSenha = null),
                    decoration: InputDecoration(
                      labelText: 'Senha atual',
                      errorText: erroSenha, // Mostra se a senha estiver errada
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFF6961), width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: carregando ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: carregando
                      ? null
                      : () async {
                          if (senhaController.text.isEmpty) {
                            setStateDialog(() => erroSenha = 'A senha não pode ser vazia');
                            return;
                          }

                          setStateDialog(() {
                            carregando = true;
                            erroSenha = null;
                          });

                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null && user.email != null) {
                              
                              // 1. Cria a credencial com a senha que o utilizador digitou
                              final credential = EmailAuthProvider.credential(
                                email: user.email!,
                                password: senhaController.text,
                              );
                              
                              // 2. Reautentica no Firebase
                              await user.reauthenticateWithCredential(credential);

                              if (!context.mounted) return;
                              final authService = context.read<AuthService>();
                              
                              // 3. AGORA SIM MUDA O E-MAIL
                              await authService.uptadeEmail(newEmail: _emailController.text.trim());
                              await context.read<UserProvider>().carregarDadosUsuario();

                              if (!context.mounted) return;
                              Navigator.pop(context); // Fecha pop-up
                              Navigator.pop(context); // Volta ao perfil

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('E-mail atualizado com sucesso!'), backgroundColor: Colors.green),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            setStateDialog(() {
                              carregando = false;
                              if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
                                erroSenha = 'Senha incorreta!';
                              } else {
                                erroSenha = 'Erro: ${e.message}';
                              }
                            });
                          } catch (e) {
                            setStateDialog(() {
                              carregando = false;
                              erroSenha = 'Erro inesperado. Tente novamente.';
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE645C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: carregando
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Confirmar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE7E5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87, size: 24),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      const Text(
                        'Digite seu novo endereço de email',
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Enviaremos um link de confirmação para o seu novo endereço de email',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28.0),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: _erroEmail, // <- O aviso do "mesmo e-mail" aparece aqui!
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 32.0, top: 16.0),
              child: BotaoLargoNhac(
                texto: 'Continuar',
                // Só abre o pop-up se o email for válido (e diferente do atual)
                onPressed: _emailValido ? () => _mostrarDialogoConfirmacaoSenha() : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}