import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:nhac/components/botao_largo_nhac.dart'; 

import 'package:nhac/globals/ui_utils.dart';

class EditarEmailPage extends StatefulWidget {
  const EditarEmailPage({super.key});

  @override
  State<EditarEmailPage> createState() => _EditarEmailPageState();
}

class _EditarEmailPageState extends State<EditarEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _emailValido = false;
  String? _erroEmail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validarNovoEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validarNovoEmail() {
    final novoEmail = _emailController.text.trim();
    final usuarioLogado = FirebaseAuth.instance.currentUser;
    final emailAtual = usuarioLogado?.email ?? '';

    setState(() {
      if (novoEmail.isEmpty) {
        _erroEmail = null;
        _emailValido = false;
      } else if (novoEmail.toLowerCase() == emailAtual.toLowerCase()) {
        _erroEmail = 'Este já é o seu e-mail atual';
        _emailValido = false;
      } else if (!novoEmail.contains('@') || !novoEmail.contains('.')) {
        _erroEmail = 'Insira um e-mail válido';
        _emailValido = false;
      } else {
        _erroEmail = null;
        _emailValido = true; 
      }
    });
  }

  Future<void> _processarAtualizacaoEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final hasPassword = user.providerData.any((info) => info.providerId == 'password');

    if (hasPassword) {
      _mostrarDialogoConfirmacaoSenha();
    } else {
      await _atualizarEmailSemSenha();
    }
  }

  Future<void> _atualizarEmailSemSenha() async {
    final localContext = context;
    try {
      setState(() => _isLoading = true);
      
      final authService = localContext.read<AuthService>();
      await authService.uptadeEmail(newEmail: _emailController.text.trim());
      
      if (!localContext.mounted) return;
      localContext.read<UserProvider>().iniciarEscutaUsuario();
      
      localContext.pop(); 
      localContext.showSuccess('Link de confirmação enviado para o novo e-mail!');
    } catch (e) {
      if (!localContext.mounted) return;
      localContext.showError('Erro ao atualizar e-mail: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _mostrarDialogoConfirmacaoSenha() async {
    final TextEditingController senhaController = TextEditingController();
    bool carregandoDialog = false;
    String? erroSenha;
    final parentContext = context;

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
                      errorText: erroSenha,
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
                  onPressed: carregandoDialog ? null : () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: carregandoDialog
                      ? null
                      : () async {
                          if (senhaController.text.isEmpty) {
                            setStateDialog(() => erroSenha = 'A senha não pode ser vazia');
                            return;
                          }

                          setStateDialog(() {
                            carregandoDialog = true;
                            erroSenha = null;
                          });

                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null && user.email != null) {
                              
                              final credential = EmailAuthProvider.credential(
                                email: user.email!,
                                password: senhaController.text,
                              );
                              
                              await user.reauthenticateWithCredential(credential);

                              if (!context.mounted) return;
                              final authService = parentContext.read<AuthService>();
                              
                              await authService.uptadeEmail(newEmail: _emailController.text.trim());
                              
                              if (!context.mounted) return;
                              parentContext.read<UserProvider>().iniciarEscutaUsuario();

                              if (context.mounted) Navigator.pop(context); // Fecha dialog
                              if (parentContext.mounted) parentContext.pop(); // Fecha página

                              parentContext.showSuccess('E-mail atualizado com sucesso!');
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setStateDialog(() {
                                carregandoDialog = false;
                                erroSenha = e.toString();
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE645C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: carregandoDialog
                      ? Transform.scale(
                          scale: 2.5,
                          child: Lottie.asset(
                            'assets/animations/botao_loading_nhac.json',
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        )
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
    final currentUser = FirebaseAuth.instance.currentUser;
    final isGoogleUser = currentUser?.providerData.any((info) => info.providerId == 'google.com') ?? false;

    if (isGoogleUser) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuários do Google não podem alterar o e-mail por aqui.')),
          );
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFE7E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE7E5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
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
                          errorText: _erroEmail,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Color(0xFFC9BCBC)),
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
                carregando: _isLoading,
                onPressed: _emailValido ? () => _processarAtualizacaoEmail() : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
