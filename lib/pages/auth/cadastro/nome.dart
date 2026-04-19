import 'package:flutter/material.dart';
import 'package:nhac/controllers/cadastro_controller.dart';
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
                  onPressed: _nomeValido
                      ? () {
                          final cadastroData = context.read<CadastroController>();
                          cadastroData.setNome(_nomeController.text.trim());
                          context.push('/cadastro/senha');
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