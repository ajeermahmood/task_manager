import 'package:flutter_test/flutter_test.dart';
// import 'package:tdd_task_manager/features/task_manager/business_logic/task_states.dart';
import 'package:tdd_task_manager/features/task_manager/data/models/task_model.dart';

void main() {
  group('Task States', () {
    test('TaskInitial state', () {
      const state = TaskInitial();
      expect(state.props, isEmpty);
    });

    test('TaskLoaded state', () {
      final tasks = [Task(description: 'Test Task')];
      final state = TaskLoaded(tasks);
      expect(state.props, [tasks]);
    });

    test('TaskError state', () {
      const state = TaskError('Error message');
      expect(state.props, ['Error message']);
    });
  });
}