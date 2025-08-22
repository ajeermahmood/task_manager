import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_bloc.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_events.dart';
import 'package:tdd_task_manager/features/task_manager/business_logic/task_states.dart';
import 'package:tdd_task_manager/features/task_manager/presentation/widgets/task_list.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskInitial) {
            return const Center(child: Text('No tasks yet!'));
          } else if (state is TaskLoaded) {
            return TaskList(
              tasks: state.tasks,
              onToggle: (id) => context.read<TaskBloc>().add(ToggleTask(id)),
              onDelete: (id) => context.read<TaskBloc>().add(DeleteTask(id)),
            );
          } else if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: const Text('Add Task'),
            content: TextFormField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter task description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task description';
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    final description = textController.text.trim();
                    // Use the original context that has access to the BLoC
                    context.read<TaskBloc>().add(AddTask(description));
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}