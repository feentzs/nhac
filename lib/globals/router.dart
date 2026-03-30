import 'package:go_router/go_router.dart';
import 'package:nhac/pages/bem_vindo.dart';
import 'package:nhac/pages/splash_screen.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home-page', builder: (context, state) => const BemVindo()),
  ],
);
