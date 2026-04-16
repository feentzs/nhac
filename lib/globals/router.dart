import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nhac/pages/bem_vindo.dart';
import 'package:nhac/pages/continuar_senha.dart';
import 'package:nhac/pages/email_cliente.dart';
import 'package:nhac/pages/insira_telefone.dart';
import 'package:nhac/pages/splash_screen.dart';
import 'package:nhac/bem_vindo_motoca.dart';
import 'package:nhac/pages/verificacao_numero.dart';
import 'package:nhac/pages/home_page.dart';
import 'package:nhac/pages/Cadastro/nome.dart';
import 'package:nhac/pages/Cadastro/senha.dart';
import 'package:nhac/services/auth_check.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

class _SlideRightToLeftPageRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  _SlideRightToLeftPageRoute({
    required this.child,
    required super.settings,
  });

  final Widget child;

  @override
  Widget buildContent(BuildContext context) => child;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 400);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    );
    var curvedSecondaryAnimation = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    );
    
    var enterTween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero);
    var exitTween = Tween(begin: Offset.zero, end: const Offset(-0.3, 0.0));
    
    Widget page = SlideTransition(
      position: enterTween.animate(curvedAnimation),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
    );

    return SlideTransition(
      position: exitTween.animate(curvedSecondaryAnimation),
      child: page,
    );
  }
}

class SlideRightToLeftPage<T> extends Page<T> {
  const SlideRightToLeftPage({
    required super.key,
    required this.child,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return _SlideRightToLeftPageRoute<T>(
      child: child,
      settings: this,
    );
  }
}

Page _buildSlideRightToLeftPage({
  required LocalKey key,
  required Widget child,
}) {
  return SlideRightToLeftPage(key: key, child: child);
}

@NowaGenerated()
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthCheck()),
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/home-page',
      pageBuilder: (context, state) => _buildSlideRightToLeftPage(
        key: state.pageKey,
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: '/bem-vindo',
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
    GoRoute(
      path: '/email-cliente',
      pageBuilder: (context, state) => _buildSlideRightToLeftPage(
        key: state.pageKey,
        child: const EmailCliente(),
      ),
    ),
   GoRoute(
      path: '/Cadastro/senha',
      pageBuilder: (context, state) {
        
        return _buildSlideRightToLeftPage(
          key: state.pageKey, child: const Senha(),
        );
      },
   ),
    GoRoute(
      path: '/Cadastro/nome',
      pageBuilder: (context, state) =>
          _buildSlideRightToLeftPage(key: state.pageKey, child: const Nome()),
    ),
    
    GoRoute(
      path: '/verificacao_numero',
      pageBuilder: (context, state) {
        final numeroRecebido = state.extra as String? ?? '';
        return _buildSlideRightToLeftPage(
          key: state.pageKey,
          child: VerificacaoNumero(numero: numeroRecebido),
        );
      },
    ),
    GoRoute(
      path: '/insira_telefone',
      pageBuilder: (context, state) => _buildSlideRightToLeftPage(
        key: state.pageKey,
        child: const InsiraTelefone(),
      ),
    ),
    GoRoute(
      path: '/continuar_senha',
      pageBuilder: (context, state) {

        return _buildSlideRightToLeftPage(
          key: state.pageKey, 
          child: const ContinuarSenha(),
        );
      },
    ),
    GoRoute(
      path: '/dados-pessoais',
      pageBuilder: (context, state) => _buildSlideRightToLeftPage(
        key: state.pageKey,
        child: const InsiraTelefone(),
      ),
    ),
  ],
);
