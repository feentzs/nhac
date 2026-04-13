import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
          desiredAccuracy: LocationAccuracy.high);

      
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              Container(
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
                    Icon(Icons.chevron_right, color:Color(0xFFFF6961), size: 18.0),
                  ],
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
          const SizedBox(height: 24.0),
          const SizedBox(height: 32.0),
          const SizedBox(height: 16.0),
          const SizedBox(height: 32.0),
          const SizedBox(height: 16.0),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}