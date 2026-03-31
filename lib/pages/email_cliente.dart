import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: const Alignment(0.0, 0.0),
          children: [
            const Positioned(
              top: 65.0,
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
              top: 115.0,
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
                  shadows: const [
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
                      color: Color(0xFFD5CCCB),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 24.0,
              left: 21.0,
              height: 49.0,
              width: 351.0,
              child: GestureDetector(
                onTap: () {},
                child: ElevatedButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color?>(
                      Color(0xFFFE645C),
                    ),
                    foregroundColor: WidgetStatePropertyAll<Color?>(null),
                    shadowColor: WidgetStatePropertyAll<Color?>(null),
                    elevation: WidgetStatePropertyAll<double?>(null),
                    side: WidgetStatePropertyAll<BorderSide?>(null),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder?>(
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
            ),
            Positioned(
              top: 16.0,
              left: 18.0,
              height: 15.0,
              width: 15.0,
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
                  child: const Image(
                    image: AssetImage('assets/Arrow right (3).png'),
                    fit: BoxFit.cover,
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
