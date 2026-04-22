import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class EditarNomePreferenciaPage extends StatefulWidget {
  const EditarNomePreferenciaPage({super.key});

  @override
  State<EditarNomePreferenciaPage> createState() => _EditarNomePreferenciaPageState();
}

class _EditarNomePreferenciaPageState extends State<EditarNomePreferenciaPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
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
                'Editar Nome',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
             
              const SizedBox(height: 12.0),
              Text(
                'O nome é muito utilizado em nossas comunicações e em nosso atendimento.',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
               const SizedBox(height: 28.0),
              TextField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16.0,
                  ),
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
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 49.0,
                  child: ElevatedButton(
                    onPressed: (_nameController.text.trim().isNotEmpty && !_isLoading)
                        ? () async {
                            setState(() => _isLoading = true);
                            try {
                            } finally {
                              if (mounted) setState(() => _isLoading = false);
                            }
                          }
                        : null,
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
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
                    child: _isLoading
                        ? Transform.scale(
                            scale: 2.5,
                            child: Lottie.asset(
                              'assets/animations/botao_loading_nhac.json',
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const Text(
                      'Salvar alterações',
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
