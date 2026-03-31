import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated({'auto-width': 351, 'auto-height': 49})
class BotaoNhac extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const BotaoNhac({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/email-cliente');
      },
      child: ElevatedButton(
        onPressed: () {
          context.go('/email-cliente');
        },
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color?>(Color(0xFFFE645C)),
          foregroundColor: WidgetStatePropertyAll<Color?>(null),
          shadowColor: WidgetStatePropertyAll<Color?>(null),
          elevation: WidgetStatePropertyAll<double?>(null),
          side: WidgetStatePropertyAll<BorderSide?>(null),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder?>(null),
        ),
        child: const Text(
          'Começar',
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
    );
  }
}
