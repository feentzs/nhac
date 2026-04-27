import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class HomeContent extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _currentAddress = 'Buscando localização...';

  @override
  void initState() {
    super.initState();
    _pegarLocalizacaoUsuario();
  }

  Future<void> _pegarLocalizacaoUsuario() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _currentAddress = 'GPS desativado');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _currentAddress = 'Permissão negada');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() => _currentAddress = 'Permissão negada permanentemente');
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            _currentAddress = '${place.street}, ${place.subLocality}';
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _currentAddress = 'Erro ao buscar endereço');
    }
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      _pegarLocalizacaoUsuario(),
      context.read<UserProvider>().carregarDadosUsuario(),
    ]);
  }

  void _abrirBuscaEndereco(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddressPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          refreshIndicatorExtent: 140.0,
          refreshTriggerPullDistance: 180.0,
          onRefresh: _onRefresh,
          builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
            return Center(
              child: Opacity(
                opacity: (pulledExtent / refreshIndicatorExtent).clamp(0.0, 1.0),
                child: Lottie.asset(
                  'assets/animations/loading_nhac.json',
                  width: 240,
                  height: 240,
                  animate: refreshState == RefreshIndicatorMode.refresh ||
                           refreshState == RefreshIndicatorMode.armed,
                ),
              ),
            );
          },
        ),
        SliverPadding(
          padding: const EdgeInsets.all(24.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10.0,
                              offset: const Offset(0.0, 4.0),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sua Localização',
                            style: TextStyle(color: Colors.grey, fontSize: 12.0),
                          ),
                          Text(
                            _currentAddress,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _abrirBuscaEndereco(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10.0,
                            offset: const Offset(0.0, 4.0),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Mudar',
                            style: TextStyle(
                              color: Color(0xFFFF6961),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Color(0xFFFF6961), size: 18.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 4.0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Procurar',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Icon(Icons.tune, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 100.0),
            ]),
          ),
        ),
      ],
    );
  }
}

class _AddressPickerSheet extends StatefulWidget {
  const _AddressPickerSheet();

  @override
  State<_AddressPickerSheet> createState() => _AddressPickerSheetState();
}

class _AddressPickerSheetState extends State<_AddressPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, String>> _sugestoes = [];
  bool _estaDigitando = false;
  bool _isLoadingSearch = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _sheetController.animateTo(
          0.95,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.60,
      minChildSize: 0.60,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.60, 0.95],
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  children: [
                    const Text(
                      'Onde você quer receber o seu pedido?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D201C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Busque pelo nome da rua e pelo número do seu endereço.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: _filtrarEnderecos,
                      style: const TextStyle(
                        color: Color(0xFF5D201C),
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nome da rua e número',
                        hintStyle: const TextStyle(color: Color(0xFFC9BCBC)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFC9BCBC), width: 2.0),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  _filtrarEnderecos('');
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isLoadingSearch)
                      Center(
                        child: Lottie.asset(
                          'assets/animations/loading_nhac.json',
                          width: 150,
                          height: 150,
                        ),
                      )
                    else if (_sugestoes.isEmpty && _estaDigitando)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.search_off_outlined, size: 48, color: Colors.grey.shade200),
                              const SizedBox(height: 16),
                              const Text('Nenhum endereço encontrado', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._sugestoes.map((item) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on_outlined, size: 20, color: Colors.grey),
                        ),
                        title: Text(
                          '${item['rua']}, ${item['numero']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Text('${item['bairro']}, ${item['cidade']}'),
                        onTap: () => Navigator.pop(context),
                      )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}