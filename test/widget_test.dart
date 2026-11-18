import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:emad_task1/main.dart';

void main() {
  testWidgets('aggiunta, validazione, completamento ed eliminazione',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.textContaining('Nessuna attività'), findsOneWidget);
    expect(find.text('Completate: 0 / 0'), findsOneWidget);

    // Titolo mancante
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Conferma'));
    await tester.pump();
    expect(find.text('Il titolo è obbligatorio'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Studiare');
    await tester.pump();
    expect(find.text('Il titolo è obbligatorio'), findsNothing);

    // Creazione
    await tester.tap(find.text('Conferma'));
    await tester.pumpAndSettle();
    expect(find.text('Studiare'), findsOneWidget);
    expect(find.text('Attività aggiunta'), findsOneWidget);

    // Completamento
    await tester.tap(find.text('Studiare'));
    await tester.pump();
    expect(find.text('Completate: 1 / 1'), findsOneWidget);

    // Eliminazione: rinuncia poi conferma
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annulla'));
    await tester.pumpAndSettle();
    expect(find.text('Studiare'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Elimina'));
    await tester.pumpAndSettle();
    expect(find.text('Studiare'), findsNothing);
    expect(find.text('Completate: 0 / 0'), findsOneWidget);
  });
}
