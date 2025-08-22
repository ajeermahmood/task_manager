import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_bloc.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_events.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_states.dart';

void main() {
  group('TaskBloc Edge Cases', () {
    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoaded] with empty task description',
      build: () => TaskBloc(),
      act: (bloc) => bloc.add(const AddTask('')),
      expect: () => [isA<TaskLoaded>()],
      verify: (bloc) {
        final state = bloc.state as TaskLoaded;
        expect(state.tasks.length, 1);
        expect(state.tasks.first.description, '');
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskError] when toggling non-existent task from initial state',
      build: () => TaskBloc(),
      act: (bloc) => bloc.add(const ToggleTask('non-existent')),
      expect: () => [isA<TaskError>()],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskError] when deleting non-existent task from initial state',
      build: () => TaskBloc(),
      act: (bloc) => bloc.add(const DeleteTask('non-existent')),
      expect: () => [isA<TaskError>()],
    );

    blocTest<TaskBloc, TaskState>(
      'maintains task order after multiple operations',
      build: () => TaskBloc(),
      act: (bloc) async {
        // Add three tasks
        bloc.add(const AddTask('Task 1'));
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.add(const AddTask('Task 2'));
        await Future.delayed(const Duration(milliseconds: 10));
        bloc.add(const AddTask('Task 3'));
        await Future.delayed(const Duration(milliseconds: 10));

        // Get the task IDs after all tasks are added
        final state = bloc.state as TaskLoaded;
        final task2Id = state.tasks[1].id; // Second task
        final task1Id = state.tasks[0].id; // First task

        // Toggle second task
        bloc.add(ToggleTask(task2Id));
        await Future.delayed(const Duration(milliseconds: 10));

        // Delete first task
        bloc.add(DeleteTask(task1Id));
      },
      expect:
          () => [
            isA<TaskLoaded>(), // After AddTask 1
            isA<TaskLoaded>(), // After AddTask 2
            isA<TaskLoaded>(), // After AddTask 3
            isA<TaskLoaded>(), // After ToggleTask
            isA<TaskLoaded>(), // After DeleteTask
          ],
      verify: (bloc) {
        final state = bloc.state as TaskLoaded;
        expect(state.tasks.length, 2);
        expect(state.tasks[0].description, 'Task 2');
        expect(state.tasks[0].isCompleted, true);
        expect(state.tasks[1].description, 'Task 3');
        expect(state.tasks[1].isCompleted, false);
      },
    );
  });
}
