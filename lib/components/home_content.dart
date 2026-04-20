import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nhac/models/restaurants.dart'; // <-- O SEU MODELO IMPORTADO AQUI!

@NowaGenerated()
class HomeContent extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _currentAddress = 'Buscando localização...';

 // DADOS FAKE NÃO  GASTAR DINE+HEIRO REAL NISSO
  final List<RestaurantsModel> _restaurantesMock = [
    RestaurantsModel(
      uid: '1',
      aberta: true,
      categoria: 'Lanches',
      cep: '00000-000',
      cidade: 'São Paulo',
      estado: 'SP',
      horarios: {'seg': '10-22', 'ter': '10-22'},
      nome: 'Burgão do Zé',
      numero: '123',
      rua: 'Rua das Palmeiras',
      mediaAvaliacao: 4.8,
      imagemUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500&auto=format&fit=crop', 
      totalAvaliacoes: 124,
    ),
    RestaurantsModel(
      uid: '2',
      aberta: true,
      categoria: 'Pizza',
      cep: '11111-111',
      cidade: 'São Paulo',
      estado: 'SP',
      horarios: {'seg': '18-23'},
      nome: 'Pizzaria Bella Napoli',
      numero: '45',
      rua: 'Av. Paulista',
      mediaAvaliacao: 4.5,
      imagemUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=500&auto=format&fit=crop', // Imagem real de pizza
      totalAvaliacoes: 89,
    ),
    RestaurantsModel(
      uid: '3',
      aberta: false, 
      categoria: 'Japonesa',
      cep: '22222-222',
      cidade: 'São Paulo',
      estado: 'SP',
      horarios: {'seg': '11-15'},
      nome: 'Sushi House',
      numero: '90',
      rua: 'Rua Liberdade',
      mediaAvaliacao: 4.9,
      imagemUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=500&auto=format&fit=crop',
      totalAvaliacoes: 210,
    ),
  ];

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
        if (mounted) setState(() => _currentAddress = 'Definir localização manualmente');
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
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
                    Expanded(
                      child: Column(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, 
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
                      hintText: 'Procurar pratos ou restaurantes',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Icon(Icons.tune, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 32.0),

          // --- SESSÃO DE RESTAURANTES ---
          const Text(
            'Restaurantes em Destaque',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16.0),

          ListView.builder(
            shrinkWrap: true, 
            physics: const NeverScrollableScrollPhysics(), 
            itemCount: _restaurantesMock.length,
            itemBuilder: (context, index) {
              final restaurante = _restaurantesMock[index];
              return _buildRestaurantCard(restaurante);
            },
          ),
          
          const SizedBox(height: 80.0), 
        ],
      ),
    );
  }

  
  Widget _buildRestaurantCard(RestaurantsModel restaurante) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
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
      child: Material( 
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            debugPrint('Clicou no restaurante: ${restaurante.nome}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                    child: Image.network(
                      restaurante.imagemUrl,
                      height: 140.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                         return Container(
                           height: 140, color: Colors.grey.shade300, 
                           child: const Icon(Icons.restaurant, size: 50, color: Colors.grey),
                         );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: restaurante.aberta ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        restaurante.aberta ? 'Aberto' : 'Fechado',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Informações Abaixo da Imagem
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurante.nome,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '${restaurante.categoria} • ${restaurante.cidade}',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6961).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFF6961), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            restaurante.mediaAvaliacao.toString(),
                            style: const TextStyle(
                              color: Color(0xFFFF6961),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}