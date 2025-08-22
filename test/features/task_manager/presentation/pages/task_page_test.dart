import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_bloc.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_events.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_states.dart';
import 'package:tdd_task_manager/features/task_manager/data/models/task_model.dart';
import 'package:tdd_task_manager/features/task_manager/presentation/pages/task_page.dart';

class MockTaskBloc extends Mock implements TaskBloc {}

// Create fake classes for fallback values
class FakeTaskEvent extends Fake implements TaskEvent {}
class FakeTaskState extends Fake implements TaskState {}

void main() {
  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(FakeTaskEvent());
    registerFallbackValue(FakeTaskState());
  });

  group('TaskPage', () {
    late MockTaskBloc mockTaskBloc;

    setUp(() {
      mockTaskBloc = MockTaskBloc();
      
      // Mock the stream
      when(() => mockTaskBloc.stream).thenAnswer((_) => Stream<TaskState>.empty());
      
      // Mock the state getter
      when(() => mockTaskBloc.state).thenReturn(const TaskInitial());
      
      // Mock the add method with specific event types
      when(() => mockTaskBloc.add(any(that: isA<AddTask>()))).thenReturn(null);
      when(() => mockTaskBloc.add(any(that: isA<ToggleTask>()))).thenReturn(null);
      when(() => mockTaskBloc.add(any(that: isA<DeleteTask>()))).thenReturn(null);
      
      // Mock the close method
      when(() => mockTaskBloc.close()).thenAnswer((_) async {});
    });

    testWidgets('displays initial state', (WidgetTester tester) async {
      when(() => mockTaskBloc.state).thenReturn(const TaskInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: const TaskPage(),
          ),
        ),
      );

      expect(find.text('Task Manager'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('No tasks yet!'), findsOneWidget);
    });

    testWidgets('displays tasks when loaded', (WidgetTester tester) async {
      final tasks = [Task(id: '1', description: 'Test Task')];
      when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: const TaskPage(),
          ),
        ),
      );

      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('displays error state', (WidgetTester tester) async {
      when(() => mockTaskBloc.state).thenReturn(const TaskError('Test error'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: const TaskPage(),
          ),
        ),
      );

      expect(find.text('Error: Test error'), findsOneWidget);
    });

    testWidgets('shows add task dialog when FAB is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: const TaskPage(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add Task'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}