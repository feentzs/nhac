import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhac/pages/bem_vindo.dart';
import 'package:nhac/pages/splash_screen.dart';
import 'package:nhac/bem_vindo_motoca.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

CustomTransitionPage _buildSlideRightToLeftPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      
    
      var enterTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutQuart));

   
      var exitTween = Tween(begin: Offset.zero, end: const Offset(-0.3, 0.0))
          .chain(CurveTween(curve: Curves.easeOutQuart));

      
      return SlideTransition(
        position: secondaryAnimation.drive(exitTween), 
        child: SlideTransition(
          position: animation.drive(enterTween),
          child: child,
        ),
      );
    },
  );
}

@NowaGenerated()
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash', 
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home-page', 
      pageBuilder: (context, state) => _buildSlideRightToLeftPage(
        key: state.pageKey,
        child: const BemVindo(),
      ),
    ),
    GoRoute(
      path: '/bem-vindo-motoca',
      pageBuilder: (context, state) => _buildSlideRightToLeftPage(
        key: state.pageKey,
        child: const BemVindoMotoca(),
      ),
    ),
  ],
);