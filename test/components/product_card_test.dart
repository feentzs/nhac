import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhac/components/product_card.dart';

void main() {
  testWidgets('Deve exibir corretamente os dados do ProductCard', (WidgetTester tester) async {
    
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProductCard(
            imageUrl: 'https://via.placeholder.com/150', 
            name: 'Hambúrguer Teste',
            weight: '250g',
            price: 29.90,
          ),
        ),
      ),
    );

    expect(find.text('Hambúrguer Teste'), findsOneWidget);
    expect(find.text('250g'), findsOneWidget);
    
    expect(find.text('\$29.90'), findsOneWidget);

    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}