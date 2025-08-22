import 'package:flutter_test/flutter_test.dart';
// import 'package:tdd_task_manager/features/task_manager/data/models/task_model.dart';

void main() {
  group('Task Model', () {
    test('should create a task with default values', () {
      final task = Task();
      expect(task.id, isNotNull);
      expect(task.description, isEmpty);
      expect(task.isCompleted, isFalse);
    });

    test('should create a task with given values', () {
      final task = Task(
        id: '1',
        description: 'Test Task',
        isCompleted: true,
      );
      expect(task.id, '1');
      expect(task.description, 'Test Task');
      expect(task.isCompleted, isTrue);
    });

    test('should copy a task with new values', () {
      final original = Task(id: '1', description: 'Original', isCompleted: false);
      final copied = original.copyWith(description: 'Updated', isCompleted: true);
      
      expect(copied.id, '1');
      expect(copied.description, 'Updated');
      expect(copied.isCompleted, isTrue);
    });
  });
}