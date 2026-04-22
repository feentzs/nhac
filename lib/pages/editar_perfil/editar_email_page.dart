import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class EditarEmailPage extends StatefulWidget {
  const EditarEmailPage({super.key});

  @override
  State<EditarEmailPage> createState() => _EditarEmailPageState();
}

class _EditarEmailPageState extends State<EditarEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE7E5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87, size: 24),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Digite seu novo endereço de email',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                'Enviaremos um link de confirmação para o seu novo endereço de email',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28.0),
              TextField(
                controller: _emailController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 49.0,
                  child: ElevatedButton(
                    onPressed: (_emailController.text.trim().isNotEmpty &&
                            !_isLoading)
                        ? () async {
                            setState(() => _isLoading = true);
                            try {
                              // TODO: Firebase save logic
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
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
                      foregroundColor:
                          const WidgetStatePropertyAll<Color?>(null),
                      shadowColor: const WidgetStatePropertyAll<Color?>(null),
                      elevation: const WidgetStatePropertyAll<double?>(null),
                      side: const WidgetStatePropertyAll<BorderSide?>(null),
                      shape:
                          const WidgetStatePropertyAll<RoundedRectangleBorder?>(
                        null,
                      ),
                    ),
                    child: _isLoading
                        ? Lottie.asset(
                            'assets/animations/loading_nhac.json',
                            width: 60,
                            height: 60,
                          )
                        : const Text(
                            'Continuar',
                            style: TextStyle(
                              color: Color(0xFFFEE3E1),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
