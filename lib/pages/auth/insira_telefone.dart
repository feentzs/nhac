import 'package:nhac/components/seta_voltar.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nhac/controllers/cadastro_controller.dart'; 

@NowaGenerated()
class InsiraTelefone extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const InsiraTelefone({super.key});

  @override
  State<InsiraTelefone> createState() {
    return _InsiraTelefoneState();
  }
}

@NowaGenerated()
class _InsiraTelefoneState extends State<InsiraTelefone> {
  final TextEditingController _telefoneController = TextEditingController();

  bool _numeroValido = false;

  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp('[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    _telefoneController.dispose();
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
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SetaVoltar(),
                      const SizedBox(height: 24.0),
                      
                      const Text(
                        'Qual o seu número?',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      
                      TextFormField(
                        controller: _telefoneController,
                        enabled: true,
                        autofocus: true,
                        showCursor: true,
                        cursorColor: const Color(0xFFFF6961),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [maskFormatter],
                        onChanged: (value) {
                          final apenasNumeros = maskFormatter.getUnmaskedText();
                          bool ehValido = false;

                          if (apenasNumeros.length == 11) {
                            final primeiroDigitoDDD = apenasNumeros[0];
                            final digitoNove = apenasNumeros[2];

                            if (primeiroDigitoDDD != '0' && digitoNove == '9') {
                              ehValido = true;
                            }
                          }

                          if (_numeroValido != ehValido) {
                            setState(() {
                              _numeroValido = ehValido;
                            });
                          }
                        },
                        style: const TextStyle(
                          color: Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFC9BCBC),
                              width: 2.0,
                            ),
                          ),
                          hintText: '(11) 99999-9999',
                          hintStyle: TextStyle(color: Color(0xFFC9BCBC)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 24.0,
                top: 8.0,
              ),
              child: SizedBox(
                height: 49.0,
                width: double.infinity,
                child: ElevatedButton(
                 onPressed: _numeroValido
                      ? () async {
                          final authService = context.read<AuthService>();
                          final cadastroData = context.read<CadastroController>();
                          
                          final telefoneLimpo = maskFormatter.getUnmaskedText();
                          cadastroData.setTelefone(telefoneLimpo); 

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('A enviar SMS...')),
                          );

                          await authService.enviarSmsDeVerificacao(
                            telefone: telefoneLimpo,
                            onCodeSent: (String verId) {
                              cadastroData.setVerificationId(verId);
                              if (mounted) {
                                context.push('/verificacao_numero', extra: _telefoneController.text);
                              }
                            },
                            onFailed: (String erro) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erro: $erro'), backgroundColor: Colors.red),
                                );
                              }
                            },
                          );
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey.shade400;
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