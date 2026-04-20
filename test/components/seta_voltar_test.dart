import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nhac/components/seta_voltar.dart';

void main() {
  testWidgets('Deve renderizar a SetaVoltar e navegar para a Home ao clicar', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/tela-teste',
      routes: [
        GoRoute(
          path: '/tela-teste',
          builder: (context, state) => const Scaffold(body: SetaVoltar()), 
        ),
        GoRoute(
          path: '/home-page',
          builder: (context, state) => const Scaffold(body: Text('Bem-vindo à Home!')), 
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(GestureDetector), findsWidgets);

    await tester.tap(find.byType(SetaVoltar));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo à Home!'), findsOneWidget);
  });
}