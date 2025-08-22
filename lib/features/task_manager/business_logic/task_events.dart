import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
}

class AddTask extends TaskEvent {
  final String description;

  const AddTask(this.description);

  @override
  List<Object> get props => [description];
}

class ToggleTask extends TaskEvent {
  final String taskId;

  const ToggleTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}