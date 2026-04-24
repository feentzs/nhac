import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:nhac/components/botao_largo_nhac.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:nhac/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'package:nhac/globals/ui_utils.dart';

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

  void renameName() async {
    final localContext = context;
    try {
      setState(() => _isLoading = true);

      final authService = localContext.read<AuthService>();

      await authService.updateUserName(userName: _nameController.text);

      if (!localContext.mounted) return;
      localContext.read<UserProvider>().iniciarEscutaUsuario();
      
      localContext.showSuccess('Nome atualizado com sucesso!');
      localContext.pop();
    } catch (e){
      if (!localContext.mounted) return;
      localContext.showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                        textCapitalization: TextCapitalization.words, 
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
                    ],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 32.0, top: 16.0),
              child: BotaoLargoNhac(
                texto: 'Salvar alterações',
                carregando: _isLoading,
                onPressed: (_nameController.text.trim().isNotEmpty && !_isLoading)
                      ? () => renameName()
                      : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
