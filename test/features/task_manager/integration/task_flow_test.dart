// test/features/task_manager/integration/task_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_task_manager/main.dart';

void main() {
  testWidgets('complete task flow', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify initial state
    expect(find.text('Task Manager'), findsOneWidget);
    expect(find.text('No tasks yet!'), findsOneWidget);

    // Tap the '+' icon and trigger the dialog.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text('Add Task'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    // Enter text in the field
    await tester.enterText(find.byType(TextFormField), 'Test Task');
    await tester.pump();

    // Tap the Add button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify task is added
    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('No tasks yet!'), findsNothing);
  });
}