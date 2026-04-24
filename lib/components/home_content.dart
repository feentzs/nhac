import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:nhac/components/pega_endereco.dart'; 

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _currentAddress = 'Verificando localização...';

  @override
  void initState() {
    super.initState();
    _verificarPermissaoSilenciosa();
  }

  Future<void> _verificarPermissaoSilenciosa() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _currentAddress = 'GPS desativado');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      await _buscarLocalizacaoInterna();
    } else if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _currentAddress = 'Permissão negada permanentemente');
    } else {
      if (mounted) setState(() => _currentAddress = 'Toque para ativar localização');
    }
  }

  Future<void> _solicitarPermissaoNativa() async {
    if (mounted) setState(() => _currentAddress = 'Aguardando permissão...');
    
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _currentAddress = 'Toque para ativar localização');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _currentAddress = 'Permissão negada permanentemente');
      return;
    }

    if (mounted) setState(() => _currentAddress = 'Buscando localização...');
    await _buscarLocalizacaoInterna();
  }

  Future<void> _buscarLocalizacaoInterna() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

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
      _verificarPermissaoSilenciosa(),
      context.read<UserProvider>().carregarDadosUsuario(),
    ]);
  }

  void _abrirBuscaEndereco(BuildContext context) async {
    final enderecoSelecionado = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddressPickerSheet(),
    );

    if (enderecoSelecionado != null && mounted) {
      setState(() {
        _currentAddress = '${enderecoSelecionado['rua']}, ${enderecoSelecionado['numero']}';
      });
    }
  }

  void _tratarCliqueLocalizacao() {
    if (_currentAddress == 'Toque para ativar localização' || _currentAddress == 'GPS desativado') {
      _solicitarPermissaoNativa();
    } else {
      _abrirBuscaEndereco(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: _onRefresh,
          builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
            return Center(
              child: Opacity(
                opacity: (pulledExtent / refreshIndicatorExtent).clamp(0.0, 1.0),
                child: Lottie.asset('assets/animations/botao_loading_nhac.json', width: 240, height: 240),
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
                  Expanded(
                    child: GestureDetector(
                      onTap: _tratarCliqueLocalizacao,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10.0, offset: const Offset(0.0, 4.0))],
                            ),
                            child: const Icon(Icons.location_on_outlined, color: Colors.grey, size: 20.0),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sua Localização', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                Text(
                                  _currentAddress,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: _currentAddress == 'Toque para ativar localização' ? const Color(0xFFFF6961) : Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _abrirBuscaEndereco(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      margin: const EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10.0, offset: const Offset(0.0, 4.0))],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Mudar', style: TextStyle(color: Color(0xFFFF6961), fontWeight: FontWeight.w600, fontSize: 12.0)),
                          Icon(Icons.chevron_right, color: Color(0xFFFF6961), size: 18.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10.0, offset: const Offset(0.0, 4.0))],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Procurar restaurantes e pratos',
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