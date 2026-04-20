import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:provider/provider.dart';

class EditarEmailPage extends StatefulWidget {
  const EditarEmailPage({super.key});

  @override
  State<EditarEmailPage> createState() => _EditarEmailPageState();
}

class _EditarEmailPageState extends State<EditarEmailPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  Future<void> _mostrarDialogoConfirmacaoSenha() async {
    final TextEditingController senhaController = TextEditingController();
    bool carregando = false;

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
                    decoration: InputDecoration(
                      labelText: 'Senha atual',
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
                          if (senhaController.text.isEmpty) return;

                          setStateDialog(() => carregando = true);

                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            
                            if (user != null && user.email != null) {
                              final credential = EmailAuthProvider.credential(
                                email: user.email!,
                                password: senhaController.text,
                              );
                              
                              await user.reauthenticateWithCredential(credential);

                              if (!context.mounted) return;
                              final authService = context.read<AuthService>();
                              await authService.uptadeEmail(newEmail: _emailController.text.trim());
                              
                              await context.read<UserProvider>().carregarDadosUsuario();

                              if (!context.mounted) return;
                              Navigator.pop(context); 
                              Navigator.pop(context); 

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('E-mail atualizado com sucesso!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            setStateDialog(() => carregando = false);
                            String erro = 'Erro na verificação';
                            if (e.code == 'wrong-password') erro = 'Senha incorreta!';
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(erro), backgroundColor: Colors.red),
                            );
                          } catch (e) {
                            setStateDialog(() => carregando = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE645C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: carregando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
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
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 32.0, top: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 49.0,
                child: ElevatedButton(
                  onPressed: _emailController.text.trim().isNotEmpty
                      ? () => _mostrarDialogoConfirmacaoSenha()
                      : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.disabled)) {
                        return const Color(0xFFC9BCBC);
                      }
                      return const Color(0xFFFE645C);
                    }),
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