import 'package:flutter/material.dart';
import 'package:nhac/components/home_content.dart';
import 'package:nhac/components/profile_content.dart';
import 'package:nhac/controllers/cart_provider.dart';
import 'package:nhac/controllers/endereco_provider.dart';
import 'package:nhac/controllers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().iniciarEscutaUsuario();
      context.read<CartProvider>().iniciarEscutaCarrinho();
      context.read<EnderecoProvider>().iniciarEscutaEnderecos();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFFFE7E5),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const HomeContent(),
          _buildPlaceholderContent(1),
          _buildPlaceholderContent(2),
          const ProfileContent(),
        ],
      ),
      floatingActionButton: Selector<CartProvider, int>(
        selector: (context, provider) => provider.totalDeUnidades,
        builder: (context, quantidadeNoCarrinho, child) {
          if (quantidadeNoCarrinho == 0) return const SizedBox.shrink();

          return FloatingActionButton(
            onPressed: () {
              // context.push('/carrinho');
            },
            backgroundColor: Color(0xFF5D201C), 
            child: Badge(
              label: Text(quantidadeNoCarrinho.toString()),
              backgroundColor: Colors.red,
              child: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          );
        }
      ),
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  Widget _buildPlaceholderContent(int index) {
    return Stack(
      children: [
        Center(
          child: Text(
            'tela $index',
            style: const TextStyle(color: Color(0xFF5D201C), fontSize: 24),
          ),
        ),
        const Positioned(
          top: 257.0,
          left: 70.0,
          width: 232.0,
          height: 200.0,
          child: Image(
            image: AssetImage('assets/construction.gif'),
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingNavBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
        child: Container(
          height: 75.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF5D201C).withValues(alpha: 0.1),
                blurRadius: 15.0,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                  icon: Icons.house_outlined, label: 'Home', index: 0),
              _buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Carrinho',
                  index: 1),
              _buildNavItem(
                  icon: Icons.shopping_bag_outlined, label: 'N sei', index: 2),
              _buildNavItem(
                  icon: Icons.person_outline, label: 'Perfil', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon, required String label, required int index}) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20.0 : 12.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFEBD9) : Colors.transparent,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28.0,
              color: isSelected
                  ? const Color(0xFFFF6961)
                  : const Color(0xFFA0A0A0),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              child: SizedBox(
                width: isSelected ? null : 0,
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            color: Color(0xFFFF6961),
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}