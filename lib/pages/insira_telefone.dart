import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  TextEditingController text = TextEditingController();

  bool _numeroValido = false;

  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: const Alignment(0.0, 0.0),
          children: [
            const Positioned(
              top: 55.0,
              left: 18.0,
              width: 274.0,
              height: 40.0,
              child: Text(
                'Qual o seu número?',
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
              height: 100.0,
              child: TextFormField(
                controller: text,
                enabled: true,
                autofocus: true,
                showCursor: true,
                cursorColor: const Color(0xFFFF6961),
                keyboardType: TextInputType.phone,
                inputFormatters: [maskFormatter],
                onChanged: (value) {
                  final apenasNumeros = maskFormatter.getUnmaskedText();
                  final ehValido = apenasNumeros.length == 11;
                  
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
              bottom: 24.0, 
              left: 21.0,
              height: 49.0,
              width: 351.0,
              child: ElevatedButton(
               onPressed: _numeroValido 
                ? () {
                     context.push('/verificacao_numero', extra: text.text);
                  }
                : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0xFFC9BCBC);
                    }
                    return const Color(0xFFFE645C);
                  }),
                  foregroundColor: const WidgetStatePropertyAll<Color?>(null),
                  shadowColor: const WidgetStatePropertyAll<Color?>(null),
                  elevation: const WidgetStatePropertyAll<double?>(null),
                  side: const WidgetStatePropertyAll<BorderSide?>(null),
                  shape: const WidgetStatePropertyAll<RoundedRectangleBorder?>(null),
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
          ],
        ),
      ),
    );
  }
}