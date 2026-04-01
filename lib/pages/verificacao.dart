import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

@NowaGenerated()
class Verificacao extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const Verificacao({super.key, required this.email});

  final String email;

  @override
  State<Verificacao> createState() {
    return _VerificacaoState();
  }
}

@NowaGenerated()
class _VerificacaoState extends State<Verificacao> {
  TextEditingController pinCode = TextEditingController();

  int _tempoRestante = 60;

  bool _podeReenviar = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _iniciarTimer();
  }

  void _iniciarTimer() {
    setState(() {
      _tempoRestante = 60;
      _podeReenviar = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tempoRestante > 0) {
        setState(() {
          _tempoRestante--;
        });
      } else {
        setState(() {
          _podeReenviar = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final corAtual = _podeReenviar
        ? const Color(0xFFFF6961)
        : const Color(0xFF5D201C);
    final textoAtual = _podeReenviar
        ? 'Remandar código por email'
        : 'Reenviar código em 00:${_tempoRestante.toString().padLeft(2, '0')}';
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: const Alignment(0.0, 0.0),
          children: [
            Positioned(
              top: 163.0,
              left: -2.0,
              right: 10.0,
              height: 70.0,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                pinTheme: PinTheme(
                  inactiveFillColor: const Color(0x33C9BCBC),
                  activeFillColor: const Color(0x33C9BCBC),
                  selectedFillColor: const Color(0x33C9BCBC),
                  inactiveColor: Colors.transparent,
                  activeColor: Colors.transparent,
                  selectedColor: Colors.transparent,
                  borderWidth: 1.0,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10.0),
                  fieldWidth: 40.0,
                  fieldHeight: 50.0,
                ),
                controller: pinCode,
                onChanged: (value) {},
                autoFocus: true,
                enableActiveFill: true,
                cursorColor: const Color(0xFFFF6961),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                keyboardType: TextInputType.number,
              ),
            ),
            const Positioned(
              top: 55.0,
              left: 18.0,
              width: 323.0,
              height: 34.0,
              child: Text(
                'Verifique seu email',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xFF5D201C),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              top: 97.0,
              left: 18.0,
              width: 355.0,
              height: 45.0,
              child: Text.rich(
                TextSpan(
                  text: 'Insira o código enviado para ',
                  style: const TextStyle(
                    color: Color(0x995D201C),
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        color: Color(0xFF5D201C),
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                      ),
                    ),
                    const TextSpan(
                      text: '. O email pode demorar até 1 minuto para chegar.',
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
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
              top: 241.0,
              left: 23.0,
              width: 14.0,
              height: 14.0,
              child: GestureDetector(
                onTap: _podeReenviar
                    ? () {
                        _iniciarTimer();
                      }
                    : null,
                child: SvgPicture(
                  const SvgAssetLoader('assets/reload.svg'),
                  colorFilter: ColorFilter.mode(corAtual, BlendMode.srcIn),
                ),
              ),
            ),
            Positioned(
              top: 238.0,
              left: 44.0,
              width: 230.0,
              height: 22.0,
              child: GestureDetector(
                onTap: _podeReenviar
                    ? () {
                        _iniciarTimer();
                      }
                    : null,
                child: Text(
                  textoAtual,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: corAtual,
                    fontWeight: FontWeight.w600,
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
