import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:go_router/go_router.dart';

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

  final List<String> _dominios = [
    '@gmail.com',
    '@hotmail.com',
    '@outlook.com',
    '@yahoo.com.br',
    '@icloud.com',
  ];

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
              top: 280.0,
              left: 162.5,
              width: 48.0,
              height: 48.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.network(
                        'https://developers.google.com/identity/images/g-logo.png',
                        fit: BoxFit.contain,
                      ),
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
              child: ElevatedButton(
                onPressed: () {
                  context.push('/verificacao', extra: text.text);
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color?>(
                    Color(0xFFFE645C),
                  ),
                  foregroundColor: WidgetStatePropertyAll<Color?>(null),
                  shadowColor: WidgetStatePropertyAll<Color?>(null),
                  elevation: WidgetStatePropertyAll<double?>(null),
                  side: WidgetStatePropertyAll<BorderSide?>(null),
                  shape: WidgetStatePropertyAll<RoundedRectangleBorder?>(null),
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
          ],
        ),
      ),
    );
  }
}
