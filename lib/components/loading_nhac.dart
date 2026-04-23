import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingNhac extends StatelessWidget {
  final String? mensagem;
  final bool telaCheia;
  final double tamanho;

  const LoadingNhac({
    super.key,
    this.mensagem,
    this.telaCheia = true,
    this.tamanho = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget loadingContent = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: tamanho,
          height: tamanho,
          child: Lottie.asset(
            'assets/animations/nhac-intro.json',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFE645C),
                ),
              );
            },
          ),
        ),
        if (mensagem != null) ...[
          const SizedBox(height: 16),
          Text(
            mensagem!,
            style: const TextStyle(
              color: Color(0xFF5D201C),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (telaCheia) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFE7E5),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: loadingContent,
          ),
        ),
      );
    }

    return Center(child: loadingContent);
  }

  static void mostrar(BuildContext context, {String? mensagem}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: LoadingNhac(
            mensagem: mensagem,
            telaCheia: false,
            tamanho: 120,
          ),
        ),
      ),
    );
  }

  static void esconder(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
