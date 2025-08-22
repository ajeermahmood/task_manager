import 'package:equatable/equatable.dart';
import 'package:tdd_task_manager/features/task_manager/data/models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();
}

class TaskInitial extends TaskState {
  const TaskInitial();

  @override
  List<Object> get props => [];
}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}