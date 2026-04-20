import 'package:flutter/material.dart';
import 'package:nhac/controllers/cadastro_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:nhac/components/botao_largo_nhac.dart';
import 'package:nhac/components/seta_voltar.dart';

class TelefoneCadastro extends StatefulWidget {
  const TelefoneCadastro({super.key});

  @override
  State<TelefoneCadastro> createState() => _TelefoneCadastroState();
}

class _TelefoneCadastroState extends State<TelefoneCadastro> {
  final TextEditingController _telefoneController = TextEditingController();
  bool _telefoneValido = false;

  void _verificarTelefone() {
    setState(() {
      _telefoneValido = _telefoneController.text.trim().length >= 10;
    });
  }

  @override
  void dispose() {
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7E5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SetaVoltar(), 
                      const SizedBox(height: 24.0),
                      const Text(
                        'Qual é o seu número?',
                        style: TextStyle(
                          fontSize: 26.0,
                          color: Color(0xFF5D201C),
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Precisamos dele para que o entregador possa entrar em contato com você.',
                        style: TextStyle(fontSize: 15.0, color: Colors.grey.shade800),
                      ),
                      const SizedBox(height: 32.0),
                      TextField(
                        controller: _telefoneController,
                        onChanged: (value) => _verificarTelefone(),
                        keyboardType: TextInputType.phone, 
                        autofocus: true,
                        cursorColor: const Color(0xFFFF6961),
                        style: const TextStyle(fontSize: 20.0, color: Colors.black87, fontWeight: FontWeight.w600, letterSpacing: 2.0),
                        decoration: const InputDecoration(
                          hintText: '11999999999',
                          hintStyle: TextStyle(color: Colors.grey, letterSpacing: 0),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF6961), width: 2)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0, top: 8.0),
              child: BotaoLargoNhac( 
                texto: 'Continuar',
                onPressed: _telefoneValido
                    ? () {
                        context.read<CadastroController>().setTelefone(_telefoneController.text.trim());
                        context.push('/cadastro/senha');
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}