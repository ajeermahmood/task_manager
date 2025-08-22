
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:tdd_task_manager/features/task_manager/business_logic/task_bloc.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_events.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_states.dart';
import 'package:tdd_task_manager/features/task_manager/data/models/task_model.dart';

void main() {
  group('TaskBloc', () {
    late TaskBloc taskBloc;

    setUp(() {
      taskBloc = TaskBloc();
    });

    tearDown(() {
      taskBloc.close();
    });

    test('initial state is TaskInitial', () {
      expect(taskBloc.state, equals(const TaskInitial()));
    });

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoaded] when AddTask is added',
      build: () => TaskBloc(),
      act: (bloc) => bloc.add(const AddTask('Test Task')),
      expect: () => [isA<TaskLoaded>()],
      verify: (bloc) {
        final state = bloc.state as TaskLoaded;
        expect(state.tasks.length, 1);
        expect(state.tasks.first.description, 'Test Task');
        expect(state.tasks.first.isCompleted, false);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoaded] when ToggleTask is added to existing task',
      build: () => TaskBloc(),
      seed: () => TaskLoaded([Task(id: '1', description: 'Test Task')]),
      act: (bloc) => bloc.add(const ToggleTask('1')),
      expect: () => [isA<TaskLoaded>()],
      verify: (bloc) {
        final state = bloc.state as TaskLoaded;
        expect(state.tasks.length, 1);
        expect(state.tasks.first.isCompleted, true);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoaded] when DeleteTask is added',
      build: () => TaskBloc(),
      seed: () => TaskLoaded([Task(id: '1', description: 'Test Task')]),
      act: (bloc) => bloc.add(const DeleteTask('1')),
      expect: () => [isA<TaskLoaded>()],
      verify: (bloc) {
        final state = bloc.state as TaskLoaded;
        expect(state.tasks.isEmpty, true);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskError] when ToggleTask fails',
      build: () => TaskBloc(),
      seed: () => const TaskInitial(),
      act: (bloc) => bloc.add(const ToggleTask('non-existent-id')),
      expect: () => [isA<TaskError>()],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskError] when DeleteTask fails',
      build: () => TaskBloc(),
      seed: () => const TaskInitial(),
      act: (bloc) => bloc.add(const DeleteTask('non-existent-id')),
      expect: () => [isA<TaskError>()],
    );
  });
}