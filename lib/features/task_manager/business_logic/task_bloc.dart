// lib/features/task_manager/business_logic/task_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_events.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_states.dart';
import 'package:tdd_task_manager/features/task_manager/data/models/task_model.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<ToggleTask>(_onToggleTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) {
    try {
      final newTask = Task(description: event.description);
      final updatedTasks = state is TaskLoaded
          ? [...(state as TaskLoaded).tasks, newTask]
          : [newTask];
      emit(TaskLoaded(updatedTasks));
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  void _onToggleTask(ToggleTask event, Emitter<TaskState> emit) {
    try {
      if (state is TaskLoaded) {
        final tasks = (state as TaskLoaded).tasks;
        final taskIndex = tasks.indexWhere((task) => task.id == event.taskId);
        
        if (taskIndex != -1) {
          final updatedTasks = List<Task>.from(tasks);
          updatedTasks[taskIndex] = updatedTasks[taskIndex].copyWith(
            isCompleted: !updatedTasks[taskIndex].isCompleted,
          );
          emit(TaskLoaded(updatedTasks));
        } else {
          emit(TaskError('Task not found'));
        }
      } else {
        emit(TaskError('Cannot toggle task: no tasks loaded'));
      }
    } catch (e) {
      emit(TaskError('Failed to toggle task: $e'));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) {
    try {
      if (state is TaskLoaded) {
        final tasks = (state as TaskLoaded).tasks;
        final taskIndex = tasks.indexWhere((task) => task.id == event.taskId);
        
        if (taskIndex != -1) {
          final updatedTasks = List<Task>.from(tasks);
          updatedTasks.removeAt(taskIndex);
          emit(TaskLoaded(updatedTasks));
        } else {
          emit(TaskError('Task not found'));
        }
      } else {
        emit(TaskError('Cannot delete task: no tasks loaded'));
      }
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }
}