import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:tdd_task_manager/features/task_manager/presentation/widgets/task_list.dart';
import 'package:tdd_task_manager/features/task_manager/data/models/task_model.dart';

void main() {
  group('TaskList Widget', () {
    testWidgets('displays empty message when no tasks', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskList(
              tasks: const [],
              onToggle: (String id) {},
              onDelete: (String id) {},
            ),
          ),
        ),
      );

      // Look for any text that indicates empty state
      // Common empty state texts:
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              RegExp(
                r'no.*task|empty|add.*task',
                caseSensitive: false,
              ).hasMatch(widget.data!),
        ),
        findsOneWidget,
        reason: 'Should display some empty state message',
      );

      // OR look for a Center widget with text (common pattern)
      final centerFinder = find.byType(Center);
      expect(centerFinder, findsOneWidget);

      final textInCenter = find.descendant(
        of: centerFinder,
        matching: find.byType(Text),
      );
      expect(textInCenter, findsOneWidget);
    });

    testWidgets('displays tasks when provided', (WidgetTester tester) async {
      final tasks = [
        Task(id: '1', description: 'Task 1'),
        Task(id: '2', description: 'Task 2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskList(
              tasks: tasks,
              onToggle: (String id) {},
              onDelete: (String id) {},
            ),
          ),
        ),
      );

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('No tasks yet!'), findsNothing);
    });

    testWidgets('calls onToggle when checkbox is tapped', (
      WidgetTester tester,
    ) async {
      final tasks = [Task(id: '1', description: 'Test Task')];
      var toggleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskList(
              tasks: tasks,
              onToggle: (String id) {
                toggleCalled = true;
                expect(id, '1');
              },
              onDelete: (String id) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(toggleCalled, isTrue);
    });

    testWidgets('calls onDelete when delete button is tapped', (
      WidgetTester tester,
    ) async {
      final tasks = [Task(id: '1', description: 'Test Task')];
      var deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskList(
              tasks: tasks,
              onToggle: (String id) {},
              onDelete: (String id) {
                deleteCalled = true;
                expect(id, '1');
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(deleteCalled, isTrue);
    });

    testWidgets('shows completed tasks with strikethrough', (
      WidgetTester tester,
    ) async {
      final tasks = [
        Task(id: '1', description: 'Completed Task', isCompleted: true),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskList(
              tasks: tasks,
              onToggle: (String id) {},
              onDelete: (String id) {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Completed Task'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });
  });
}
