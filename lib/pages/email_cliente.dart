import 'package:flutter/material.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:nhac/pages/dados_globais.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

@NowaGenerated()
class EmailCliente extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const EmailCliente({super.key});

  @override
  State<EmailCliente> createState() {
    return _EmailClienteState();
  }
}

@NowaGenerated()
class _EmailClienteState extends State<EmailCliente> {
  TextEditingController text = TextEditingController();
  


  bool _emailValido = false;

  final List<String> _dominios = [
    '@gmail.com',
    '@hotmail.com',
    '@outlook.com',
    '@yahoo.com.br',
    '@icloud.com',
  ];

  @override
  void initState() {
    super.initState();
    text.addListener(_verificarEmail);
  }

  void _verificarEmail() {
     String  emailUsuario = text.text;

    final bool ehValido = EmailValidator.validate(emailUsuario);
    if (_emailValido != ehValido) {
      setState(() {
        _emailValido = ehValido;
      });
    }
  }

  @override
  void dispose() {
    text.removeListener(_verificarEmail);
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: const Alignment(0.0, 0.0),
          children: [
            const Positioned(
              top: 55.0,
              left: 18.0,
              width: 323.0,
              height: 34.0,
              child: Text(
                'Qual o seu email?',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xFF5D201C),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              top: 105.0,
              left: 18.0,
              width: 337.0,
              child: TextFormField(
                controller: text,
                enabled: true,
                autofocus: true,
                showCursor: true,
                cursorColor: const Color(0xFFFF6961),
                style: const TextStyle(
                  color: Color(0xFF5D201C),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(offset: Offset(0.0, 0.0), color: Color(0xFFEC1212)),
                  ],
                ),
                obscureText: false,
                decoration: const InputDecoration(
                  filled: false,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFC9BCBC),
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Color(0xFFC9BCBC)),
                ),
              ),
            ),
            Positioned(
              top: 169.0,
              left: 18.0,
              right: 0.0,
              height: 40.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dominios.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 10.0),
                itemBuilder: (context, index) => ActionChip(
                  label: Text(_dominios[index]),
                  backgroundColor: const Color.fromARGB(255, 248, 234, 234),
                  labelStyle: const TextStyle(
                    color: Color(0xFF5D201C),
                    fontWeight: FontWeight.w800,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 248, 234, 234),
                      width: 1.0,
                    ),
                  ),
                  onPressed: () {
                    String currentText = text.text;
                    if (currentText.contains('@')) {
                      currentText = currentText.split('@')[0];
                    }
                    text.text = currentText + _dominios[index];
                    text.selection = TextSelection.fromPosition(
                      TextPosition(offset: text.text.length),
                    );
                  },
                ),
                physics: const ClampingScrollPhysics(),
              ),
            ),
            Positioned(
              top: 240.0,
              left: 18.0,
              width: 337.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1.0,
                      height: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'ou',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1.0,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24.0,
              left: 21.0,
              height: 49.0,
              width: 351.0,
              child: ElevatedButton(
                onPressed: _emailValido
                    ? () async {
                        emailDoUsuario = text.text.trim();
                            final emailEncodado = Uri.encodeComponent(emailDoUsuario);

                            bool emailExiste = await authService.value.checarEmail(emailDoUsuario);

                            if(emailExiste){
                              context.push('/continuar_senha/$emailEncodado');
                            }
                            

                        
                        
                        context.push('/Cadastro/senha/$emailEncodado');
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((
                    states,
                  ) {
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0xFFC9BCBC);
                    }
                    return const Color(0xFFFE645C);
                  }),
                  foregroundColor: const WidgetStatePropertyAll<Color?>(null),
                  shadowColor: const WidgetStatePropertyAll<Color?>(null),
                  elevation: const WidgetStatePropertyAll<double?>(null),
                  side: const WidgetStatePropertyAll<BorderSide?>(null),
                  shape: const WidgetStatePropertyAll<RoundedRectangleBorder?>(
                    null,
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
            Positioned(
              top: 16.0,
              left: 18.0,
              height: 21.0,
              width: 21.0,
              child: GestureDetector(
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
                  child: const Image(
                    image: AssetImage('assets/Arrow right (3).png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 275.0,
              left: 21.0,
              height: 49.0,
              width: 351.0,
              child: ElevatedButton(
                onPressed: () async {
                await context.read<AuthService>().signInWithGoogle();

                    if (authService.value.currentUser != null) {
                        if (context.mounted) {
                            context.go('/home-page');

                           }
                       }
                    },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color?>(
                    Theme.of(context).colorScheme.surface,
                  ),
                  foregroundColor: const WidgetStatePropertyAll<Color?>(null),
                  shadowColor: const WidgetStatePropertyAll<Color?>(null),
                  elevation: const WidgetStatePropertyAll<double?>(0.0),
                  side: const WidgetStatePropertyAll<BorderSide>(
                    BorderSide(color: Color(0xFF5D201C), width: 1.5),
                  ),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12.0),
                    SvgPicture.asset(
                      'assets/google-logo.svg',
                      height: 24.0,
                      width: 24.0,
                    ),
                    const Expanded(
                      child: Text(
                        'Continuar com o Google',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF5D201C),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36.0),
                  ],
                ),
                
              ),
            ),
            Positioned(
              top: 345.0,
              left: 21.0,
              height: 49.0,
              width: 351.0,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/insira_telefone');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color?>(
                    Theme.of(context).colorScheme.surface,
                  ),
                  foregroundColor: const WidgetStatePropertyAll<Color?>(null),
                  shadowColor: const WidgetStatePropertyAll<Color?>(null),
                  elevation: const WidgetStatePropertyAll<double?>(0.0),
                  side: const WidgetStatePropertyAll<BorderSide>(
                    BorderSide(color: Color(0xFF5D201C), width: 1.5),
                  ),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12.0),
                    const Icon(
                      Icons.phone,
                      size: 24.0,
                      color: Color(0xFF5D201C),
                    ),
                    const Expanded(
                      child: Text(
                        'Continuar com o telefone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF5D201C),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
