import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';

@NowaGenerated()
class ContinuarSenha extends StatefulWidget {
  final String email;
  
  @NowaGenerated({'loader': 'auto-constructor'})
  const ContinuarSenha({super.key, required this.email});

  @override
  State<ContinuarSenha> createState() {
    return _ContinuarSenhaState();
  }
}

@NowaGenerated()
class _ContinuarSenhaState extends State<ContinuarSenha> {
  bool _senhaValida = false;

  TextEditingController text = TextEditingController();

  TextEditingController text1 = TextEditingController();

  void _verificarSenha() {
    if (!mounted) {
      return;
    }
    setState(() {
      _senhaValida = text1.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    text.dispose();
    text1.dispose();
    super.dispose();
  }

  void logar() async {
  try {

    await authService.value.signIn(email: widget.email, password: text1.text);

    
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logado com sucesso!!"), backgroundColor: Colors.green),
    );
    
    context.go('/home-page'); 

  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    
    // Tratando mensagens amigáveis
    String erro = "Erro ao entrar";
    if (e.code == 'user-not-found') erro = "Usuário não encontrado.";
    if (e.code == 'wrong-password') erro = "Senha incorreta.";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(erro), backgroundColor: Colors.redAccent),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro inesperado: $e")),
    );
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
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                          origin: const Offset(0.0, 0.0),
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
                        'Insira sua senha',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 70.0,
                        width: double.infinity,
                        child: TextFormField(
                          enabled: true,
                          autofocus: true,
                          showCursor: true,
                          obscureText: true,
                          cursorColor: const Color(0xFFFF6961),
                          style: const TextStyle(
                            color: Color(0xFF5D201C),
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFC9BCBC),
                                width: 2.0,
                              ),
                            ),
                            hintText: 'Senha',
                            hintStyle: TextStyle(color: Color(0xFFC9BCBC)),
                          ),
                          controller: text1,
                          onChanged: (value) => _verificarSenha(),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
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
                 onPressed: _senhaValida 
  ? () => logar() 
  : null,


                  style: ButtonStyle(
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
