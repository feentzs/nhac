import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:nhac/services/biometric_service.dart';
import 'package:provider/provider.dart';

class ProfileContent extends StatelessWidget {
  
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
  final usuario = userProvider.usuario;

   if (usuario == null) {
     return const Center(child: CircularProgressIndicator());
   }

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFE7E5),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              refreshIndicatorExtent: 140.0,
              refreshTriggerPullDistance: 180.0,
              onRefresh: () async {
                await context.read<UserProvider>().carregarDadosUsuario();
              },
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
              const SizedBox(height: 16.0),
              const SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 400),
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return Scaffold(
                              
                              backgroundColor: Colors.white,
                              body: SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Notificações',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 32),
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade300),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Você não tem novas notificações.',
                                                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
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
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none,
                          color: Colors.black87),
                    ),
                  ),
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Opções da Conta',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.help_outline, color: Colors.grey.shade700),
                                            const SizedBox(width: 12),
                                            Text('Ajuda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
                                          ],
                                        ),
                                        Icon(Icons.chevron_right, color: Colors.grey.shade400),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Saindo...')),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.logout, color: Colors.grey.shade700),
                                            const SizedBox(width: 12),
                                            Text('Sair da conta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
                                          ],
                                        ),
                                        Icon(Icons.chevron_right, color: Colors.grey.shade400),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 48),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56.0,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF6961),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28.0),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Voltar',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.more_horiz, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: (usuario != null && usuario.fotoUrl.isNotEmpty)
                              ? DecorationImage(
                                  image: NetworkImage(usuario.fotoUrl),
                                  fit: BoxFit.cover, 
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: (usuario != null && usuario.fotoUrl.isNotEmpty)
                            ? null
                            : Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                size: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                 const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan( 
                  // text: usuario.nome,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D201C),
                    fontFamily: 'Roboto', 
                  ),
                ),
              ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4.0),
                            Text(
                              'Rua das Palmeiras, 120',
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('3', 'Pedidos'),
                  Container(height: 30, width: 1, color: Colors.grey.shade300),
                  _buildStatItem('1', 'Avaliações'),
                  Container(height: 30, width: 1, color: Colors.grey.shade300),
                  _buildStatItem('67', 'Cupons'),
                ],
              ),
              const SizedBox(height: 40.0),

              const Text(
                'Sua Conta',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 15.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildAccountRow(
                      icon: Icons.person_outline,
                      iconColor: const Color(0xFFFF6961),
                      title: 'Dados Pessoais',
                      subtitle: 'Nome, e-mail, telefone...',
                      onTap: () async {
                        final autenticado = await BiometricService.authenticate();
                        if (autenticado && context.mounted) {
                          context.push('/dados-pessoais');
                        }
                      },
                    ),
                    Divider(height: 1, color: Colors.grey.shade100, indent: 64),
                    _buildAccountRow(
                      icon: Icons.location_on_outlined,
                      iconColor: const Color(0xFFFF6961),
                      title: 'Endereços Salvos',
                      subtitle: 'Casa, Trabalho...',
                    ),
                    Divider(height: 1, color: Colors.grey.shade100, indent: 64),
                    _buildAccountRow(
                      icon: Icons.credit_card_outlined,
                      iconColor: const Color(0xFFFF6961),
                      title: 'Formas de Pagamento',
                      subtitle: 'PIX, Cartões de Crédito...',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32.0),
              const Text(
                'Preferências de Comida',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 15.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildPreferenceItem(Icons.local_pizza, 'Pizza', true),
                      const SizedBox(width: 20.0),
                      _buildPreferenceItem(
                          Icons.ramen_dining, 'Vegetariana', false),
                      const SizedBox(width: 20.0),
                      _buildPreferenceItem(Icons.fastfood, 'Salgados', false),
                      const SizedBox(width: 20.0),
                      _buildPreferenceItem(
                          Icons.bakery_dining, 'Padarias', false),
                      const SizedBox(width: 20.0),
                      _buildPreferenceItem(
                          Icons.set_meal, 'Frutos do mar', false),
                      const SizedBox(width: 20.0),
                      _buildPreferenceItem(Icons.cake, 'Doces', false),
                    ],
                  ),
                ),
              ),
                const SizedBox(height: 120.0),
              ]),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    ),
    );
  }

  Widget _buildPreferenceItem(IconData icon, String label, bool isSelected) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: isSelected
                ? Border.all(color: const Color(0xFFFF6961), width: 2)
                : Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: const Color(0xFFFF6961).withValues(alpha: 0.2),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Icon(
            icon,
            color: isSelected ? const Color(0xFFFF6961) : Colors.black54,
            size: 28,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
