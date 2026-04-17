import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DadosPessoaisPage extends StatelessWidget {
  const DadosPessoaisPage({super.key});

  Widget _buildListItem(String title, {String? value, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE7E5),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade100,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              children: [
                if (value != null)
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey.shade500,
                    ),
                  ),
                if (value != null) const SizedBox(width: 8.0),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14.0,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7E5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE7E5),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Dados Pessoais',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 16.0),
            _buildListItem('Nome', value: 'Tuxedo Guaraná', onTap: () => context.push('/editar-nome-preferencia')),
            _buildListItem('E-mail', value: 't***0@gmail.com', onTap: () => context.push('/editar-email')),
            _buildListItem('Telefone', value: '*******0759'),
            _buildListItem('Senha', value: '**********'),
  
          ],
        ),
      ),
    );
  }
}
