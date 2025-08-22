import 'package:flutter_test/flutter_test.dart';
// import 'package:task_manager/features/task_manager/business_logic/task_event.dart';

void main() {
  group('Task Events', () {
    test('AddTask event props', () {
      const event = AddTask('Test Task');
      expect(event.props, ['Test Task']);
    });

    test('ToggleTask event props', () {
      const event = ToggleTask('task-123');
      expect(event.props, ['task-123']);
    });

    test('DeleteTask event props', () {
      const event = DeleteTask('task-123');
      expect(event.props, ['task-123']);
    });
  });
}