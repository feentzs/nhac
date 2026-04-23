import 'package:flutter/material.dart';
import 'package:nhac/components/botao_largo_nhac.dart';
import 'package:nhac/components/seta_voltar.dart';
import 'package:nhac/controllers/cadastro_controller.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class Nome extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const Nome({super.key});

  @override
  State<Nome> createState() {
    return _NomeState();
  }
}

@NowaGenerated()
class _NomeState extends State<Nome> {
  bool _nomeValido = false;

  final TextEditingController _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.addListener(_verificarNome);
  }

  void _verificarNome() {
    final ehValido = _nomeController.text.trim().length >= 2;
    if (_nomeValido != ehValido) {
      setState(() {
        _nomeValido = ehValido;
      });
    }
  }

  @override
  void dispose() {
    _nomeController.removeListener(_verificarNome);
    _nomeController.dispose();
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
                        'Qual o seu nome?',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFF5D201C),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _nomeController,
                        enabled: true,
                        autofocus: true, 
                        showCursor: true,
                        cursorColor: const Color(0xFFFF6961),
                        textCapitalization: TextCapitalization.words,
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
                          hintText: 'Nome',
                          hintStyle: TextStyle(color: Color(0xFFC9BCBC)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Padding( 
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0, top: 8.0),
              child: BotaoLargoNhac(
                texto: 'Continuar',
                onPressed: _nomeValido
                    ? () async {
                        final cadastroData = context.read<CadastroController>();
                        cadastroData.setNome(_nomeController.text.trim());

                      if (cadastroData.email.isNotEmpty) {
                          context.push('/cadastro/telefone'); 
                        } else {
                           final authService = context.read<AuthService>(); 
                           
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('A finalizar cadastro...')),
                           );

                           try {
                             await authService.finalizarCadastroTelefone(
                               nome: cadastroData.nome,
                               telefone: cadastroData.telefone,
                             );
                             
                             cadastroData.limparDados();
                             if (context.mounted) context.go('/home-page');
                             
                           } catch (e) {
                             if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
                               );
                             }
                           }
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}