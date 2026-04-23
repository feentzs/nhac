import 'package:flutter/material.dart';
import 'package:nhac/components/botao_largo_nhac.dart';
import 'package:nhac/components/seta_voltar.dart';
import 'package:nhac/controllers/cadastro_controller.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:nhac/globals/ui_utils.dart';

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
  final TextEditingController _emailController = TextEditingController();

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
    _emailController.addListener(_verificarEmail);
  }

  void _verificarEmail() {
    String emailUsuario = _emailController.text;

    final bool ehValido = EmailValidator.validate(emailUsuario);
    if (_emailValido != ehValido) {
      setState(() {
        _emailValido = ehValido;
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_verificarEmail);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

             const SetaVoltar(),
             const SizedBox(height: 24.0),
              const Text(
                'Qual o seu email?',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xFF5D201C),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Precisamos dele para iniciar o seu cadastro ou aceder ao aplicativo.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF5D201C),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 22.0),

              TextFormField(
                controller: _emailController,
                enabled: true,
                autofocus: true,
                showCursor: true,
                cursorColor: const Color(0xFFFF6961),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Color(0xFF5D201C),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
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
              const SizedBox(height: 16.0),

              SizedBox(
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
                      String currentText = _emailController.text;
                      if (currentText.contains('@')) {
                        currentText = currentText.split('@')[0];
                      }
                      _emailController.text = currentText + _dominios[index];
                      _emailController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _emailController.text.length),
                      );
                    },
                  ),
                  physics: const BouncingScrollPhysics(),
                ),
              ),
              const SizedBox(height: 22.0),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey[300], thickness: 1.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'ou',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey[300], thickness: 1.0),
                  ),
                ],
              ),
              const SizedBox(height: 22.0),

              SizedBox(
                width: double.infinity,
                height: 49.0,
                child: ElevatedButton(
                  onPressed: () async {
                    final localContext = context;
                    final authService = localContext.read<AuthService>();
                    try {
                      await authService.signInWithGoogle(localContext);
                      if (!localContext.mounted) return;
                      localContext.go('/home-page');
                    } catch (e) {
                      if (localContext.mounted) {
                        localContext.showError(e.toString());
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color?>(
                      Theme.of(context).colorScheme.surface,
                    ),
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
                    children: [
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
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              SizedBox(
                width: double.infinity,
                height: 49.0,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/insira_telefone');
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color?>(
                      Theme.of(context).colorScheme.surface,
                    ),
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
                  child: const Row(
                    children: [
                      Icon(Icons.phone, size: 24.0, color: Color(0xFF5D201C)),
                      Expanded(
                        child: Text(
                          'Continuar com o telefone',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF5D201C),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 24.0),
                    ],
                  ),
                ),
              ),

                    ],
                  ),
                ),
              ),


              SizedBox(
                width: double.infinity,
                height: 49.0,
                child:BotaoLargoNhac(
                texto: 'Continuar',
                onPressed: _emailValido ? () async { await redirecionadorEmail(); } : null,
              ),
              ),
              const SizedBox(height: 16.0),  
            ],
          ),
        ),
      ),
    );
  }

  Future<void> redirecionadorEmail() async {
    final localContext = context;
    final authService = localContext.read<AuthService>();
    final cadastroData = localContext.read<CadastroController>();

    final emailDoUsuario = _emailController.text.trim();

    try {
      bool emailExiste = await authService.checarEmail(emailDoUsuario);

      if (!localContext.mounted) return;

      localContext.showInfo(
          emailExiste ? "Bem-vindo de volta!" : "Criando sua conta...");

      cadastroData.setEmail(emailDoUsuario);

      if (emailExiste) {
        if (!localContext.mounted) return;
        localContext.push('/continuar_senha');
      } else {
        if (!localContext.mounted) return;
        localContext.push('/cadastro/nome');
      }
    } catch (e) {
      if (!localContext.mounted) return;
      localContext.showError("Erro ao verificar email: $e");
    }
  }
}
