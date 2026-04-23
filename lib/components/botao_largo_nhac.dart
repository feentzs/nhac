import 'package:flutter/material.dart';

class BotaoLargoNhac extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed; 
  final bool carregando;

  const BotaoLargoNhac({
    super.key,
    required this.texto,
    this.onPressed,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 49.0,
      child: ElevatedButton(
        onPressed: carregando ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFC9BCBC);
            }
            return const Color(0xFFFE645C);
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
        child: carregando
            ? const SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                texto,
                style: const TextStyle(
                  color: Color(0xFFFEE3E1),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
              ),
      ),
    );
  }
}