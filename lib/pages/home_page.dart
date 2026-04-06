import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  
  int _selectedIndex = 0; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBody: true, 
      backgroundColor: const Color(0xFFFFE7E5), 
      
      
      body: Stack(
        children: [
          Center(
            child: Text(
              'tela $_selectedIndex',
              style: const TextStyle(color: Colors.black, fontSize: 24),
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
      ),

      
      bottomNavigationBar: _buildFloatingNavBar(),
    );
  }

  Widget _buildFloatingNavBar() {
    return SafeArea(
      child: Padding(
        
        padding: const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 24.0),
        child: Container(
          height: 75.0, 
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(50.0), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15.0,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              _buildNavItem(icon: Icons.house_outlined, index: 0),
              _buildNavItem(icon: Icons.shopping_cart_outlined, index: 1),
              _buildNavItem(icon: Icons.shopping_bag_outlined, index: 2),
              _buildNavItem(icon: Icons.person_outline, index: 3),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; 
        });
      },
      child: AnimatedContainer(
        
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24.0), 
        decoration: BoxDecoration(
          
          color: isSelected ? const Color(0xFFFFEBD9) : Colors.white, 
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 28.0,
          
          color: isSelected ? const Color(0xFFFF6961) : const Color(0xFFA0A0A0),
        ),
      ),
    );
  }
}