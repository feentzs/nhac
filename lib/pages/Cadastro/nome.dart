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

  TextEditingController text = TextEditingController();

  @override
  void initState() {
    super.initState();
    text.addListener(_verificarNome);
  }

  void _verificarNome() {
    final ehValido = text.text.trim().length >= 2;
    if (_nomeValido != ehValido) {
      setState(() {
        _nomeValido = ehValido;
      });
    }
  }

  @override
  void dispose() {
    text.removeListener(_verificarNome);
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            FlexSizedBox(
              height: 427.0,
              width: 393.0,
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
                        enabled: true,
                        autofocus: true,
                        showCursor: true,
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
                          hintText: 'Nome',
                          hintStyle: TextStyle(color: Color(0xFFC9BCBC)),
                        ),
                        controller: text,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FlexSizedBox(
              width: 393.0,
              height: 81.0,
              child: Padding(
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
                    onPressed: _nomeValido
                        ? () {
                            final cadastroData =
                                context.read<CadastroController>();
                            cadastroData.setNome(text.text);
                            context.push('/Cadastro/senha');

                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.disabled)) {
                          return Colors.grey.shade400;
                        }
                        return const Color(0xFFFE645C);
                      }),
                      foregroundColor: const WidgetStatePropertyAll<Color?>(
                        null,
                      ),
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
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.rtl,
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
