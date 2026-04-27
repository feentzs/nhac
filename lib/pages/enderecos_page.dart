import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nhac/components/botao_largo_nhac.dart';
import 'package:nhac/components/seta_voltar.dart';
import 'package:nhac/controllers/endereco_provider.dart';
import 'package:nhac/globals/ui_utils.dart';
import 'package:nhac/models/usuario/endereco_model.dart';
import 'package:provider/provider.dart';

class EnderecosPage extends StatefulWidget {
  const EnderecosPage({super.key});

  @override
  State<EnderecosPage> createState() => _EnderecosPageState();
}

class _EnderecosPageState extends State<EnderecosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnderecoProvider>().iniciarEscutaEnderecos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final enderecoProvider = context.watch<EnderecoProvider>();
    final enderecos = enderecoProvider.enderecos;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE7E5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SetaVoltar(),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Endereços Salvos',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D201C),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Gerencie seus endereços para uma entrega mais rápida.',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: enderecoProvider.isLoading
                  ? Center(
                      child: Lottie.asset(
                        'assets/animations/botao_loading_nhac.json',
                        width: 250,
                        height: 250,
                      ),
                    )
                  : enderecos.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          itemCount: enderecos.length,
                          itemBuilder: (context, index) {
                            return _buildAddressCard(enderecos[index]);
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: BotaoLargoNhac(
                texto: 'Adicionar novo endereço',
                onPressed: () => _abrirBuscaEndereco(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirBuscaEndereco(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const _BuscaEnderecoOverlay();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.fastOutSlowIn;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/botao_loading_nhac.json',
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhum endereço salvo ainda.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF5D201C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(EnderecoModel endereco) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15.0,
            offset: const Offset(0, 5),
          ),
        ],
        border: endereco.padrao 
            ? Border.all(color: const Color(0xFFFE645C), width: 2)
            : Border.all(color: Colors.white, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.0),
          onTap: () {
            if (!endereco.padrao) {
              _confirmarPadrao(endereco);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFE645C).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    endereco.bairro.toLowerCase().contains('tabalho') || endereco.complemento.toLowerCase().contains('trabalho')
                        ? Icons.work_outline
                        : Icons.home_outlined,
                    color: const Color(0xFFFE645C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${endereco.rua}, ${endereco.numero}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Color(0xFF5D201C),
                            ),
                          ),
                          if (endereco.padrao) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFE645C),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'PADRÃO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '${endereco.bairro}, ${endereco.cidade} - ${endereco.estado}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.0,
                        ),
                      ),
                      if (endereco.complemento.isNotEmpty)
                        Text(
                          endereco.complemento,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildMenuButton(endereco),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(EnderecoModel endereco) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) async {
        if (value == 'padrao') {
          await context.read<EnderecoProvider>().definirComoPadrao(endereco.idDocumento);
          if (mounted) context.showSuccess('Endereço padrão atualizado!');
        } else if (value == 'remover') {
          _confirmarRemocao(endereco);
        }
      },
      itemBuilder: (context) => [
        if (!endereco.padrao)
          const PopupMenuItem(
            value: 'padrao',
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, size: 20),
                SizedBox(width: 8),
                Text('Definir como padrão'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'remover',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Remover', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmarPadrao(EnderecoModel endereco) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Definir como padrão?'),
        content: Text('Deseja que ${endereco.rua} seja seu endereço principal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<EnderecoProvider>().definirComoPadrao(endereco.idDocumento);
              if (mounted && context.mounted) context.showSuccess('Endereço padrão atualizado!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFE645C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmarRemocao(EnderecoModel endereco) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Remover endereço?'),
        content: const Text('Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<EnderecoProvider>().removerEndereco(endereco.idDocumento);
              if (mounted && context.mounted) context.showSuccess('Endereço removido!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Remover', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _BuscaEnderecoOverlay extends StatefulWidget {
  const _BuscaEnderecoOverlay();

  @override
  State<_BuscaEnderecoOverlay> createState() => _BuscaEnderecoOverlayState();
}

class _BuscaEnderecoOverlayState extends State<_BuscaEnderecoOverlay> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _sugestoes = [];
  bool _estaDigitando = false;
  bool _isLoadingSearch = false;
  Timer? _debounce;

  final List<Map<String, String>> _mockEnderecos = [
    {
      'rua': 'Avenida Do seu Coração',
      'numero': '4444',
      'bairro': 'Solidão',
      'cidade': 'São Paulo',
      'estado': 'SP'
    },
  ];

  void _filtrarEnderecos(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (query.isEmpty) {
      setState(() {
        _sugestoes = [];
        _estaDigitando = false;
        _isLoadingSearch = false;
      });
      return;
    }

    setState(() {
      _estaDigitando = true;
      _isLoadingSearch = true;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _sugestoes = _mockEnderecos.where((addr) {
          final fullAddr = '${addr['rua']} ${addr['bairro']} ${addr['cidade']}'.toLowerCase();
          return fullAddr.contains(query.toLowerCase());
        }).toList();
        _isLoadingSearch = false;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: Icon(Icons.close, color: Colors.black87, size: 24),
                    ),
                  ),
                  const SizedBox(height: 28.0),
                  const Text(
                    'Onde você quer receber o seu pedido?',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D201C),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Busque pelo nome da rua e pelo número do seu endereço.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF5D201C),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: _filtrarEnderecos,
                    style: const TextStyle(
                      color: Color(0xFF5D201C),
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                    cursorColor: const Color(0xFFFF6961),
                    decoration: InputDecoration(
                      hintText: 'Nome da rua e número',
                      hintStyle: const TextStyle(color: Color(0xFFC9BCBC)),
                      filled: false,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFC9BCBC),
                          width: 2.0,
                        ),
                      ),
                      icon: null,
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                _filtrarEnderecos('');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoadingSearch
                  ? _buildLoadingState()
                  : _sugestoes.isEmpty && _estaDigitando
                      ? _buildNotFound()
                      : _searchController.text.isEmpty
                          ? _buildEmptySearch()
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _sugestoes.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
                              itemBuilder: (context, index) {
                                final item = _sugestoes[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.location_on_outlined, color: Colors.grey),
                                  ),
                                  title: Text(
                                    '${item['rua']}, ${item['numero']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('${item['bairro']}, ${item['cidade']} - ${item['estado']}'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    context.showInfo('Endereço "${item['rua']}" selecionado!');
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/botao_loading_nhac.json',
            width: 250,
            height: 250,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 60, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(
            'Digite o nome da rua ou avenida',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 60, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(
            'Endereço não encontrado',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
